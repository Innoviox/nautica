//
//  GameViewController.swift
//  nauticatake2
//
//  Created by Sarah Leavitt on 11/27/19.
//  Copyright © 2019 Innoviox. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleMove(joystick: TLAnalogJoystick) {
        print("received move", joystick.velocity)
    }
    
    @objc func handleRotate(joystick: TLAnalogJoystick) {
        print("received rotate", joystick.angular)
    }
}
