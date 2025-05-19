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

    init(parent: Entity) {
        self.parentEntity = parent
        loadDioramas()
        loadCurrentDiorama()
    }

    private func loadDioramas() {
        dioramas = [
            Diorama(name: "Bosque", modelName: "ForestLand.usdc", ambientSound: "bosqueSound.mp3", music: "musicaprueba.mp3"),
        ]
    }

    func nextDiorama() {
        currentIndex = (currentIndex + 1) % dioramas.count
        loadCurrentDiorama()
    }

    private func loadCurrentDiorama() {
        guard let parent = parentEntity else { return }

        parent.children.removeAll()
        let current = dioramas[currentIndex]

        if let modelEntity = try? Entity.load(named: current.modelName) {
            modelEntity.setPosition([0, 0, 0], relativeTo: parent)
            parent.addChild(modelEntity)
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
