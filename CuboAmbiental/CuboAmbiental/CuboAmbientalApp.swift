import SwiftUI

@main
struct CuboAmbientalApp: App {
    var body: some Scene {
        // Vista principal del app
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)

        // Espacio inmersivo 3D
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
