//
//  MenuScene.swift
//  Learn2SpriteKit
//
//  Created by Matteo Morena on 17/02/22.
//

import SpriteKit

class MenuScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        self.setupMenu()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                if touch == touches.first{
                    print("going to gameplay scene")
                    let gameScene = GameScene(fileNamed: "GameScene")
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
                }
            }
        }
    
    func setupMenu() {
        let background = SKSpriteNode(imageNamed: "title screen")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 0.47)
        background.zPosition = ZPosition.background
        
        self.addChild(background)
        
//        let button = SpriteKitButton(defaultButtonImage: "stonetile", action: goToLevelScene, index: 0)
//        button.position = CGPoint(x: frame.midX, y: frame.midY*0.8)
//        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
//        button.zPosition = ZPosition.hudLabel
//        addChild(button)
    }
    
    func goToLevelScene(_: Int){
        sceneManagerDelegate?.presentGameScene()
    }
}
