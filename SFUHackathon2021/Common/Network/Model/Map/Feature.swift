import Foundation

struct Feature: Codable, Equatable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Codable, Equatable {
    let characteristics: [Int]
}

struct Geometry: Codable, Equatable {
    let type: String
    let coordinates: [Double]
}
