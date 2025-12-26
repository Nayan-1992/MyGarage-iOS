import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let status: String
    let data: T?
    let message: String?
}

struct ApiService {
    static func login(phone: String) async throws -> String {
        // Example: POST /api/v1/auth/request-otp
        struct Resp: Decodable { let otp: String? }
        let payload = ["phone": phone]
        let body = try JSONEncoder().encode(payload)
        let r: ApiResponse<Resp> = try await NetworkClient.shared.request(path: "api/v1/auth/request-otp", method: "POST", body: body)
        return r.data?.otp ?? ""
    }

    static func verifyOtp(phone: String, otp: String) async throws -> User {
        struct RespUser: Decodable { let user: User }
        let payload = ["phone": phone, "otp": otp]
        let body = try JSONEncoder().encode(payload)
        let r: ApiResponse<User> = try await NetworkClient.shared.request(path: "api/v1/auth/verify-otp", method: "POST", body: body)
        if let u = r.data { return u }
        throw NetworkError.invalidResponse
    }

    static func fetchWorkshops() async throws -> [Workshop] {
        let r: ApiResponse<[Workshop]> = try await NetworkClient.shared.request(path: "api/v1/workshops")
        return r.data ?? []
    }

    static func createBooking(_ booking: Booking) async throws -> Booking {
        let body = try JSONEncoder().encode(booking)
        let r: ApiResponse<Booking> = try await NetworkClient.shared.request(path: "api/v1/bookings", method: "POST", body: body)
        if let b = r.data { return b }
        throw NetworkError.invalidResponse
    }

    static func registerFcmToken(token: String) async throws {
        let payload = ["token": token]
        let body = try JSONEncoder().encode(payload)
        let _: ApiResponse<EmptyResponse> = try await NetworkClient.shared.request(path: "api/v1/users/register-fcm", method: "POST", body: body)
    }
}

struct EmptyResponse: Decodable {}
