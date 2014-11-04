//
//  Boomerang.swift
//  Boomerang
//
//  Created by Olof Harrysson on 2014-10-18.
//  Copyright (c) 2014 Olof Harrysson. All rights reserved.
//
//println("\(length)")


import Foundation
import SpriteKit
import UIKit

class Boomerang: SKSpriteNode {

    let POINTS_PER_SEC: CGFloat = 80.0
    var wayPoints: [CGPoint] = []
    var velocity = CGPoint(x: 0, y: 0)
    var rotation: CGFloat = (CGFloat)(M_PI / 18) // Animation
    var ySpeed: CGFloat!
    var startDir: CGPoint!
    var maxDis: CGFloat!
    var length: CGFloat = 0.0
    var isAlive: Bool = true
    
    init(imageNamed name: String!, wayPoints: [CGPoint]){
        let boomSize: CGSize = CGSize(width: 46.0, height: 37.0)
        let boomTex: SKTexture = SKTexture(imageNamed: "boomerang")
        let boomNode = SKSpriteNode(texture: boomTex, size: boomSize)
        super.init(texture: boomTex, color: nil, size:boomSize)
        self.wayPoints = wayPoints
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
        physicsBody!.categoryBitMask = ColliderType.Boomerang.toRaw()
        physicsBody!.contactTestBitMask = ColliderType.Obstacle.toRaw() | ColliderType.Goal.toRaw()
        physicsBody!.collisionBitMask = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point)
    }
    
    func setCurve () -> CGPathRef {
        var boomPath = CGPathCreateMutable()
        var beziPath = UIBezierPath()
        
        if wayPoints.count > 1 {
            var tempWayPoints: [CGPoint] = []

            var boomStartx : CGFloat = 150.0
            var boomStarty : CGFloat = 140.0
            CGPathMoveToPoint(boomPath!, nil, boomStartx, boomStarty)
            let startPoint =  CGPoint(x: boomStartx, y:boomStarty)
            beziPath.moveToPoint(startPoint)
            beziPath.miterLimit = 30
            
            //offset so boomerang spawns where intended
            var xOffset: CGFloat = boomStartx - wayPoints[0].x
            var yOffset: CGFloat = boomStarty - wayPoints[0].y
                        
            for wayP in wayPoints {
                let point = CGPoint(x: wayP.x + xOffset, y: wayP.y + yOffset)
                beziPath.addLineToPoint(point)
            }
            
            let smoothBoomPath = beziPath.CGPath

            return smoothBoomPath
        }
        return boomPath
    }
    
    func setCurve1 () -> CGPathRef {
        var boomPath = CGPathCreateMutable()
        var beziPath = UIBezierPath()
        
        if wayPoints.count > 1 {
            var tempWayPoints: [CGPoint] = []
            
            var boomStartx : CGFloat = 150.0
            var boomStarty : CGFloat = 140.0
            CGPathMoveToPoint(boomPath!, nil, boomStartx, boomStarty)
            let startPoint =  CGPoint(x: boomStartx, y:boomStarty)
            beziPath.moveToPoint(startPoint)
            beziPath.miterLimit = 30 // Behövs?
            
            //offset so boomerang spawns where intended
            var xOffset: CGFloat = boomStartx - wayPoints[0].x
            var yOffset: CGFloat = boomStarty - wayPoints[0].y
            
            
            for wayP in wayPoints {
                let point = CGPoint(x: wayP.x + xOffset, y: wayP.y + yOffset)
                beziPath.addLineToPoint(point)
            }
            
            let smoothBoomPath = beziPath.CGPath
            
            return smoothBoomPath
        }
        return boomPath
    }

}