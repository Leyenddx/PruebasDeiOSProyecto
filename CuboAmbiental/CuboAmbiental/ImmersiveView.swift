import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var dioramaModelEntity: ModelEntity?
    @State private var dioramaEntity = Entity()
    @State private var dragOffset = CGSize.zero
    @State private var lastPosition = SIMD3<Float>(0, 0, 0)

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [1, 1]))
            content.add(anchor)

            Task {
                do {
                    let modelEntity = try ModelEntity.load(named: "caja", in: realityKitContentBundle)
                    
                    await MainActor.run {
                        modelEntity.scale = [0.2, 0.2, 0.2]
                        modelEntity.position = [0, 0, 0]
                        modelEntity.generateCollisionShapes(recursive: true)
                        modelEntity.components.set(PhysicsBodyComponent(massProperties: .init(mass: 15.0), mode: .dynamic))
                        modelEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                        modelEntity.components.set(GroundingShadowComponent(castsShadow: true))
                        print("EL mdoelo actual es: \(modelEntity)")
                        anchor.addChild(modelEntity)
                        dioramaEntity = modelEntity
                        lastPosition = modelEntity.position
                    }
                } catch {
                    print("Error al encontrar modelo: \(error)")
                }
            }

            let floor = ModelEntity(
                mesh: .generatePlane(width: 5.0, depth: 0),
                materials: [SimpleMaterial(color: .clear, isMetallic: false)]
            )
            floor.generateCollisionShapes(recursive: true)
            floor.components.set(PhysicsBodyComponent(mode: .static))
            let floorAnchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: [4.0, 4.0]))
            floorAnchor.addChild(floor)
            content.add(floorAnchor)
        }.gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    dioramaEntity.position = value.convert(value.location3D, from: .local, to: dioramaEntity.parent!)
                }
            )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
