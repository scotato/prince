//
//  PrinceModel.swift
//  Prince
//
//  Created by Scott Dodge on 9/28/20.
//

import AuthenticationServices

class PrinceModel: ObservableObject {
    @Published private(set) var host: String?
    @Published private(set) var auth: String?
    
    var hasAccount: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return userCredential != nil
        #endif
    }

    let defaults = UserDefaults(suiteName: "group.goldilocks.design.prince")

    private var userCredential: String? {
        get { defaults?.string(forKey: "UserCredential") }
        set { defaults?.setValue(newValue, forKey: "UserCredential") }
    }
    
    private var storedHost: String? {
        get { defaults?.string(forKey: "Host") }
        set {
            defaults?.setValue(newValue, forKey: "Host")
            host = newValue
        }
    }
    
    private var storedAuth: String? {
        get { defaults?.string(forKey: "Auth") }
        set {
            defaults?.setValue(newValue, forKey: "Auth")
            auth = newValue
        }
    }

    init() {
        self.host = self.storedHost
        self.auth = self.storedAuth
        guard let user = userCredential else { return }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: user) { state, error in
            if state == .authorized || state == .transferred {
                DispatchQueue.main.async {
                    self.host = self.storedHost
                    self.auth = self.storedAuth
                }
            }
        }
    }
}

// MARK: - PrinceModel API

extension PrinceModel {
    func storeHost(_ host: String) {
        storedHost = host
    }
    
    func storeAuth(_ auth: String) {
        storedAuth = auth
    }

    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result, let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            if case .failure(let error) = result {
                print("Authentication error: \(error.localizedDescription)")
            }
            return
        }
        DispatchQueue.main.async {
            self.userCredential = credential.user
        }
    }
}
