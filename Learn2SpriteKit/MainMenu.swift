
import Foundation
import SpriteKit
import UIKit
import GameplayKit

class MainMenu: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        self.setupMainMenu()
        view.showsPhysics = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        touchedButton(touchLocation: touchLocation)
        }
    
    func touchedButton(touchLocation: CGPoint) {
        let nodeAtPoint = atPoint(touchLocation)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "StoryButton") == true {
                let levelSelectionScene = LevelSelectionScene(fileNamed: "LevelSelectionScene")
                self.view?.presentScene(levelSelectionScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
            else if touchedNode.name?.starts(with: "TeamButton") == true{
                let fireMenu = FireMenu(fileNamed: "FireMenu")
                self.view?.presentScene(fireMenu!, transition: SKTransition.fade(withDuration: 0))
            }
        }
    }
    
//    GRAZIE AD ORESTE CON IL CODICE SOPRA POSSIAMO ANCHE SELEZIONARE PIU' LIVELLI
    
    func setupMainMenu() {
        let background = SKSpriteNode(imageNamed: "MainMenu")
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
