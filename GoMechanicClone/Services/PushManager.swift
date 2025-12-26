import Foundation
import UserNotifications

class PushManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = PushManager()

    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return try await withCheckedThrowingContinuation { cont in
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let e = error { cont.resume(throwing: e); return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                cont.resume(returning: granted)
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Task {
            do {
                try await ApiService.registerFcmToken(token: token)
            } catch {
                print("Failed to register token: \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    // UNUserNotificationCenterDelegate simple handler
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
