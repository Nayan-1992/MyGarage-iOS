import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var phone = ""
    @State private var otp = ""
    @State private var showOTP = false
    @State private var errorMsg = ""
    @State private var loading = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.largeTitle)
                .bold()

            TextField("Phone", text: $phone)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if showOTP {
                TextField("OTP", text: $otp)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }

            if loading { ProgressView() }

            Button(showOTP ? "Verify OTP" : "Request OTP") {
                Task {
                    loading = true
                    do {
                        if showOTP {
                            try await auth.verify(phone: phone, otp: otp)
                        } else {
                            _ = try await auth.requestOtp(phone: phone)
                            showOTP = true
                        }
                    } catch {
                        errorMsg = "Request failed"
                    }
                    loading = false
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            if !errorMsg.isEmpty { Text(errorMsg).foregroundColor(.red) }

            Spacer()
        }
        .padding(.top, 60)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthManager())
    }
}
