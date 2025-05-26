//
//  DioramaManager.swift
//  CuboAmbiental
//
//  Created by alumno on 5/19/25.
//

import Foundation
import RealityKit
import AVFoundation

class DioramaManager {
    private var currentIndex = 0
    private var dioramas: [Diorama] = []
    private weak var parentEntity: Entity?
    private var audioPlayer: AVAudioPlayer?

    // Contenedor para modelos
    private var modelContainer = Entity()

    init(parent: Entity) {
        self.parentEntity = parent

        // Añade contenedor al parent para controlar solo los modelos
        parent.addChild(modelContainer)

        loadDioramas()
        loadCurrentDiorama()
    }

    private func loadDioramas() {
        dioramas = [
            Diorama(
                name: "Bosque",
                modelName: "caja",
                ambientSound: "bosqueSound.mp3",
                music: "musicaprueba.mp3"
            )
        ]
    }

    func nextDiorama() {
        currentIndex = (currentIndex + 1) % dioramas.count
        loadCurrentDiorama()
    }

    private func loadCurrentDiorama() {
        guard let _ = parentEntity else { return }

        // Limpia solo el modelo anterior
        modelContainer.children.removeAll()

        let current = dioramas[currentIndex]

        // Cargar modelo
        Task {
            do {
                // Aquí usas await para cargar la entidad async
                let modelEntity = try await Entity(named: current.modelName)

                // Cambias al hilo principal para modificar scale y position
                await MainActor.run {
                    modelEntity.scale = [0.1, 0.1, 0.1]  // Ajusta la escala para Vision Pro
                    modelEntity.position = [0, 0, 0]

                    modelContainer.addChild(modelEntity)
                }
            } catch {
                print("Error cargando modelo \(current.modelName): \(error)")
            }
        }


        playSound(named: current.ambientSound)
    }

    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("No se encontró el sonido: \(name)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error al reproducir sonido: \(error)")
        }
    }
}
