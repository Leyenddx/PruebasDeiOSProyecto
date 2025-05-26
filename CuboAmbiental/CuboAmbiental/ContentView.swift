//
//  ContentView.swift
//  CuboAmbiental
//
//  Created by alumno on 5/16/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        @Environment(\.openImmersiveSpace) var openImmersiveSpace
        
        VStack {
            Text("Bienvenido a tu Cubo Ambiental")
                .font(.largeTitle)
                .padding()

            Button("Explorar cubos") {
                Task {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                    }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
}

#Preview {
    ContentView()
}
