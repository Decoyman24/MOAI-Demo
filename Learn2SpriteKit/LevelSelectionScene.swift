//
//  LevelSelection.swift
//  MOAI Demo
//
//  Created by Roberto La Croce on 21/02/22.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class LevelSelectionScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        self.setupLevelSelectionScene()
        view.showsPhysics = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        touchedButton(touchLocation: touchLocation)
//            for touch in touches {
//                if touch == touches.first{
//                    print("going to gameplay scene")
//                    let gameScene = GameScene(fileNamed: "GameScene")
//                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
//                }
//            }
        }
    
    func touchedButton(touchLocation: CGPoint) {
        let nodeAtPoint = atPoint(touchLocation)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "Button1") == true {
                let gameScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.7))
            }
            else if touchedNode.name?.starts(with: "BackButton") == true{
                let mainMenu = MainMenu(fileNamed: "MainMenu")
                self.view?.presentScene(mainMenu!, transition: SKTransition.fade(withDuration: 0))
            }
        }
    }
    
//    GRAZIE AD ORESTE CON IL CODICE SOPRA POSSIAMO ANCHE SELEZIONARE PIU' LIVELLI
    
    func setupLevelSelectionScene() {
        let background = SKSpriteNode(imageNamed: "Level Selection")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1)
//        background.zPosition = ZPosition.background
//
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
