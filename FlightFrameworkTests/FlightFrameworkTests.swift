//
//  FlightFrameworkTests.swift
//  FlightFrameworkTests
//
//  Created by Rohit T P on 16/06/25.
//

import Testing
@testable import FlightFramework
import FlightSwaggerClient
import TravelCommon

struct FlightFrameworkTests {
    
    init() {
        User.shared.setUserId("0")
    }
    
    @Test
    func pollBeforeSearchThrows() async throws {
        let session = FlightSession(appCode: "ALL0")
        let emptyBody = FlightPollRequestBodyModel(
            durationMax: nil,
            stopCountMax: nil,
            arrivalDepartureRanges: nil,
            iataCodesExclude: nil,
            iataCodesInclude: nil,
            sortBy: nil,
            sortOrder: nil,
            agencyExclude: nil,
            agencyInclude: nil,
            priceMin: nil,
            priceMax: nil
        )
        
        do {
            _ = try await session.poll(requestBody: emptyBody, page: 1)
            #expect(Bool(false), "poll should throw before searchInit is called")
        } catch {
            #expect(error as? UnhandledErrors == .searchNotStarted)
        }
    }
    
    @Test
    func autocompleteReturnsResults() async throws {
        let session = FlightSession(appCode: "ALL0")
        
        guard let firstResult = (await session.getAutocomplete(query: "Dubai")).first else {
            #expect(Bool(false), "Autocomplete did not return any results")
            return
        }
        
        #expect(firstResult.iataCode.uppercased() == "DXB")
    }
    
    @Test
    func searchInitReturnsSearchId() async throws {
        let session = FlightSession(appCode: "ALL0")
        let searchBody =  createSearchBody(session: session, date: "2025-12-28")
        
        try await session.searchInit(requestBody: searchBody)
    }
    
    /// End‑to‑end search test. It queries two airports, initializes a search,
    /// then polls until results are cached.
    @Test
    func searchFlowReturnsResults() async throws {
        let session = FlightSession(appCode: "ALL0")
        let searchBody =  createSearchBody(session: session, date: "2025-12-25")
        
        try await session.searchInit(requestBody: searchBody)
        
        // 3. Poll until cache == true
        let pollBody = FlightPollRequestBodyModel(
            durationMax: nil,
            stopCountMax: nil,
            arrivalDepartureRanges: nil,
            iataCodesExclude: nil,
            iataCodesInclude: nil,
            sortBy: nil,
            sortOrder: nil,
            agencyExclude: nil,
            agencyInclude: nil,
            priceMin: nil,
            priceMax: nil
        )
        
        var response: FlightPollResponseBodyModel? = nil
        while response?.cache != true {
            response = try await session.poll(requestBody: pollBody, page: 1)
            try await Task.sleep(nanoseconds: 1000_000_000)
        }
        
        #expect(response!.results.count > 0)
    }
    
    private func createSearchBody(session: FlightSession, date: String) -> FlightFlightSearchRequestBodyModel {
        let leg = FlightLegType(origin: "DXB",
                                destination: "LON",
                                date: date)
        return FlightFlightSearchRequestBodyModel(
            legs: [leg],
            cabinClass: "economy",
            adults: 1,
            childrenAges: []
        )
    }
}
