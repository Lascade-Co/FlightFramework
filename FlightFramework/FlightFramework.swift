//
//  FlightFramework.swift
//  FlightFramework
//
import Foundation
import FlightSwaggerClient
import TravelCommon

// MARK: - FlightSession
public class FlightSession {
    
    // MARK: Stored state
    private var searchId: String?
    private var validUntil: Date?                 // ← NEW
    
    private let appCode: String
    private let searchValidFor: Int
    
    // MARK: Init
    public init(appCode: String, searchValidFor: Int = 15 * 60 * 60) {
        self.appCode = appCode
        self.searchValidFor = searchValidFor
    }
    
    // MARK: Autocomplete -----------------------------------------------------
    public func getAutocomplete(query: String) async -> [FlightAutocompleteItem] {
        await withCheckedContinuation { continuation in
            ApiAPI.apiAutocompleteList(
                country: User.shared.getEffectiveCountry(),
                search: query,
                language: User.shared.getEffectiveLanguage()
            ) { data, error in
                
#if DEBUG
                if let error = error {
                    print("Autocomplete error:", error)
                    print("Response data:", String(describing: data))
                }
#endif
                continuation.resume(returning: data?.data ?? [])
            }
        }
    }
    
    // MARK: Poll -------------------------------------------------------------
    public func poll(requestBody: FlightPollRequestBodyModel, page: Int, limit: Int = 30) async throws -> FlightPollResponseBodyModel {
        // 1. Preconditions
        guard searchId != nil else {
            throw UnhandledErrors.searchNotStarted
        }
        if let expiry = validUntil, Date() > expiry {
            throw UnhandledErrors.toastableError(
                toast: "Search expired. Please start a new search.",
                error: .searchExpired
            )
        }
        
        // 2. Network call
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
                    continuation.resume(throwing: UnhandledErrors.toastableError(toast: "Failded to fetch results", error: .nullResponse))
                }
            }
        }
    }
    
    // MARK: Search-init ------------------------------------------------------
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
                
                guard let resp = data
                else {
                    continuation.resume(
                        throwing: UnhandledErrors.toastableError(
                            toast: "Server error",
                            error: .searchIdMissing
                        )
                    )
                    return
                }
                
                // Persist ID and expiry
                self.searchId = resp.searchId
                self.validUntil = Date().addingTimeInterval(TimeInterval(self.searchValidFor))
                continuation.resume()
            }
        }
    }
}
