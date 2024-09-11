//
//  ThreeInRowGameScene.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SpriteKit
import SwiftUI

enum FishColor: CaseIterable {
    case red
    case purple
    case green
    case blue
    
    var textureName: String {
        switch self {
        case .purple:
            return "PurpleFish"
        case .red:
            return "RedFish"
        case .blue:
            return "BlueFish"
        case .green:
            return "GreenFish"
        }
    }
}

class ThreeInRowGameScene: SKScene {
    @Binding var strikes: Int
    
    var difficulty: GameDifficulty
    var grid: [[SKSpriteNode]] = []
    var colors: [FishColor] = FishColor.allCases
    var firstTappedNode: SKSpriteNode?
    var firstTappedPosition: (x: Int, y: Int)?
    var isTouchesDeactivated: Bool = false
    
    init(size: CGSize, strikes: Binding<Int>, difficulty: GameDifficulty) {
        self._strikes = strikes
        self.difficulty = difficulty
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupGrid()
    }
    
    func setupGrid() {
        let gridSize = difficulty == .easy ? 3 : 6
        let colorCount = difficulty == .easy ? 3 : 4
        let offset: CGFloat = 16
        let nodeSize = ((size.width - offset * 2) - CGFloat(gridSize - 1) * 10) / CGFloat(gridSize)
        
        for y in 0..<gridSize {
            var row: [SKSpriteNode] = []
            for x in 0..<gridSize {
                let textureName = colors[Int.random(in: 0..<colorCount)].textureName
                let node = SKSpriteNode(texture: SKTexture(imageNamed: textureName), size:  CGSize(width: nodeSize, height: nodeSize))
                node.name = textureName

                node.position = CGPoint(x: (CGFloat(x) * (nodeSize + 10) + nodeSize / 2) + offset, y: (CGFloat(y) * (nodeSize + 10) + nodeSize / 2) + offset)
                addChild(node)
                row.append(node)
            }
            grid.append(row)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchesDeactivated {
            return
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for (y, row) in grid.enumerated() {
            for (x, node) in row.enumerated() {
                if node.contains(location) {
                    if let firstNode = firstTappedNode, let firstPos = firstTappedPosition {
                        if abs(firstPos.x - x) + abs(firstPos.y - y) == 1 {
                            swapNodes(firstNode, node, from: firstPos, to: (x, y))
                        } else {
                            firstTappedNode = node
                            firstTappedPosition = (x, y)
                        }
                    } else {
                        firstTappedNode = node
                        firstTappedPosition = (x, y)
                    }

                    return
                }
            }
        }
    }

    func swapNodes(_ node1: SKSpriteNode, _ node2: SKSpriteNode, from firstPos: (x: Int, y: Int), to secondPos: (x: Int, y: Int)) {
        let node1Position = node1.position
        let node2Position = node2.position
        
        let moveAction1 = SKAction.move(to: node2Position, duration: 0.2)
        let moveAction2 = SKAction.move(to: node1Position, duration: 0.2)
        
        node1.run(moveAction1)
        
        AppFeedbackGenerator.occureImpact(with: .medium)

        node2.run(moveAction2) {
            // Update the grid to reflect the new positions
            self.grid[firstPos.y][firstPos.x] = node2
            self.grid[secondPos.y][secondPos.x] = node1
            
            // Clear the tapped node references after the swap
            self.firstTappedNode = nil
            self.firstTappedPosition = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.checkForThreeInRow()
            }
        }
    }

    func checkForThreeInRow() {
        isTouchesDeactivated = true
        let gridSize = difficulty == .easy ? 3 : 6
        var rowsToReplace: Set<Int> = []
        var columnsToReplace: Set<Int> = []
        
        // Check rows
        for y in 0..<gridSize {
            for x in 0..<(gridSize - 2) {
                if grid[y][x].name == grid[y][x + 1].name && grid[y][x + 1].name == grid[y][x + 2].name {
                    rowsToReplace.insert(y)
                }
            }
        }
        
        // Check columns
        for x in 0..<gridSize {
            for y in 0..<(gridSize - 2) {
                if grid[y][x].name == grid[y + 1][x].name && grid[y + 1][x].name == grid[y + 2][x].name {
                    columnsToReplace.insert(x)
                }
            }
        }
        
        if !rowsToReplace.isEmpty || !columnsToReplace.isEmpty {
            strikes += rowsToReplace.count + columnsToReplace.count
            replaceRowsAndColumns(rows: rowsToReplace, columns: columnsToReplace)
        } else {
            isTouchesDeactivated = false
        }
    }
    
    func replaceRowsAndColumns(rows: Set<Int>, columns: Set<Int>) {
        let gridSize = difficulty == .easy ? 3 : 6
        let colorCount = difficulty == .easy ? 3 : 4
        let offset: CGFloat = 16
        let nodeSize = ((size.width - offset * 2) - CGFloat(gridSize - 1) * 10) / CGFloat(gridSize)
        
        for y in rows {
            for x in 0..<gridSize {
                let textureName = colors[Int.random(in: 0..<colorCount)].textureName
                let node = SKSpriteNode(texture: SKTexture(imageNamed: textureName), size:  CGSize(width: nodeSize, height: nodeSize))
                node.name = textureName

                node.position = CGPoint(x: (CGFloat(x) * (nodeSize + 10) + nodeSize / 2) + offset, y: (CGFloat(y) * (nodeSize + 10) + nodeSize / 2) + offset)

                let oldNode = grid[y][x]
                
                let removeAndAddNewNode = SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    oldNode.removeFromParent()
                    self.grid[y][x] = node
                    self.addChild(node)
                }
                
                // Define the scale down action
                let scaleDown = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.2)

                // Create a sequence of actions
                let scaleSequence = SKAction.sequence([scaleDown, removeAndAddNewNode])

                // Run the sequence on the sprite node
                oldNode.run(scaleSequence)
            }
        }
        
        for x in columns {
            for y in 0..<gridSize {
                let textureName = colors[Int.random(in: 0..<colorCount)].textureName
                let node = SKSpriteNode(texture: SKTexture(imageNamed: textureName), size:  CGSize(width: nodeSize, height: nodeSize))
                node.name = textureName
                
                node.position = CGPoint(x: (CGFloat(x) * (nodeSize + 10) + nodeSize / 2) + offset, y: (CGFloat(y) * (nodeSize + 10) + nodeSize / 2) + offset)

                let oldNode = grid[y][x]
                
                let removeAndAddNewNode = SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    oldNode.removeFromParent()
                    grid[y][x] = node
                    addChild(node)

                }

                // Define the scale down action
                let scaleDown = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.2)

                // Create a sequence of actions
                let scaleSequence = SKAction.sequence([ scaleDown, removeAndAddNewNode])

                // Run the sequence on the sprite node
                oldNode.run(scaleSequence)
            }
        }
        
        // Check for new strikes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.checkForThreeInRow()
            self?.isTouchesDeactivated = false
        }
    }
}

#Preview {
    ThreeInRowGameView()
}
