//
//  ContentView.swift
//  CuboAmbiental
//
//  Created by alumno on 5/16/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

        var body: some View {
            RealityView { content in
                if let cubeEntity = try? await Entity(named: "caja") {
                    
                    // Añade el ibjeto al espacio de contenido
                    content.add(cubeEntity)
                    
                    // Posición inicial frente al usuario
                    cubeEntity.position = [0, 0.5, -0.5]
                    
                    // Anclar a plano horizontal
                    cubeEntity.components.set(
                        AnchoringComponent(
                            AnchoringComponent.Target.plane(
                                .horizontal,
                                classification: .any,
                                minimumBounds: [0.1, 0.1]
                            )
                        )
                    )
                    
                    // Colisiones para poder agarrarlo y para físicas
                    cubeEntity.generateCollisionShapes(recursive: true)
                    cubeEntity.components.set(InputTargetComponent())
                    
                    // Física con gravedad
                    cubeEntity.components.set(
                        PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .dynamic
                    ))
                    
                    // suelo
                    let floorMesh = MeshResource.generatePlane(width: 2.0, depth: 2.0)
                    let floorMaterial = SimpleMaterial(color: .clear, isMetallic: false)
                    let floorEntity = ModelEntity(mesh: floorMesh, materials: [floorMaterial])

                    // Colisión
                    floorEntity.components.set(
                        CollisionComponent(
                            shapes: [.generateBox(size: [2.0, 0.001, 2.0])]
                        )
                    )

                    // PhysicsBody estático para que actúe como suelo
                    floorEntity.components.set(
                        PhysicsBodyComponent(
                            massProperties: .default,
                            material: .default,
                            mode: .static
                        )
                    )

                    // Anclaje al plano horizontal con clasificación floor
                    floorEntity.components.set(
                        AnchoringComponent(
                            AnchoringComponent.Target.plane(
                                .horizontal,
                                classification: .floor,
                                minimumBounds: [1.0, 1.0]
                            )
                        )
                    )
                               
                        content.add(floorEntity)
                    
                }
            }
        }
    }


#Preview(windowStyle: .volumetric) {
    ContentView()
}
