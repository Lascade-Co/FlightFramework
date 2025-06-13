//
//  FlightFramework.swift
//  FlightFramework
//
//  Created by Rohit T P on 13/06/25.
//

import Foundation

import FlightSwaggerClient


class FlightSession {
    private var country: String
    private var language: String
    private var appCode: String
    
    private var userId: String?
    private var searchId: String?
    
    init(appCode: String, country: String, language: String) {
        self.country = country
        self.language = language
        self.appCode = appCode
    }
    
    public func setUserId(_ userId: String) {
        self.userId = userId
    }
    
    public func getAutocomplete(query: String) async -> [FlightAutocompleteItem] {
        await withCheckedContinuation { continuation in
            FlightSwaggerClient.ApiAPI.apiAutocompleteList(
                country: self.country,
                search: query,
                language: self.language
            ) { data, error in
                if let error = error {
                    print("Autocomplete error: \(error)")
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
        if self.userId == nil {
            throw UnhandledErrors.userNotSet
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            FlightSwaggerClient.ApiAPI.apiSearchCreate(data: requestBody, country: self.country, userId: self.userId!, language: self.language, appCode: self.appCode) { data, error in
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
