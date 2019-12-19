//
//  GameScene.swift
//  nauticatake2
//
//  Created by Sarah Leavitt on 11/27/19.
//  Copyright © 2019 Innoviox. All rights reserved.
//

import SpriteKit
import GameplayKit

let SIZE = 64.0
let FISH = 72

let PHYS_SIZE = [
    // ground
    6: 34.0,
    7: 38.0,
    
    // fish
    72: 30.0
]

func make_node(from tile: Int) -> SKSpriteNode {
    let f = String(format: "fishTile_%03d", tile)
    let n = SKSpriteNode(imageNamed: f)
    n.size = CGSize(width: SIZE, height: SIZE)
    if let phys = PHYS_SIZE[tile] {
        n.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(phys))
    } else {
        n.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(32.0))
    }
    
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

let C_SPONGE: UInt32 = 0
let C_GROUND: UInt32 = 1
let C_FISH: UInt32   = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var fish: SKSpriteNode!
    
    private var x = 0
    private var current_sponge = SPONGES.randomElement()!
    private var current_sponge_n = 0
    
    private var xoff = CGFloat.zero
    private var yoff = CGFloat.zero
    
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)
    
    override func didMove(to view: SKView) {
        print(self.size)
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
//        self.backgroundColor = UIColor(rgb: 0x40d6cc)
        
        xoff = size.width / 2 + 32
        yoff = size.height / 2
        
        for x in [1, 5, 9] {
            let sponge = SPONGES.randomElement()!
            for i in sponge {
                self.make_sponge(of: i, xpos: self.size.width * x / 10 + Double.random(in: -50...50) - xoff)
            }
        }
        
        // Create ground. TODO: add bones to ground, make more swirly
        let ground = [6, 7]
        for x in 0...(Int(self.size.width / 64) + 1) {
            let px = (x * 64.0) - xoff

            let first = make_node(from: 1)
            first.position = CGPoint(x: px, y: 0 - yoff)
            first.zPosition = 1

            first.physicsBody?.affectedByGravity = false
            first.physicsBody?.isDynamic = false
            first.physicsBody?.categoryBitMask = C_GROUND
            
            let second = make_node(from: ground[x % ground.count])
            second.position = CGPoint(x: px, y: 64 - yoff)
            second.zPosition = 1
            
            second.physicsBody?.affectedByGravity = false
            second.physicsBody?.isDynamic = false
            second.physicsBody?.categoryBitMask = C_GROUND
            
            self.addChild(first)
            self.addChild(second)
            
            
        }
        
        self.fish = make_node(from: FISH)
        self.fish.position = CGPoint(x: 300 - xoff, y: 300 - yoff)
        
        self.fish.physicsBody?.affectedByGravity = false
        self.fish.physicsBody?.allowsRotation = false
        self.fish.physicsBody?.velocity.dx = 0
        self.fish.name = "fish"
        self.fish.physicsBody?.collisionBitMask = C_FISH
        
        self.addChild(self.fish)
        
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: -xoff, y: -yoff, width: self.size.width / 2, height: self.size.height))
        moveJoystickHiddenArea.lineWidth = 0
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.handleImage = UIImage(named: "joystick")
        moveJoystick.baseImage = UIImage(named: "dpad")
        moveJoystick.on(.move) { [unowned self] joystick in self.handleMove(joystick: joystick) }
        addChild(moveJoystickHiddenArea)
    }
    
    func make_sponge(of i: Int, xpos: CGFloat) {
        let sponge_node = make_node(from: i)
        sponge_node.position = CGPoint(x: xpos, y: 125 - yoff)

        sponge_node.physicsBody?.affectedByGravity = false
        sponge_node.physicsBody?.allowsRotation = false
        sponge_node.physicsBody?.isDynamic = true
        sponge_node.physicsBody?.collisionBitMask = C_SPONGE
        sponge_node.physicsBody?.categoryBitMask = C_SPONGE
        sponge_node.name = "sponge"
        
        self.addChild(sponge_node)
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
        for c in self.children {
            if c.name != "fish" {
                c.physicsBody?.velocity.dx = -250
                if c.name == "sponge" {
                    if c.position.x < -xoff {
                        c.removeFromParent()
                        if self.current_sponge_n == self.current_sponge.count {
                            self.current_sponge_n = 0
                            self.current_sponge = SPONGES.randomElement()!
                        }
                        make_sponge(of: self.current_sponge[self.current_sponge_n], xpos: xoff)
                        self.current_sponge_n += 1
                    }
//                    if c.position.x <
//                    c.removeFromParent()
                }
            } else {
                c.physicsBody?.velocity.dx = 0
            }
        }
    }
    
    @objc func handleMove(joystick: TLAnalogJoystick) {
        self.fish.physicsBody?.velocity.dy = joystick.velocity.y * 5
    }
}
