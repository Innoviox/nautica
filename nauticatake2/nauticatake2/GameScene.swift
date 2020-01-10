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

let GREEN_FISH = 72
let PURPLE_FISH = 74
let BLUE_FISH = 76
let RED_FISH = 78

let SCORE = 108

let PHYS_SIZE = [
    // ground
    6: 34.0,
    7: 38.0,
    
    // fish
    72: 30.0,
    78: 30.0
]

func make_node(from tile: Int) -> SKSpriteNode {
    let f = String(format: "fishTile_%03d", tile)
    let n = SKSpriteNode(imageNamed: f)
    n.size = CGSize(width: SIZE, height: SIZE)
    if tile == 72 || tile == 74 || tile == 76 || tile == 78 {
        n.physicsBody = SKPhysicsBody(texture: n.texture!, size: n.texture!.size())
    } else {
        if let phys = PHYS_SIZE[tile] {
            n.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(phys))
        } else {
            n.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(32.0))
        }
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
let C_DEADLY: UInt32 = 8

let MAX_LIVES = 3
let DEAD = "fishTile_098"
let ALIVE = "fishTile_099"

func text(_ i: Int) -> SKTexture { return SKTexture(imageNamed: String(format: "fishTile_%03d", i)) }
func text(_ s: String) -> SKTexture { return SKTexture(imageNamed: s) }

//let FISH_BLINK = SKAction.animate(with: Array(repeating: [text(DEAD), text(RED_FISH)], count: 2).flatMap { $0 }, timePerFrame: 0.3) // blink texture
let FISH_BLINK = SKAction.repeat(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),  SKAction.fadeIn(withDuration: 0.2)]), count: 3)

class GameScene: SKScene {
    private var fish: SKSpriteNode!
    
    private var x = 0
    private var current_sponge = SPONGES.randomElement()!
    private var current_sponge_n = 0
    private var current_ground = [6, 7]
    private var current_ground_n = 0
    
    private var xoff = CGFloat.zero
    private var yoff = CGFloat.zero
    
    // i hate swift
    private var global_xoff = CGFloat.zero
    private var global_yoff = CGFloat.zero
    
    private var score = 0
    
    private var lives = 3
    
    private var dying = false
    
    private var w = CGFloat.zero
    private var h = CGFloat.zero
    
    private var current_speed: CGFloat = 250
    
    let moveJoystick = TLAnalogJoystick(withDiameter: 100)

    override func didMove(to view: SKView) {
        print(self.size, self.w, self.h)
        h = self.size.width
        w = self.size.height
//        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
//        self.backgroundColor = UIColor(rgb: 0x40d6cc)

        
        xoff = w / 2 + 32
        yoff = h / 2
        
        for x in [1, 5, 9] {
            let sponge = SPONGES.randomElement()!
            for i in sponge {
                self.make_sponge(of: i, xpos: self.w * x / 10 + Double.random(in: -50...50) - xoff)
            }
        }
        
        // Create ground. TODO: add bones to ground, make more swirly
        let ground = [6, 7]
        for x in 0...(Int(self.w / 64) + 1) {
            let px = (x * 64.0) - xoff
            make_ground(of: 1, xpos: px, n: 0)
            make_ground(of: ground[x % ground.count], xpos: px, n: 1)
        }
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -xoff, y: 80 - yoff), CGPoint(x: w - xoff, y: 80 - yoff)])
        let real_ground = SKShapeNode(path: path)
        real_ground.physicsBody = SKPhysicsBody(edgeChainFrom: path)
        real_ground.physicsBody?.categoryBitMask = C_GROUND
        real_ground.physicsBody?.collisionBitMask = C_GROUND
        real_ground.physicsBody?.affectedByGravity = false
        real_ground.physicsBody?.allowsRotation = false
        real_ground.physicsBody?.isDynamic = false
        
        self.addChild(real_ground)
        
        self.fish = self.make_fish(from: RED_FISH, x: 300, y: 300)
        
        let moveJoystickHiddenArea = TLAnalogJoystickHiddenArea(rect: CGRect(x: -xoff, y: -yoff, width: self.w / 2, height: self.h))
        moveJoystickHiddenArea.lineWidth = 0
        moveJoystickHiddenArea.joystick = moveJoystick
        moveJoystick.handleImage = UIImage(named: "joystick")
        moveJoystick.baseImage = UIImage(named: "dpad")
        moveJoystick.on(.move) { [unowned self] joystick in self.handleMove(joystick: joystick) }
        addChild(moveJoystickHiddenArea)
        
        self.init_score()
        self.init_lives()
        
        physicsWorld.contactDelegate = self
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
        
        sponge_node.zPosition = CGFloat.random(in: 0...1)
        
        self.addChild(sponge_node)
    }
    
    func make_ground(of i: Int, xpos: CGFloat, n: Int) {
        let ground = make_node(from: i)
        ground.position = CGPoint(x: xpos, y: n * 64 - yoff)
        ground.zPosition = 1

        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = 2
        ground.physicsBody?.collisionBitMask = 4
        ground.name = "ground\(n+1)"
        self.addChild(ground)
    }
    
    func make_fish(from type: Int, x: CGFloat, y: CGFloat) -> SKSpriteNode {
        let fish = make_node(from: type)
        fish.position = CGPoint(x: x - xoff, y: y - yoff)
        
        fish.physicsBody?.affectedByGravity = false
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.velocity.dx = 0
        fish.name = "fish"
        fish.physicsBody?.collisionBitMask = C_GROUND
        fish.physicsBody?.categoryBitMask = C_GROUND
        fish.physicsBody?.contactTestBitMask = C_DEADLY
        
        fish.zPosition = 0.5
        
        self.addChild(fish)
        
        return fish
    }
    
    func make_enemy(type: Int) {
        // enemy ideas:
        // static fish
        // rocks with electricity between them
        // fish missiles
        // bubble vents from the bottom that you touch to deactivate
        // bubbles across the screen
        
        switch type {
        case 1: do {
            let fish = make_node(from: GREEN_FISH)
            fish.position = CGPoint(x: xoff, y: CGFloat.random(in: (-yoff+128)...(h/2)))
            
            fish.xScale = -fish.xScale
                        
            fish.physicsBody!.affectedByGravity = false
            fish.physicsBody!.allowsRotation = false
            fish.name = "enemy"
            fish.physicsBody!.collisionBitMask = C_DEADLY
            fish.physicsBody!.categoryBitMask = C_DEADLY
            fish.physicsBody!.isDynamic = true
            
            fish.zPosition = 0.5
            
            self.addChild(fish)
        }
        default: break
        }
    }
    
    func init_score() {
        var curr_x = xoff - 60
        
        for i in 0...10 {
            let node = SKSpriteNode(imageNamed: "fishTile_108")
            node.position = CGPoint(x: curr_x, y: yoff - 30)
            node.name = "score\(i)"
            node.isHidden = true
            addChild(node)
            curr_x -= node.texture!.size().width - 5
        }
    }
    
    func init_lives() {
        var curr_x = -xoff + 60
        
        for i in 0...2 {
            let node = SKSpriteNode(imageNamed: ALIVE)
            node.position = CGPoint(x: curr_x, y: yoff - 30)
            node.name = "life\(i)"
            addChild(node)
            curr_x += node.texture!.size().width - 5
        }
    }
    
    func die() {
        if dying || lives == 0 { return }
        dying = true
        lives -= 1
        let node = childNode(withName: "life\(lives)") as! SKSpriteNode
        node.isHidden = true
        
        self.fish.run(FISH_BLINK) { self.dying = false }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        score += 1
        current_speed += CGFloat(score) / 10000
        
//        if score % 200 == 0 { die() }
        
        if Double.random(in: 0...1) < 0.02 { make_enemy(type: 1) }
        
        for c in self.children {
            if c.name != "fish" {
                c.physicsBody?.velocity.dx = -current_speed
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
                } else if c.name == "ground1" || c.name == "ground2" {
                    if c.position.x < -xoff {
                        c.position.x += 2 * xoff
                    }
                } else if (c.name ?? "").contains("score") {
                   update_score(for: Double(c.name!.last!.wholeNumberValue!))
                } else if c.name == "enemy" {
                    if c.position.x < -xoff {
                        c.removeFromParent()
                    }
                }
            } else {
                c.physicsBody?.velocity.dx = 0
                
                if c.position.y > yoff - 30 {
                    c.position.y = yoff - 30
                }
            }
        }
    }
    
    func update_score(for power: Double) {
        let node = childNode(withName: "score\(Int(power))") as! SKSpriteNode
        
        let p = Int(pow(10.0, power))
        
        if score > p {
            let number = Int(score / Int(p)) % 10
            node.texture = SKTexture(imageNamed: "fishTile_\(108 + number)")
            node.isHidden = false
        } else {
            node.isHidden = true
        }
    }
    
    @objc func handleMove(joystick: TLAnalogJoystick) {
        self.fish.physicsBody?.velocity.dy = joystick.velocity.y * 5
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
        
}

extension GameScene: SKPhysicsContactDelegate  {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if !dying && firstBody.categoryBitMask == C_FISH && secondBody.categoryBitMask == C_DEADLY {
            die()
        }
    }
}
