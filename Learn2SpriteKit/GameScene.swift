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
    var sceneManagerDelegate: SceneManagerDelegate?
    var myson = Redslime()
    var myenemy = Badslime()
    var originalMysonPos: CGPoint!
    var hasGone = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        if myson.actualHP<=0 {
            myson.removeFromParent()
        }
        
        if myenemy.actualHP<=0 {
            myenemy.removeFromParent()
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
    
    //    func collisionBetween(myson: SKNode, object: SKNode) {
    //        if object.name == "dino" {
    //    print("clash")
    //        } else if object.name == "Muro" {
    //    print("wall")
    //    }
    //    }
    
    
    func clash (body1: Redslime, body2: Badslime) {
        print("CLASH!")
//        body1.actualHP -= 10
        body2.actualHP -= 10
        body2.updateHealthBar(body2, withHealthPoints: body2.actualHP, withMaxHP: body2.HP)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
            run(SKAction.playSoundFileNamed("Bruh Sound Effect.mp3", waitForCompletion: false))
            clash(body1: myson, body2: myenemy)
            
        }
        
        func didEnd(_ contact: SKPhysicsContact) {
            //            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            //            if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
            //            }
        }
    }
    
    override func didMove(to view: SKView) {
        
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
        
        
        myenemy.position = CGPoint(x: 0, y: +160)
        myenemy.name = "dino"
        myenemy.playerbar.position = CGPoint(x: myenemy.position.x, y: myenemy.position.y - 20)
        myenemy.setScale(0.4)
        myenemy.physicsBody = SKPhysicsBody(circleOfRadius: myenemy.size.width/3)
        myenemy.physicsBody?.mass = 1.2
        myenemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        myenemy.physicsBody?.collisionBitMask = PhysicsCategory.Ally
        myenemy.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        myenemy.physicsBody?.allowsRotation = false
        myenemy.physicsBody?.restitution = 0.5
        myenemy.physicsBody?.friction = 0.8
        addChild(myenemy)
        myenemy.addChild(myenemy.playerbar)
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
        addChild(myson)
        //        myson.physicsBody?.isDynamic = true
        myson.setScale(0.4)
        myson.addChild(myson.playerbar)
        
        
        //
        
        
        
    }
    
    //MARK: HEALTH BARS POSITION
    
    
    
    
    //MARK: DMG CALC WITH FRAMES
    
    
    //
    //        player1HP = max(0, player1HP - (slime2.PWR - (slime1.DEF)/2))
    //        player2HP = max(0, player2HP - (slime1.PWR - (slime2.DEF)/2))
    
    
    
    
    
    //MARK: UPDATE HB FUNCTION
    
}

