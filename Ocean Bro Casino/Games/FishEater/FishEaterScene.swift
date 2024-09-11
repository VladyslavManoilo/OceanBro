//
//  FishEaterScene.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SpriteKit
import SwiftUI

fileprivate enum FlyingObject: String {
    case fish
}

final class FishEaterScene: SKScene {
    private var fishSize: CGFloat {
        let maxSize = min(size.width, size.height)
        let sizeDelta = 0.3
        let fishSizeValue = maxSize * sizeDelta
        return fishSizeValue
    }
    
    private let fishtFlyDuration: Double
    
    @Binding var fishesEaten: Int

    init(size: CGSize, collectedTaps: Binding<Int>, difficulty: GameDifficulty) {
        _fishesEaten = collectedTaps
        switch difficulty {
        case .easy:
            self.fishtFlyDuration = 5
        case .hard:
            self.fishtFlyDuration = 2.5
        }
    
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        spawnFishs()
    }
    
    private func spawnFishs() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnFish()
        }
        
        let delay = SKAction.wait(forDuration: 1.0)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever)
    }
    
    func spawnFish() {
        let fish = SKSpriteNode(imageNamed: "FallingFish")
        fish.color = [.red, .green, .yellow, .magenta, .cyan, .white, .orange].randomElement()!
        fish.colorBlendFactor = 1
        fish.name = FlyingObject.fish.rawValue
        fish.size = CGSize(width: fishSize, height: fishSize)
        
        let minX = fishSize / 2
        let maxX = size.width - fishSize / 2
        let randomX = CGFloat.random(in: minX...maxX)
        
        fish.position = CGPoint(x: randomX, y: -fish.size.height)
        
        addChild(fish)
        
        let moveUp = SKAction.moveTo(y: size.height + fish.size.height, duration: fishtFlyDuration)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveUp, remove])
        fish.run(moveSequence)
    }
    
    func spawnSmallerFishs(at position: CGPoint) {
        let smallerFishCount = 10
        for _ in 0..<smallerFishCount {
            let smallerFish = SKSpriteNode(imageNamed: "FallingFish")
            smallerFish.color = generateRandomColor()
            smallerFish.colorBlendFactor = 1
            
            smallerFish.size = CGSize(width: fishSize / 5, height: fishSize / 5)
            smallerFish.position = position
            
            let randomX = CGFloat.random(in: smallerFish.size.width...size.width - smallerFish.size.width)
            let randomY = CGFloat.random(in: size.height/4...size.height/2)
            let randomPosition = CGPoint(x: randomX, y: randomY)
            
            addChild(smallerFish)
            
            let moveToRandomPosition = SKAction.move(to: randomPosition, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveToRandomPosition, fadeOut, remove])
            
            smallerFish.run(sequence)
        }
    }
    
    private func generateRandomColor() -> UIColor {
        // Generate random values for red, green, and blue components
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0

        // Return a UIColor with random RGB values
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                if node is SKSpriteNode {
                    switch FlyingObject(rawValue: node.name ?? "") {
                    case .fish:
                        fishesEaten += 1
                        
                        AppFeedbackGenerator.occureImpact(with: .medium)
                        
                        let fallDown = SKAction.moveTo(y: -node.frame.height, duration: 0.5)
                        let explode = SKAction.run { [weak self] in
                            self?.spawnSmallerFishs(at: node.position)
                        }
                        
                        let tapSoundAction = SKAction.playSoundFileNamed("TapperTapSound.mp3", waitForCompletion: false)
                        let explodeSoundAction = SKAction.playSoundFileNamed("TapperExplodeSound.mp3", waitForCompletion: false)
                        let remove = SKAction.removeFromParent()
                        
                        let sequence = SKAction.sequence([tapSoundAction, fallDown, explode, explodeSoundAction, remove])
                        
                        node.run(sequence)
                        
                    case .none:
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    FishEaterView()
}
