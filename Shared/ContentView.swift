//
//  ContentView.swift
//  Shared
//
//  Created by Scott Dodge on 9/26/20.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @EnvironmentObject private var model: PrinceModel

    var body: some View {
        VStack {
            ScannerView()
            
//            if !model.hasAccount {
//                Text("Sign up to access on all devices")
//                    .font(Font.headline.bold())
//
//                SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: model.authorizeUser)
//                    .frame(minWidth: 100, maxWidth: 400)
//                    .padding(.horizontal, 20)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
