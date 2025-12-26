import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        VStack(spacing: 16) {
            if let user = auth.user {
                Text(user.name ?? "User")
                    .font(.title)
                Text(user.phone ?? "")
            } else {
                Text("No user")
            }
            Button("Logout") { auth.logout() }
            Spacer()
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthManager())
    }
}
