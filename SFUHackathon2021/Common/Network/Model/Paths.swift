import Foundation
import PinLayout

struct APIPaths: Codable {
    let paths: [Points]
}

struct Points: Codable {
    let points: PathPoints
}

struct PathPoints: Codable {
    let coordinates: [[Double]]
}
