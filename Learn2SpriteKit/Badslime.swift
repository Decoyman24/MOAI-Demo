//
//  Badslime.swift
//  Learn2SpriteKit
//
//  Created by Luigi Minniti on 16/02/22.
//
import SpriteKit

class Badslime : SKSpriteNode, GameSprite, EventListenerNode {
    
    var initialSize: CGSize = CGSize (width: 250, height: 250)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "blackie")
    var idleAnimation = SKAction()
    let playerbar = SKSpriteNode()
    var isTapped = false
    var actualHP: Int
    
    func updateHealthBar(_ node: SKSpriteNode, withHealthPoints hp: Int, withMaxHP maxHP: Int) {
        
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
        
        let fillColor = UIColor(red: 123.0/255, green: 200.0/255, blue: 30.0/255, alpha:1)
        
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint.zero, size: barSize)
        context.stroke(borderRect, width: 0.5)
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width + 1) * CGFloat(hp) / CGFloat(maxHP)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context.fill(barRect)
        
        // extract image
        guard let spriteImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
        node.texture = SKTexture(image: spriteImage)
        node.size = barSize
    }
    
    func didMoveToScene() {
        //      physicsBody!.isDynamic = false
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody!.collisionBitMask = PhysicsCategory.Ally
//        self.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Ally
    }
    
    func onTap(){
        isTapped.toggle()
        self.physicsBody?.applyImpulse(CGVector(dx:-800, dy:0))

        if actualHP>0 {
        self.updateHealthBar(self.playerbar, withHealthPoints: self.actualHP, withMaxHP: self.HP)
        print("Hai tappato mongoloide, ora hai \(actualHP) hp")
        }
        else if actualHP<=0 {
            playerbar.run(SKAction.removeFromParent())
            run(SKAction.removeFromParent())
            print("Hai muorto")
        }
    }
    
    var HP = statValue.nextInt()*10
    var PWR = statValue.nextInt()
    var DEF = statValue.nextInt()
    var AGI = statValue.nextInt()
    
    init (){
        actualHP = self.HP
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation(frame1: "Blackie", frame2: "Blackie2")
        updateHealthBar(playerbar, withHealthPoints: actualHP, withMaxHP: HP)
        self.run(idleAnimation)
        
        func createAnimation(frame1: String, frame2: String){
            let idleFrames: [SKTexture] = [textureAtlas.textureNamed(frame1), textureAtlas.textureNamed(frame2)]
            let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.5)
            idleAnimation = SKAction.repeatForever(idleAction)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
