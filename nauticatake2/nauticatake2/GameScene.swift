//
//  GameScene.swift
//  nauticatake2
//
//  Created by Sarah Leavitt on 11/27/19.
//  Copyright © 2019 Innoviox. All rights reserved.
//

import SpriteKit
import GameplayKit

func make_node(from: Int) -> SKSpriteNode {
    return SKSpriteNode(imageNamed: String(format: "fishTile_%03d", from))
}

let SIZE = 0.1

class GameScene: SKScene {
    private var groundNodes: [[SKSpriteNode]]!
    
    override func didMove(to view: SKView) {
        groundNodes = []
        
        // Create ground. TODO: add bones to ground
        let ground = [6, 7]
        for x in 0...10 {
            let px = size.width * CGFloat(Double(x) / 10)
            let first = make_node(from: 1)
            first.position = CGPoint(x: px, y: 0.15)
            first.size = CGSize(width: SIZE, height: SIZE)
            
            let second = make_node(from: ground[x % ground.count])
            second.position = CGPoint(x: px, y: 0.3)
            second.size = CGSize(width: SIZE, height: SIZE)
            
            groundNodes.append([])
            groundNodes[x].append(first)
            groundNodes[x].append(second)
            
            addChild(first)
            addChild(second)
//            first.run(SKAction.moveBy(x: -1, y: -1, duration: 5))
//            second.run(SKAction.moveBy(x: 1, y: 1, duration: 5))
        }
    }
    
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
