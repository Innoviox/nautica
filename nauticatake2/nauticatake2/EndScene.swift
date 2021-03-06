//
//  EndScene.swift
//  nauticatake2
//
//  Created by Sarah Leavitt on 1/21/20.
//  Copyright © 2020 Innoviox. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EndScene: SKScene {
    var score: Int = 0
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        self.score = score
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let node = SKLabelNode(text: "You died :(\nFinal Score: \(score)")
        node.numberOfLines = 2
        addChild(node)
    }
}
