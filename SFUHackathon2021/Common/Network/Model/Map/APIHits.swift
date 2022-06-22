import Foundation

struct APIHits: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let point: Point
    let name: String
    let country: String
    let city: String?
    let osm_id: Int
    let housenumber: String?
}

struct Point: Codable, Equatable {
    let lat: Double
    let lng: Double
}
