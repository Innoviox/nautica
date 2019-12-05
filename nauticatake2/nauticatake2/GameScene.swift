//
//  GameScene.swift
//  nauticatake2
//
//  Created by Sarah Leavitt on 11/27/19.
//  Copyright © 2019 Innoviox. All rights reserved.
//

import SpriteKit
import GameplayKit

let SIZE = 0.1

func make_node(from: Int, size: Double) -> SKSpriteNode {
    let f = String(format: "fishTile_%03d", from)
    let n = SKSpriteNode(imageNamed: f)
    n.size = CGSize(width: size, height: size)
//    n.physicsBody = SKPhysicsBody(texture: n.texture!, size: n.texture!.size())
//    n.physicsBody = SKPhysicsBody(rectangleOf: n.size)
    n.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(size))
    return n
}

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
        self.physicsWorld.gravity = CGVector(dx: 0.1, dy: -4.9)
        
        backgroundColor = UIColor(rgb: 0x40d6cc)
        
        groundNodes = []
        
        for x in [3, 7] {
            let sponge = SPONGES.randomElement()!
            for i in sponge {
                let px = size.width * x / 10
                let sponge_node = make_node(from: i, size: SIZE)
                sponge_node.position = CGPoint(x: px + Double.random(in: -10...10) / 100, y: 0.6)

                sponge_node.physicsBody!.affectedByGravity = true
                sponge_node.physicsBody!.allowsRotation = true
                sponge_node.physicsBody!.isDynamic = false
                
                addChild(sponge_node)
            }
        }
        
        // Create ground. TODO: add bones to ground, make more swirly
        let ground = [6, 7]
        for x in 0...10 {
            let px = size.width * x / 10
            let first = make_node(from: 1, size: SIZE)
            first.position = CGPoint(x: px, y: 0.15)
            first.zPosition = 1
            
            first.physicsBody!.affectedByGravity = false
            first.physicsBody!.allowsRotation = true
            first.physicsBody!.isDynamic = false
            
            let second = make_node(from: ground[x % ground.count], size: SIZE)
            second.position = CGPoint(x: px, y: 0.3)
            second.zPosition = 1
            
            second.physicsBody!.affectedByGravity = false
            second.physicsBody!.allowsRotation = true
            second.physicsBody!.isDynamic = false
            
            groundNodes.append(first)
            groundNodes.append(second)
            
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
