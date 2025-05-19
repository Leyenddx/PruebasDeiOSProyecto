// ContentView.swift
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        RealityView { content in
            if let cubeEntity = try? await Entity(named: "caja") {
                content.add(cubeEntity)
                cubeEntity.position = [0, 0.5, -0.5]

                // Anclar a plano horizontal
                cubeEntity.components.set(
                    AnchoringComponent(
                        .plane(
                            .horizontal,
                            classification: .any,
                            minimumBounds: [0.1, 0.1]
                        )
                    )
                )

                // Colisiones y físicas
                cubeEntity.generateCollisionShapes(recursive: true)
                cubeEntity.components.set(InputTargetComponent())
                cubeEntity.components.set(
                    PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .dynamic
                    )
                )

                // Suelo invisible
                let floorMesh = MeshResource.generatePlane(width: 2.0, depth: 2.0)
                let floorMaterial = SimpleMaterial(color: .clear, isMetallic: false)
                let floorEntity = ModelEntity(mesh: floorMesh, materials: [floorMaterial])

                floorEntity.components.set(
                    CollisionComponent(
                        shapes: [.generateBox(size: [2.0, 0.001, 2.0])]
                    )
                )

                floorEntity.components.set(
                    PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .static
                    )
                )

                floorEntity.components.set(
                    AnchoringComponent(
                        .plane(
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



