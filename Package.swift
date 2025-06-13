//
//  Package.swift
//  FlightFramework
//
//  Created by Rohit T P on 14/06/25.
//

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FlightFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FlightFramework",
            targets: ["FlightFramework"]),
    ],
    dependencies: [
        // Add FlightSwaggerClient dependency
        .package(url: "https://github.com/Lascade-Co/FlightSwaggerClient.git", from: "1.0.0")
        // OR if using local package:
        // .package(path: "../FlightSwaggerClient")
    ],
    targets: [
        .target(
            name: "FlightFramework",
            dependencies: ["FlightSwaggerClient"],
            path: "FlightFramework",
                        swiftSettings: [
                            .unsafeFlags([
                                "-enable-library-evolution",
                                "-emit-module-interface"
                            ])
                        ]
        ),
    ]
)
