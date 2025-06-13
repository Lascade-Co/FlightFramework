//
//  FlightFramework.swift
//  FlightFramework
//
//  Created by Rohit T P on 13/06/25.
//

import Foundation

import FlightSwaggerClient
import TravelCommon


public class FlightSession {
    private var searchId: String?
    private let appCode: String
    
    public init(appCode: String) {
        self.appCode = appCode
    }
    
    
    public func getAutocomplete(query: String) async -> [FlightAutocompleteItem] {
        await withCheckedContinuation { continuation in
            FlightSwaggerClient.ApiAPI.apiAutocompleteList(
                country: User.shared.getEffectiveCountry(),
                search: query,
                language: User.shared.getEffectiveLanguage()
            ) { data, error in
                if let error = error {
#if DEBUG
                    print("Autocomplete error: \(error)")
                    print("Response data: \(String(describing: data))")
#endif
                }
                
                continuation.resume(returning: data?.data ?? [])
            }
        }
    }
    
    public func poll(requestBody: FlightPollRequestBodyModel, page: Int, limit: Int = 30) async throws -> FlightPollResponseBodyModel {
        if(self.searchId == nil) {
            throw UnhandledErrors.searchNotStarted
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            FlightSwaggerClient.ApiAPI.apiPollCreate(data: requestBody, searchId: self.searchId!) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let data = data {
                    continuation.resume(returning: data)
                }
                else {
                    continuation.resume(throwing: UnhandledErrors.toastableError(toast: "No results found", log: "Empty response from server"))
                }
            }
        }
    }
    
    public func searchInit(requestBody: FlightFlightSearchRequestBodyModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let userId = try? User.shared.getUserId()
            guard userId != nil else {
                continuation.resume(throwing: UnhandledErrors.userNotSet)
                return
            }
            FlightSwaggerClient.ApiAPI.apiSearchCreate(
                data: requestBody,
                country: User.shared.getEffectiveCountry(),
                userId: userId!,
                language: User.shared.getEffectiveLanguage(),
                appCode: self.appCode
            ) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let searchId = data?.searchId {
                    self.searchId = searchId
                    continuation.resume()
                }
                else {
                    continuation.resume(throwing: UnhandledErrors.toastableError(toast: "Server error", log: "SearchId not returned"))
                }
            }
        }
    }
    
}
