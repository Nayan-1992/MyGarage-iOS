import SwiftUI

struct HomeView: View {
    @State private var workshops: [Workshop] = []
    @State private var loading = false
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        VStack {
            HStack {
                Text("Workshops").font(.title2).bold()
                Spacer()
                Button("Logout") { auth.logout() }
            }
            .padding()

            if loading { ProgressView() }

            List(workshops) { w in
                NavigationLink(destination: BookingView(workshop: w)) {
                    VStack(alignment: .leading) {
                        Text(w.name).bold()
                        if let addr = w.address { Text(addr).font(.caption) }
                    }
                }
            }
        }
        .task {
            loading = true
            do {
                workshops = try await ApiService.fetchWorkshops()
            } catch {
                workshops = []
            }
            loading = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AuthManager())
    }
}
