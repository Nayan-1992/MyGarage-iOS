import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var user: User? = nil
    @Published var isAuthenticated: Bool = false

    func requestOtp(phone: String) async throws -> String {
        return try await ApiService.login(phone: phone)
    }

    func verify(phone: String, otp: String) async throws {
        let u = try await ApiService.verifyOtp(phone: phone, otp: otp)
        DispatchQueue.main.async {
            self.user = u
            self.isAuthenticated = true
        }
    }

    func logout() {
        user = nil
        isAuthenticated = false
    }
}
