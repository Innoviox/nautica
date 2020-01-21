//
//  Button.swift
//  tak
//
//  Created by Simon Chervenak on 1/15/19.
//  Copyright © 2019 Innoviox. All rights reserved.
//

import Foundation
import SpriteKit

// Base class for all buttons
class Button: SKSpriteNode {
    // button when not active
    var defaultButton: SKSpriteNode
    // button when active (e.g. user is pressing)
    var activeButton: SKSpriteNode
    // action to call on press
    var action: (Bool) -> Void
    // if the button is active/not
    var on: Bool = false
    
    /**
     Initializes a button. Since this is the base class, the arguments are
     Nodes; see the subcalsses for more specific and useful initializers.
     
     - Parameters:
        - defaultButton: The node that shows when the button is inactive
        - activeButton: The node that shows the the user clicks the button
        - action: the action to call when the user presses it
        - size: the size of the button (CGSize -> width, height)
    */
    init(defaultButton: SKSpriteNode, activeButton: SKSpriteNode, action: @escaping (Bool) -> Void, size: CGSize) {
        self.defaultButton = defaultButton
        self.activeButton = activeButton
        self.action = action
        
        super.init(texture: nil, color: .clear, size: size)
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Callback for when user clicks on button.
     Calls .action and toggles .on.
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        flip()
        action(on)
    }
    
    /**
     Flip button without action.
     */
    func flip() {
        if !on {
            activeButton.isHidden = false
            defaultButton.isHidden = true
            on = true
        } else {
            on = false
            activeButton.isHidden = true
            defaultButton.isHidden = false
        }
    }
}


class TextButton: Button {
    /**
     Initializes button with a given string. Can change color on click.
     ```
     TextButton(text: "History", defaultColor: UIColor(rgb: 0x4F5962), activeColor: UIColor(rgb: 0x30373d), defaultTextColor: UIColor.white, activeTextColor: UIColor.white, size: CGSize(width: 120, height: 50), position: CGPoint(x: 80, y: 50), buttonAction: clicked_button)
     ```
     */
    init(text: String, defaultColor: UIColor, activeColor: UIColor, defaultTextColor: UIColor, activeTextColor: UIColor, size: CGSize, position: CGPoint, buttonAction: @escaping (Bool) -> Void) {
        let db = SKSpriteNode(color: defaultColor, size: size)
        db.position = position
        
        let ab = SKSpriteNode(color: activeColor, size: size)
        ab.position = position
        ab.isHidden = true
        
        let defaultText = SKLabelNode(text: text)
        defaultText.position = CGPoint(x: 0, y: -10)
        defaultText.fontColor = defaultTextColor
        db.addChild(defaultText)
        
        let activeText = SKLabelNode(text: text)
        activeText.position = CGPoint(x: 0, y: -10)
        activeText.fontColor = activeTextColor
        ab.addChild(activeText)
        
        super.init(defaultButton: db, activeButton: ab, action: buttonAction, size: size)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageButton: Button {
    /**
     Initializes a button with an image that changes on click.
     ```
     ImageButton(defaultImage: "scroll-off", activeImage: "scroll-on", size: CGSize(width: 62.5, height: 50), position: CGPoint(x: 101.25, y: 100), buttonAction: clicked_ptn_button)
     ```
     Note: the default image is a path to the image relative to art.scnassets (called through SKTexture#imageNamed:)
    */
    init(defaultImage: String, activeImage: String, size: CGSize, position: CGPoint, buttonAction: @escaping (Bool) -> Void) {
        let db = SKSpriteNode(texture: SKTexture(imageNamed: defaultImage), size: size)
        db.position = position
        
        let ab = SKSpriteNode(texture: SKTexture(imageNamed: activeImage), size: size)
        ab.position = position
        ab.isHidden = true
        
        super.init(defaultButton: db, activeButton: ab, action: buttonAction, size: size)
        print("initializing image button")
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
