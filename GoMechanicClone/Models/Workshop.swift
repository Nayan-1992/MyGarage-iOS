import Foundation

struct Workshop: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String?
    let lat: Double?
    let lng: Double?
}
