//
//  GameScene.swift
//  fizzgig-vs-tribble
//
//  Created by David Fleming on 8/28/16.
//  Copyright © 2016 defaultdave. All rights reserved.
//



import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    var accellLabel: SKLabelNode!
    var gyroLabel: SKLabelNode!
    var deviceMotionLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    
    var score: Int32 = 0
    
    var pathEmitter = SKEmitterNode(fileNamed: "ballSmoke.sks")
    
    
    override func didMoveToView(view: SKView) {
        //Setup background
        backgroundColor = SKColor.blackColor()
        setupBackground()
        
        //Setup some basic physics, lets make a little downward gravity
        physicsWorld.gravity = CGVectorMake(0, -5)
        physicsWorld.contactDelegate = self
        //Setup the physics frame so things dont fall off
//        let rect = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y - 100), size: CGSize(width: self.frame.width, height: self.frame.height + 100))
        let rect = self.frame
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        self.name = "main"
        self.physicsBody = physicsBody
        
        print("Game Scene setup")
        print(size)
        
        // Make some labels
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: "
        scoreLabel.fontSize = 14
        scoreLabel.fontColor = SKColor.redColor()
        scoreLabel.horizontalAlignmentMode = .Center
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        self.addChild(scoreLabel)
        
        accellLabel = SKLabelNode(fontNamed: "Chalkduster")
        accellLabel.text = "Acc: "
        accellLabel.fontSize = 14
        accellLabel.fontColor = SKColor.redColor()
        accellLabel.horizontalAlignmentMode = .Center
        accellLabel.position = CGPoint(x: -200, y: size.height - 100)
        self.addChild(accellLabel)
        
        gyroLabel = SKLabelNode(fontNamed: "Chalkduster")
        gyroLabel.text = "Gyro: "
        gyroLabel.fontSize = 14
        gyroLabel.fontColor = SKColor.redColor()
        gyroLabel.horizontalAlignmentMode = .Center
        gyroLabel.position = CGPoint(x: -200, y: size.height - 150)
        self.addChild(gyroLabel)
        
        deviceMotionLabel = SKLabelNode(fontNamed: "Chalkduster")
        deviceMotionLabel.text = "Mot: "
        deviceMotionLabel.fontSize = 14
        deviceMotionLabel.fontColor = SKColor.redColor()
        deviceMotionLabel.horizontalAlignmentMode = .Center
        deviceMotionLabel.position = CGPoint(x: -200, y: size.height - 200)
        self.addChild(deviceMotionLabel)
        
        
        pathEmitter?.position = CGPointMake(-100, -100)
        pathEmitter?.particleColor = SKColor.redColor()
        pathEmitter?.targetNode = scene
        self.addChild(pathEmitter!)
        
        //Setup Background music
        let backgroundMusic = SKAudioNode(fileNamed: "06 Searching.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        setupMotion()
        
        createBall()
    }
    
    func setupBackground(){
        
        var frames: [SKTexture] = []
        
        //Go through all the images add to an array
        for i in 1...32 {
            let texture = SKTexture(imageNamed: "city-background-\(i).png")
            frames.append(texture)
        }
        
        //Setup the first images as a placeholder
        let mainBg = SKSpriteNode(imageNamed: "city-background-1.png")
        mainBg.size = self.size
        mainBg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        
        let animation = SKAction.animateWithTextures(frames, timePerFrame: 0.2)
        mainBg.runAction(SKAction.repeatActionForever(animation))
        
        self.addChild(mainBg)
        mainBg.zPosition = -10
        
    }
    
    func setupMotion() {
        
        if motionManager.gyroAvailable && motionManager.accelerometerAvailable  {
            let updateTime: NSTimeInterval = 0.5
            motionManager.deviceMotionUpdateInterval = updateTime
            motionManager.gyroUpdateInterval = updateTime
            motionManager.accelerometerUpdateInterval = updateTime
//            motionManager.startDeviceMotionUpdates()
//            motionManager.startGyroUpdates()
            motionManager.startAccelerometerUpdates()
            
            
            
            //Accelerometer
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                accellData, error in
                if let data = accellData {
                    self.accellLabel.text = "Acc: X:\(Double(data.acceleration.x).roundToPlaces(3)) Y:\(Double(data.acceleration.y).roundToPlaces(3)) Z:\(Double(data.acceleration.z).roundToPlaces(3))"
                    self.physicsWorld.gravity.dx = CGFloat(data.acceleration.x * 5)
                    self.physicsWorld.gravity.dy = CGFloat(data.acceleration.y * 5)
                }
            })
            
            //Gyro
//            motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
//                gyroData, error in
//                if let data = gyroData {
//                    self.gyroLabel.text = "Gyro: X:\(Double(data.rotationRate.x).roundToPlaces(3)) Y:\(Double(data.rotationRate.y).roundToPlaces(3)) Z:\(Double(data.rotationRate.z).roundToPlaces(3))"
//                }
//            })
            
            //Device Motion
//            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
//                motionData, error in
//                if let data = motionData {
//                    self.deviceMotionLabel.text = "Mot: X:\(Double(data.rotationRate.x).roundToPlaces(3)) Y:\(Double(data.rotationRate.y).roundToPlaces(3)) Z:\(Double(data.rotationRate.z).roundToPlaces(3))"
//                }
//            })
            
            
        }
        
    }
    
    func createBall() -> SKSpriteNode {
        print("Setup Balls")
        //Setup image
        let rand = Int.random(0...100)
        var choice = "tribble"
        //if greater than 75%, switch to fizzgig
        if rand > 75 {
            choice = "fizzgig"
        }
        
        if choice == "fizzgig" {
            runAction(SKAction.playSoundFileNamed("fizzgig-bark.mp3", waitForCompletion: false))
        } else {
            runAction(SKAction.playSoundFileNamed("tribble-purr.mp3", waitForCompletion: false))
        }
        
        let ball = SKSpriteNode(imageNamed: choice)
        //give it a name
        ball.name = "Ball-\(choice)"
        // Set size and starting location
        let ballSize = CGSize(width: 50, height: 50)
        ball.size = ballSize
        
        // Give the ball a random starting place
        let x = CGFloat(arc4random_uniform(UInt32(size.width  - ballSize.width)))
        print(x)
        //        ball.position = CGPoint(x: x, y: size.height - (ballSize.height / 2))
        ball.position = CGPoint(x: x, y: 50)
        
        //Add the ball to the scene
        self.addChild(ball)
        
        //Add some physics
        let ballRadius = CGFloat(ballSize.width / 2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        if let ballBody = ball.physicsBody {
            ballBody.friction = 0.5
            ballBody.restitution = 0.5
            ballBody.mass = 1
            ballBody.allowsRotation = true
            ballBody.affectedByGravity = true
            ballBody.contactTestBitMask = ballBody.collisionBitMask
            ballBody.dynamic = true
            // left to right velocity
            let x = CGFloat(Int.random(-100...100))
            // upwards velocity
            let y = CGFloat(Int.random(400...900))
            ballBody.velocity = CGVectorMake(x,y)
        }
        
        //Play audio when ball is created, bounced?
        
        //Add a smoke trail
        let emitter = SKEmitterNode(fileNamed: "ballSmoke.sks")
        emitter?.particleColor = SKColor.blueColor()
        if choice == "fizzgig" {
            emitter?.particleColor = SKColor.yellowColor()
        }
        emitter?.targetNode = scene
        ball.addChild(emitter!)
        
        //Setup a random time to make a new ball
        let d = Double(Double(Int.random(10...200)) * 0.01)
        delay(d) {
            self.createBall()
        }
        
        return ball
    }
    
    
    func destroyBall(ball: SKNode, spark: Bool = true) {
        
        //Destroy the ball
        //But add a spark first!
        if(spark) {
            sparkDestroy(ball.position)
        }
        print("Destroy ball")
        ball.removeFromParent()
        
    }
    
    func sparkDestroy(location: CGPoint) {
        
        if let sparkParticles = SKEmitterNode(fileNamed: "ballSpark.sks") {
            sparkParticles.position = location
            sparkParticles.particleColor = SKColor.redColor()
            sparkParticles.targetNode = scene
            addChild(sparkParticles)
            // Need to kill it after awhile
            delay(0.2) {
                sparkParticles.removeFromParent()
            }
        }
    }
    
    func updateScore(){
        scoreLabel.text = "Score: \(score)"
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //        print("Contact \(contact.bodyA.node!.name) \(contact.bodyB.node!.name)")
        
        if
            let bodyNode = contact.bodyB.node,
            let bodyName = bodyNode.name
        {
            if bodyName.containsString("Ball") {
                if bodyNode.position.y < 0 {
                    destroyBall(bodyNode, spark: false)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pathEmitter?.position = CGPointMake(-100, -100)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let touchLoaction = touch.locationInNode(self)
        pathEmitter?.position = touchLoaction
        
        findBallsTouched(touches)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let touchLoaction = touch.locationInNode(self)
        pathEmitter?.position = touchLoaction
    }
    
    func findBallsTouched(touches:Set<UITouch>) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if let name  = touchedNode.name {
                
                if name.containsString("Ball") {
                    var scoreAdjust:Int = 1
                    if name.containsString("fizzgig") {
                        scoreAdjust = -10
                        runAction(SKAction.playSoundFileNamed("fizzgig-scream.mp3", waitForCompletion: false))
                    } else {
                        runAction(SKAction.playSoundFileNamed("tribble-purr.mp3", waitForCompletion: false))
                    }
                    
                    score += scoreAdjust
                    updateScore()
                    self.destroyBall(touchedNode)
                }
                
            }
        }
    }
    
    //Super awesome delay function
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}


//code from https://github.com/nvzqz/RandomKit
extension Int {
    
    /// Generates a random `Int` within `0...100`
    public static func random() -> Int {
        return random(0...100)
    }
    
    /// Generates a random `Int` inside of the closed interval.
    public static func random(interval: ClosedInterval<Int>) -> Int {
        return interval.start + Int(arc4random_uniform(UInt32(interval.end - interval.start + 1)))
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}


