//
//  princeApp.swift
//  Shared
//
//  Created by Scott Dodge on 9/26/20.
//

import SwiftUI

@main
struct PrinceApp: App {
    @StateObject private var model = PrinceModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
//        .commands {
//            SidebarCommands()
//        }
    }
}
