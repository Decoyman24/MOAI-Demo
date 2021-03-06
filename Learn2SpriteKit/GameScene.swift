//
//  GameScene.swift
//  Learn2SpriteKit
//
//  Created by Luigi Minniti on 20/12/21.
//

import SpriteKit
import GameplayKit
import AVFoundation

let healthBarWidth: CGFloat = 80
let healthBarHeight: CGFloat = 8

struct PhysicsCategory { //Category constants per le collisioni
    static let None: UInt32 = 0
    static let Enemy: UInt32 = 0b1 // 1
    static let Ally: UInt32 = 0b10 // 2
    static let Block: UInt32 = 0b100 // 3
    static let All: UInt32 = 0b1000 // 4
    static let Edge: UInt32 = 0b10000 // 8
}


protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}


//MARK: RANDOMISATION OF STATS
let random = GKRandomSource()
let statValue = GKGaussianDistribution(randomSource: random, lowestValue: 1, highestValue: 9)

class GameScene: SKScene, SKPhysicsContactDelegate {
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in (touches) {
    //            let location = touch.location(in: self) //trova dove è avvenuto il tap
    //            let nodeTouched = atPoint(location) //capisce qual'è il nodo tappato in base a location
    //            if let gameSprite = nodeTouched as? GameSprite {
    //                gameSprite.onTap()
    //
    //            }
    //        }
    //    }
    let worldNode = SKNode()
    var sceneManagerDelegate: SceneManagerDelegate?
    var myson = Redslime()
    var originalMysonPos: CGPoint!
    var hasGone = false
    var pauseAlertBox: SKSpriteNode = SKSpriteNode(imageNamed: "PauseAlert")
    var pauseRetry: SKSpriteNode = SKSpriteNode(imageNamed: "PauseRetry")
    var pauseExit: SKSpriteNode = SKSpriteNode(imageNamed: "PauseExit")
    var pauseX: SKSpriteNode = SKSpriteNode(imageNamed: "PauseX")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        touchedButton(touchLocation: touchLocation)
        
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        originalMysonPos = touchLocation
                        if let sprite = node as? Redslime {
                            if sprite == myson {
                                myson.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? Redslime {
                            if sprite == myson {
                                myson.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? Redslime {
                            if sprite == myson {
                                let dx = (touchLocation.x - originalMysonPos.x)
                                let dy = (touchLocation.y - originalMysonPos.y)
                                let impulse = CGVector(dx: dx*2, dy: dy*2)
                                
                                myson.physicsBody?.applyImpulse(impulse)
                                hasGone = true
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if pauseAlertBox.isHidden {
            pauseAlertBox.run(SKAction.hide())
        } else {
            pauseAlertBox.run(SKAction.unhide())
        }
        if let mysonPhysicsBody = myson.physicsBody {
            if mysonPhysicsBody.velocity.dx >= 0.1 && mysonPhysicsBody.velocity.dy >= 0.1 && hasGone {
                myson.physicsBody?.velocity.dx -= 3.5
                myson.physicsBody?.velocity.dy -= 3.5
                //                    myson.position = originalMysonPos
            }
            else if mysonPhysicsBody.velocity.dx <= 0 && mysonPhysicsBody.velocity.dy <= 0 && hasGone {
                myson.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                hasGone = false
            }
        }
    }
    
    func touchedButton(touchLocation: CGPoint) {
        let nodeAtPoint = atPoint(touchLocation)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            print(touchedNode)
            if touchedNode.name?.starts(with: "PauseButton") == true {
                
                pauseAlertBox.isHidden = false
                worldNode.isPaused = true
                physicsWorld.speed = 0
                print(pauseAlertBox.isHidden.description)
                print(pauseAlertBox.zPosition)
                
                
            }
            else if touchedNode.name?.starts(with: "PauseX") == true{
                pauseAlertBox.isHidden = true
                worldNode.isPaused = false
                physicsWorld.speed = 1
            }
            else if touchedNode.name?.starts(with: "PauseRetry") == true{
                let gameScene = GameScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
            else if touchedNode.name?.starts(with: "PauseExit") == true{
                let mainMenu = MainMenu(fileNamed: "MainMenu")
                self.view?.presentScene(mainMenu!, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
    
    func collisionBetween(myson: SKNode, object: SKNode) {
        if object.name == "dino" {
            print("clash")
        } else if object.name == "Muro" {
            print("wall")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
            run(SKAction.playSoundFileNamed("oh.mp3", waitForCompletion: false))
        }
        
        func didEnd(_ contact: SKPhysicsContact) {
            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
            if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
                print("clash")
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        addChild(worldNode)
        
        pauseAlertBox.isHidden = true
        
        addChild(pauseAlertBox)
        pauseAlertBox.zPosition = 50
        
        pauseAlertBox.addChild(pauseRetry)
        pauseRetry.name = "PauseRetry"
        pauseRetry.zPosition = 51
        pauseRetry.position = CGPoint (x: 73, y: -30)
        
        pauseAlertBox.addChild(pauseExit)
        pauseExit.name = "PauseExit"
        pauseExit.zPosition = 51
        pauseExit.position = CGPoint (x: -73, y: -30)
        
        pauseAlertBox.addChild(pauseX)
        pauseX.name = "PauseX"
        pauseX.zPosition = 51
        pauseX.position = CGPoint (x: 100, y: 70)
         
        print(pauseAlertBox.isHidden.description)
        //        let maxAspectRatio: CGFloat = 16.0/9.0
        //        let maxAspectRatioHeight = size.width / maxAspectRatio
        //        let playableMargin: CGFloat = (size.height
        //          - maxAspectRatioHeight)/2
        //        let playableRect = CGRect(x: 0, y: playableMargin,
        //                                  width: size.width, height: size.height)
        
        
        
        //        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        //        physicsBody!.restitution = 0.5
        
        let background = SKSpriteNode(imageNamed: "Battle Arena-1")
        background.position = CGPoint(x: 0, y: 0)
        background.blendMode = .replace
        background.size.width = UIScreen.main.bounds.width
        background.size.height = UIScreen.main.bounds.height
        background.zPosition = -1
        addChild(background)
        
        self.scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // imposta il vettore della gravità dell'intera scena a 0
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: scene!.frame) //imposta la scena intera come bordo
        self.physicsBody!.restitution = 0.2 //Aggiunge la proprietà rimbalzante a tutti i physics body (in questo caso lo slime)
        
        view.ignoresSiblingOrder = true
        view.showsPhysics = false
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        
        
        
        
        
        //        let slime1 = Redslime()
        //        slime1.position = CGPoint(x: -100, y: 0)
        //        self.addChild(slime1)
        //        self.addChild(slime1.playerbar)
        //        slime1.playerbar.position = CGPoint(
        //            x: slime1.position.x,
        //            y: slime1.position.y + slime1.size.height/2
        //        )
        //        print(slime1.HP, slime1.actualHP, slime1.AGI, slime1.PWR, slime1.DEF)
        //
        //        let slime2 = Redslime()
        //        slime2.position = CGPoint(x: 100, y:0)
        //        self.addChild(slime2)
        //        self.addChild(slime2.playerbar)
        //        slime2.playerbar.position = CGPoint(
        //            x: slime2.position.x,
        //            y: slime2.position.y + slime2.size.height/2
        //        )
        //        print(slime2.HP, slime2.AGI, slime2.PWR, slime2.DEF)
        //
        
        
        //
        //        let allyPiece = Redslime()
        //        allyPiece.position = CGPoint(x: -50, y: 0)
        //        allyPiece.playerbar.position = CGPoint(x: allyPiece.position.x + 40, y: allyPiece.position.y + ((allyPiece.size.height/2)) + 5)
        //        allyPiece.setScale(0.7)
        //        addChild(allyPiece)
        //        allyPiece.addChild(allyPiece.playerbar)
        //        allyPiece.physicsBody = SKPhysicsBody(circleOfRadius: allyPiece.size.width/2)
        //        allyPiece.physicsBody?.collisionBitMask = 1
        //        allyPiece.physicsBody?.categoryBitMask = 2
        //        allyPiece.physicsBody?.allowsRotation = false
        //        allyPiece.physicsBody?.mass = 1
        //        allyPiece.physicsBody?.restitution = 0.5
        
        let enemyPiece = Badslime()
        enemyPiece.position = CGPoint(x: 0, y: +160)
        enemyPiece.name = "dino"
        enemyPiece.playerbar.position = CGPoint(x: enemyPiece.position.x, y: enemyPiece.position.y - 20)
        enemyPiece.setScale(0.4)
        enemyPiece.physicsBody = SKPhysicsBody(circleOfRadius: enemyPiece.size.width/3)
        enemyPiece.physicsBody?.mass = 1.2
        enemyPiece.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemyPiece.physicsBody?.collisionBitMask = PhysicsCategory.Ally
        enemyPiece.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        enemyPiece.physicsBody?.allowsRotation = false
        enemyPiece.physicsBody?.restitution = 0.5
        enemyPiece.physicsBody?.friction = 0.8
        worldNode.addChild(enemyPiece)
        enemyPiece.addChild(enemyPiece.playerbar)
        //        enemyPiece.physicsBody?.isDynamic = true
        
        myson.position = CGPoint(x: 0, y: -180)
        myson.name = "myson"
        myson.physicsBody = SKPhysicsBody(circleOfRadius: myson.size.width/3)
        myson.physicsBody?.mass = 0.5
        myson.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        myson.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        myson.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        myson.physicsBody?.allowsRotation = false
        myson.physicsBody?.restitution = 0.3
        myson.physicsBody?.friction = 0.8
        originalMysonPos = myson.position
        myson.playerbar.position = CGPoint(x: myson.position.x, y: myson.position.y-(myson.position.y*2 + 20))
        worldNode.addChild(myson)
        //        myson.physicsBody?.isDynamic = true
        myson.setScale(0.4)
        myson.addChild(myson.playerbar)
        
        
        //
        
        func clash (body1: Redslime, body2: Badslime) {
            print("CLASH!")
            body1.actualHP -= 10
            body2.actualHP -= 10
        }
    }
}

