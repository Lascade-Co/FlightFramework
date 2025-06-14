//
//  Errors.swift
//  FlightFramework
//
//  Created by Rohit T P on 14/06/25.
//

public enum UnhandledErrors: Error {
    case userNotSet
    case apiError(String)
    case toastableError(toast: String, error: ToastableErrorType)
    case searchNotStarted
    
    public enum ToastableErrorType {
        case nullResponse
        case searchIdMissing
        case searchExpired
    }
}
