//
//  FindTreasureScene.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI
import SpriteKit

// MARK: - Chest Sprite Node
class ChestNode: SKSpriteNode {
    var hasTreasure = false
}


// MARK: - SpriteKit Scene
class TreasureChestScene: SKScene {
    private var isTouchEnabled: Bool = false
    var chests = [ChestNode]()
    var answerSelected: ((_ isCorrect: Bool) -> Void)?
    var selectedDifficulty: GameDifficulty = .easy
    var treasureChestIndex = 0
    
    @Binding var correctFinds: Int
    
    init(correctFinds: Binding<Int>, size: CGSize) {
        _correctFinds = correctFinds
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
      
        setupChests()
        
        start()
    }
    
    private func start() {
        isTouchEnabled = false
        showTreasure()
    }
    
    func setupChests() {
        let numberOfChests = selectedDifficulty.numberOfChests
        let chestSpacing: CGFloat = 16
        
        for i in 0..<numberOfChests {
            let totalWidth = size.width - chestSpacing * CGFloat((numberOfChests - 1))
            let chestSizeValue = totalWidth / CGFloat(numberOfChests)
            let chest = ChestNode(imageNamed: "ClosedTreasureChest")
            chest.position = CGPoint(x: (chestSpacing * CGFloat(i)) + chestSizeValue * CGFloat(i) + chestSizeValue/2, y: size.height / 2)
            chest.name = "chest_\(i)"
            chest.size = CGSize(width: chestSizeValue, height: chestSizeValue)
            addChild(chest)
            chests.append(chest)
        }
    }
    
    func showTreasure() {
        // Randomly place the treasure in one chest
        treasureChestIndex = Int.random(in: 0..<chests.count)
        chests[treasureChestIndex].hasTreasure = true
        chests[treasureChestIndex].texture = SKTexture(imageNamed: "FullTreasureChest")
        
        // Show treasure for 2 seconds, then close the chest
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chests[self.treasureChestIndex].texture = SKTexture(imageNamed: "ClosedTreasureChest")
            
            self.shuffleChests()
        }
    }
    
    func shuffleChests() {
        isTouchEnabled = false
        let shuffleDuration = selectedDifficulty.shuffleSpeed
        var previousPositions = chests.map { $0.position }
        var availableIndexes = Array(0..<self.chests.count)
        var placedIndexes: [Int] = []
        
        let shuffleAction = SKAction.run { [weak self] in
            guard let self = self else { return }

            // Create a fresh array of available indexes for each shuffle step
            var newPositions = [CGPoint]()

            // For each chest, find a new position
            for (index, _) in self.chests.enumerated() {
                // Remove the current chest's previous position from the available positions
                availableIndexes.removeAll { $0 == index }

                // Randomly pick a new index from the available indexes
                let randomIndex = availableIndexes.randomElement() ?? index
                newPositions.append(previousPositions[randomIndex])
                placedIndexes.append(randomIndex)

                // Return the previous index back to available pool for other chests
                if !placedIndexes.contains(index) {
                    availableIndexes.append(index)
                }

                // Remove the used new index to prevent duplicates
                availableIndexes.removeAll { $0 == randomIndex }
                if placedIndexes.count == chests.count {
                    placedIndexes = []
                    availableIndexes = Array(0..<self.chests.count)
                }
            }

            // Move the chests to their new positions and update zPosition
            for (index, chest) in self.chests.enumerated() {
                let moveAction = SKAction.move(to: newPositions[index], duration: shuffleDuration)
                chest.run(moveAction)
                
                // Update the chest's position in the `chests` array
                self.chests[index].position = newPositions[index]
                
                // Update zPosition to ensure proper rendering order
                chest.zPosition = CGFloat(Int.random(in: 0..<5))
            }

            // Update `previousPositions` to match the new positions for the next shuffle
            previousPositions = newPositions
        }

        let waitAction = SKAction.wait(forDuration: shuffleDuration)
        let sequence = SKAction.sequence([shuffleAction, waitAction])
        
        // Repeat shuffle multiple times
        run(SKAction.repeat(sequence, count: 5)) { [weak self] in
            self?.isTouchEnabled = true
        }
    }
    
    func revealChests(selectedChest: ChestNode) {
        for chest in chests {
            if selectedChest != chest {
                continue
            }
            
            if chest.hasTreasure {
                chest.texture = SKTexture(imageNamed: "FullTreasureChest")
            } else {
                chest.texture = SKTexture(imageNamed: "EmptyTreasureChest")
            }
        }
        
        answerSelected?(selectedChest.hasTreasure)
        
        if selectedChest.hasTreasure {
            correctFinds += 1
            isTouchEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                guard let self = self else {
                    return
                }
                
                for chest in chests {
                    chest.texture = SKTexture(imageNamed: "ClosedTreasureChest")
                }
                
                self.shuffleChests()
            })
        } else {
            let newCorrectFindsNumber = correctFinds - 1
            if newCorrectFindsNumber < 0 {
                correctFinds = 0
            } else {
                correctFinds = newCorrectFindsNumber
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchEnabled else {
            return
        }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtLocation = nodes(at: location)
            
            if let chest = nodesAtLocation.first as? ChestNode {
                revealChests(selectedChest: chest)
            }
        }
    }
}


#Preview {
    FindTreasureView()
}
