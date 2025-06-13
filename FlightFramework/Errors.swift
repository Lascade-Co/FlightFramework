//
//  Errors.swift
//  FlightFramework
//
//  Created by Rohit T P on 14/06/25.
//

enum UnhandledErrors: Error {
    case userNotSet
    case apiError(String)
    case toastableError(toast: String, log: String)
    case searchNotStarted
}
