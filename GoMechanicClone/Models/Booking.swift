import Foundation

struct Booking: Codable, Identifiable {
    var id: Int?
    var userId: Int?
    var workshopId: Int
    var serviceId: Int?
    var scheduledAt: String?
}
