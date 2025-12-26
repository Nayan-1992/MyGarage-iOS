import SwiftUI

struct BookingView: View {
    let workshop: Workshop
    @State private var scheduledAt = ""
    @State private var loading = false
    @State private var resultMsg = ""

    var body: some View {
        VStack(spacing: 16) {
            Text(workshop.name).font(.title).bold()
            if let addr = workshop.address { Text(addr) }

            TextField("Schedule (ISO) e.g. 2025-12-30T10:00:00Z", text: $scheduledAt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if loading { ProgressView() }

            Button("Create Booking") {
                Task {
                    loading = true
                    do {
                        let booking = Booking(id: nil, userId: nil, workshopId: workshop.id, serviceId: nil, scheduledAt: scheduledAt)
                        _ = try await ApiService.createBooking(booking)
                        resultMsg = "Booking created"
                    } catch {
                        resultMsg = "Failed"
                    }
                    loading = false
                }
            }
            .buttonStyle(.borderedProminent)

            if !resultMsg.isEmpty { Text(resultMsg) }
            Spacer()
        }
        .padding()
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(workshop: Workshop(id: 1, name: "Demo", address: "Addr", lat: nil, lng: nil))
    }
}
