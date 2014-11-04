//
//  GameScene.swift
//  Boomerang
//
//  Created by Olof Harrysson on 2014-10-18.
//  Copyright (c) 2014 Olof Harrysson. All rights reserved.
//

import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

enum ColliderType: UInt32 {
    case Boomerang = 1
    case Obstacle = 2
    case Goal = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var lastUpdateTime: NSTimeInterval = 0.0
    var dt: NSTimeInterval = 0.0
    var movingBoom: Boomerang?
    var boomToThrow: Boomerang!
    var wayPoints: [CGPoint] = []
    let deadSound: SKAction = SKAction.playSoundFileNamed("deathrattle.wav", waitForCompletion: false)
    
    override init(size: CGSize) {
        super.init(size: size)
        physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.whiteColor()
        loadLevel()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func throwBoom() {
        if wayPoints.count > 1 {
            let boomNode = Boomerang(imageNamed: "boomerang", wayPoints: wayPoints)


            boomNode.name = "boom"
            boomNode.zPosition = 2
            addChild(boomNode)
            
            let boompath = boomNode.setCurve()
            let moveAction = SKAction.followPath(boompath, asOffset: true, orientToPath: false, duration: 2.0)
            boomNode.runAction(SKAction.sequence([ moveAction,
                SKAction.fadeAlphaTo(0.0, duration: 0.3),
                SKAction.removeFromParent()]))
        }

    }

    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point)
    }

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
  
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let location = touches.anyObject()!.locationInNode(self)
        addMovingPoint(location)

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let location = touches.anyObject()!.locationInNode(scene)
        addMovingPoint(location)

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        throwBoom()
        wayPoints = []
    }
    
    

    override func update(currentTime: CFTimeInterval) {
        dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var kangNode = contact.bodyA.node;
        var boomNode = contact.bodyB.node;
        
        if(kangNode!.name != "kang"){
            let tempNode = boomNode
            kangNode = boomNode
            boomNode = tempNode
        }
        let kang = kangNode as SKSpriteNode
        let boom = boomNode as Boomerang
        

        let collision = kangNode!.physicsBody!.categoryBitMask | boomNode!.physicsBody!.categoryBitMask;
        

        if collision == ColliderType.Boomerang.toRaw() | ColliderType.Goal.toRaw() {
            let kangPos = kang.position
            kang.removeFromParent()
            boom.physicsBody = nil
            
            let deadKangNode = childNodeWithName("deadkang")
            let deadKang = deadKangNode as SKSpriteNode
            let newPos = CGPoint(x: kangPos.x - 5, y: kangPos.y - 10)
            deadKang.position = newPos
            deadKang.hidden = false
            runAction(deadSound)
            deadKang.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.0))
            deadKang.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0))
            
            spawnKang()
            
        } else if collision == ColliderType.Boomerang.toRaw() | ColliderType.Obstacle.toRaw() {
            println("FAIL :[")
        }else if collision == ColliderType.Boomerang.toRaw() | ColliderType.Boomerang.toRaw() {
                println("Boom krock")
        } else {
            NSLog("Error: Unknown collision category \(collision)");
        }
    }
    
    func loadLevel() {
        
        spawnKang()
    
        let deadkangSize: CGSize = CGSize(width: 50.0, height: 60.0)
        let deadKangTex: SKTexture = SKTexture(imageNamed: "deadkangaroo")
        let deadKangNode = SKSpriteNode(texture: deadKangTex, size: deadkangSize)
        deadKangNode.name = "deadkang"
        deadKangNode.hidden = true
        deadKangNode.zRotation = CGFloat(M_PI / 2)
        addChild(deadKangNode)
        
        let playerSize: CGSize = CGSize(width: 96.6, height: 150)
        let playerTex: SKTexture = SKTexture(imageNamed: "banksy")
        let playerNode = SKSpriteNode(texture: playerTex, size: playerSize)
        playerNode.name = "player"
        playerNode.position = CGPoint(x: size.width * 0.5, y: 100)
        addChild(playerNode)
        
    }
    
    func spawnKang () {
        let kangSize: CGSize = CGSize(width: 50.0, height: 60.0)
        let kangTex: SKTexture = SKTexture(imageNamed: "kangaroo")
        let kangNode = SKSpriteNode(texture: kangTex, size: kangSize)
        
        kangNode.name = "kang"

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let xSpawnPos: Int = Int(arc4random_uniform(UInt32(screenWidth+1 - kangSize.width))) + Int(kangSize.width / 2)
        
        kangNode.position = CGPoint(x: xSpawnPos, y: 550)
        kangNode.zPosition = 1
        
        kangNode.physicsBody = SKPhysicsBody(rectangleOfSize: kangNode.size)
        kangNode.physicsBody!.categoryBitMask = ColliderType.Goal.toRaw()
        kangNode.physicsBody!.dynamic = false
        
        addChild(kangNode)
    }
    
    
}
