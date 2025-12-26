import Foundation

struct User: Codable, Identifiable {
    let id: Int?
    var phone: String?
    var name: String?
    var role: String?
}
