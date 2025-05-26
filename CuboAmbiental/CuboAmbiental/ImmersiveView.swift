import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var dioramaEntity: ModelEntity?
    @State private var dragOffset = CGSize.zero
    @State private var lastPosition = SIMD3<Float>(0, 0, 0)

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [1, 1]))
            content.add(anchor)

            Task {
                do {
                    let modelEntity = try ModelEntity.load(named: "MagicalForest", in: realityKitContentBundle)
                    
                    await MainActor.run {
                        modelEntity.scale = [0.2, 0.2, 0.2]
                        modelEntity.position = [0, 0, 0]
                        modelEntity.generateCollisionShapes(recursive: true)
                        modelEntity.components.set(PhysicsBodyComponent(massProperties: .init(mass: 15.0), mode: .dynamic))
                        print("EL mdoelo actual es: \(modelEntity)")
                        anchor.addChild(modelEntity)
                       // dioramaEntity = modelEntity
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
        }
        // Aquí viene el gesto para mover en XZ con arrastre horizontal en la pantalla
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Aquí calculamos la nueva posición del diorama en función del arrastre
                    let translation = value.translation
                    // Modificamos el posicionamiento en X y Z, Y se mantiene igual (altura)
                    if let diorama = dioramaEntity {
                        let deltaX = Float(translation.width / 1000)
                        let deltaZ = Float(translation.height / 1000)

                        let newPosition = SIMD3<Float>(
                            lastPosition.x + deltaX,
                            lastPosition.y,
                            lastPosition.z + deltaZ
                        )

                        // Actualiza la posición
                        diorama.position = newPosition
                    }
                }
                .onEnded { value in
                    if let diorama = dioramaEntity {
                        lastPosition = diorama.position
                    }
                }
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
