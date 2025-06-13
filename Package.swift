// swift-tools-version:5.5
//
//  Package.swift
//  FlightFramework
//
//  Created by Rohit T P on 14/06/25.
//
import PackageDescription

let package = Package(
    name: "FlightFramework",
    platforms: [
        .iOS("16.0.0"),
        .macOS("14.0.0"),
    ],
    products: [
        .library(
            name: "FlightFramework",
            targets: ["FlightFramework"]),
    ],
    dependencies: [
        // Add FlightSwaggerClient dependency
        .package(url: "https://github.com/Lascade-Co/FlightSwaggerClient.git", .branch("main")),
        .package(url: "https://github.com/Lascade-Co/TravelCommon.git", .branch("main"))
        // OR if using local package:
        // .package(path: "../FlightSwaggerClient")
    ],
    targets: [
        .target(
            name: "FlightFramework",
            dependencies: ["FlightSwaggerClient", "TravelCommon"],
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
