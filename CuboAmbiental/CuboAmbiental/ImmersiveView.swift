import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var dioramaManager: DioramaManager?

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity()
            anchor.components.set(
                AnchoringComponent(
                    .plane(
                        .horizontal,
                        classification: .any,
                        minimumBounds: [0.2, 0.2]
                    )
                )
            )
            content.add(anchor)

            let cubeEntity = ModelEntity(
                mesh: .generateBox(size: [0.2, 0.2, 0.2]),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )

            cubeEntity.generateCollisionShapes(recursive: true)
            cubeEntity.components.set(InputTargetComponent())

            cubeEntity.components.set(PhysicsBodyComponent(
                massProperties: .default,
                material: .default,
                mode: .dynamic
            ))

            anchor.addChild(cubeEntity)

            dioramaManager = DioramaManager(parent: cubeEntity)
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
