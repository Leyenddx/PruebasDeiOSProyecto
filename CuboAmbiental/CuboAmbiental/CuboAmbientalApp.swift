//
//  CuboAmbientalApp.swift
//  CuboAmbiental
//
//  Created by alumno on 5/16/25.
//

import SwiftUI

@main
struct CuboAmbientalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
