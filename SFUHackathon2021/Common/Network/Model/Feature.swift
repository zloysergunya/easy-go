import Foundation

struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Codable {
    let characteristics: [Int]
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}
