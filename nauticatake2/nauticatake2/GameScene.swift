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

let SPONGES = [
    [10, 11],
    [12, 82, 13],
    [16, 14, 17],
    [48, 49],
    [32, 33],
    [30, 28, 31],
    [34, 33, 83],
    [30, 28, 46, 31],
    [30, 28, 47, 31],
    [84, 52],
    [94, 52, 53],
    [98, 52, 53]
]

class GameScene: SKScene {
    private var groundNodes: [SKSpriteNode]!
    private var spongeNodes: [SKSpriteNode]!
    
    private var x = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(rgb: 0x40d6cc)
        
        groundNodes = []
        
        for x in [3, 7] {
            let sponge = SPONGES.randomElement()!
            for i in sponge {
                let px = size.width * x / 10
                let sponge_node = make_node(from: i)
                sponge_node.position = CGPoint(x: px + Double.random(in: -10...10) / 100, y: 0.4)
                sponge_node.size = CGSize(width: SIZE / 2, height: SIZE / 2)
                                
                addChild(sponge_node)
            }
        }
        
        // Create ground. TODO: add bones to ground, make more swirly
        let ground = [6, 7]
        for x in 0...10 {
            let px = size.width * x / 10
            let first = make_node(from: 1)
            first.position = CGPoint(x: px, y: 0.15)
            first.size = CGSize(width: SIZE, height: SIZE)
            first.zPosition = 1
            
            let second = make_node(from: ground[x % ground.count])
            second.position = CGPoint(x: px, y: 0.3)
            second.size = CGSize(width: SIZE, height: SIZE)
            second.zPosition = 1
            
            groundNodes.append(first)
            groundNodes.append(second)
            
            print(second.position)
            
            addChild(first)
            addChild(second)
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
