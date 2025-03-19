//
//  SignInView.swift
//  Social Media for Lifting
//
//  Created by Matthew on 3/19/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false  // Persistent login state

    var body: some View {
        VStack {
            Text("Welcome lifter!")
                .font(.largeTitle)
                .padding()

            SignInWithAppleButton(.signIn, onRequest: configureRequest, onCompletion: handleCompletion)
                .frame(width: 280, height: 50)
                .signInWithAppleButtonStyle(.black)
                .cornerRadius(10)
        }
    }

    private func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]  // Request user's name and email
    }

    private func handleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                print("Apple Sign-In Success: \(userIdentifier)")

                // Store login status
                isSignedIn = true
            }
        case .failure(let error):
            print("Apple Sign-In Failed: \(error.localizedDescription)")
        }
    }
}

struct SignIn_View: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
