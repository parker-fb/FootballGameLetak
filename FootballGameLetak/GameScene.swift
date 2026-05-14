import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var defender: SKSpriteNode!
    var defenders: [SKSpriteNode] = []
    var score = 0
    var dScore = 0
    
    var pScoreLabel = SKLabelNode()
    var dScoreLabel = SKLabelNode()
    
    var time = 8
    var timeLabel = SKLabelNode()
    
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }
    
    
    override func didMove(to view: SKView) {
        
        removeAllChildren()
        removeAllActions()
        
        let back = SKSpriteNode(imageNamed: "fbField")
        
        back.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        back.size = CGSize(width: frame.height, height: frame.width)
        back.zRotation = .pi / 2
        back.zPosition = -100
        
        addChild(back)
        
        player = SKSpriteNode(imageNamed: "playerImage")
        player.position = CGPoint(x: 8, y: -480)
        player.size = CGSize(width: 90, height: 100.0)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 1
        
        addChild(player)
        
        let line = SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 450))
            line.position = CGPoint(x: frame.midX, y: 670)
            line.name = "scoreLine"
        line.color = .blue
        line.physicsBody = SKPhysicsBody(rectangleOf: line.size)
        line.physicsBody?.isDynamic = false
        line.physicsBody?.categoryBitMask = 1
        line.physicsBody?.contactTestBitMask = 1
            addChild(line)
        
        for i in 0..<5{
            let defender = SKSpriteNode(imageNamed: "def2")
            
            defender.position = CGPoint(x: 60 + (i * 150), y: -340 + (i * 300))
            defender.size = CGSize(width: 90.0, height: 100.0)
            defender.physicsBody = SKPhysicsBody(rectangleOf: defender.size)
            defender.physicsBody?.affectedByGravity = false
            defender.physicsBody?.allowsRotation = false
            defender.physicsBody?.categoryBitMask = 1
            defender.physicsBody?.contactTestBitMask = 1
            addChild(defender)
            
            defenders.append(defender)
            
            startDefenderMovement(defender)
        }
        
//        defender = SKSpriteNode(imageNamed: "defender")
        //defender.position = CGPoint(x: 260, y: 60)
//        addChild(defender)
//        startDefenderMovement()
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        
        pScoreLabel.text = "0"
        pScoreLabel.fontSize = 40
        pScoreLabel.fontColor = .black
        pScoreLabel.position = CGPoint(x: -260, y: -550)
        addChild(pScoreLabel)
        
        let dash = SKLabelNode()
        dash.text = "-"
        pScoreLabel.fontSize = 50
        pScoreLabel.fontColor = .black
        dash.position = CGPoint(x: -230, y: -535)
        addChild(dash)
        dScoreLabel.text = "0"
        dScoreLabel.fontSize = 45
        dScoreLabel.fontColor = .red
        dScoreLabel.position = CGPoint(x: -200, y: -550)
        addChild(dScoreLabel)
        
        timeLabel.text = "1:00"
        timeLabel.fontSize = 40
        timeLabel.fontColor = .black
        timeLabel.position = CGPoint(x: -230, y: -590)
        addChild(timeLabel)
        
//        pScoreLabel.zPosition = 100
//        dScoreLabel.zPosition = 100
//        timeLabel.zPosition = 100
//        dash.zPosition = 100
//        line.zPosition = 1
        
        timer()
        
       
        
    }
    
    func timer(){
        let wait = SKAction.wait(forDuration: 1)
        let countdown = SKAction.run{
            self.time -= 1
            self.timeLabel.text = "0:\(self.time)"
            
            if self.time <= 0 {
                        self.gameOver()
                    }
            
        }
        
        let sequence = SKAction.sequence([wait, countdown])
        
        run(SKAction.repeatForever(sequence))
    }
    
    func gameOver() {
        removeAction(forKey: "gameTimer")
        player.removeAllActions()
        for defender in defenders {
            defender.removeAllActions()
        }
        isUserInteractionEnabled = false
        let dark = SKSpriteNode(color: .black,
                                size: CGSize(width: frame.width,
                                             height: frame.height))
        dark.alpha = 0.8
        dark.position = CGPoint(x: frame.midX, y: frame.midY)
        dark.zPosition = 500
        addChild(dark)
        let gameOverLabel = SKLabelNode(fontNamed: "Arial-Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 70
        gameOverLabel.position = CGPoint(x: 0, y: 100)
        gameOverLabel.zPosition = 501
        addChild(gameOverLabel)
        let restart = SKLabelNode(fontNamed: "Arial")
        restart.text = "Restart"
        restart.name = "restartButton"
        restart.fontSize = 50
        restart.position = CGPoint(x: 0, y: -30)
        restart.zPosition = 501
        addChild(restart)
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let node = atPoint(location)
        if node.name == "restartButton" {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .resizeFill
            view?.presentScene(scene)
        }
    }
    
    var isResetting = false
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("hit")
        let nodeA = contact.bodyA.node
            let nodeB = contact.bodyB.node
            
            if nodeA?.name == "scoreLine" || nodeB?.name == "scoreLine" {
                score += 1
//                pScoreLabel = "\(score)"
//                print("p \(pScoreLabel)")
                pScoreLabel.text = "\(score)"
            }
            
            if nodeA == player || nodeB == player {
                //print("hit")
                dScore += 1
//                dScoreLabel = "\(dScore)"
//                print("d \(dScoreLabel)")
                dScoreLabel.text = "\(dScore)"
                reset()
            }
        
    }
    
    func reset(){
        //let res = SKAction.moveTo(x: 8, y: -480, duration: 0)
        let res = SKAction.move(to: CGPoint(x: 8, y: -480), duration: 0)
        player.run(res)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        let dx = location.x - previous.x
        let dy = location.y - previous.y
        
        if abs(dx) > abs(dy) {
            if dx > 0 {
                movePlayer(by: CGVector(dx: 15, dy: 0))
            } else {
                movePlayer(by: CGVector(dx: -15, dy: 0))
            }
        } else {
            if dy > 0 {
                movePlayer(by: CGVector(dx: 0, dy: 15))
            } else {
                movePlayer(by: CGVector(dx: 0, dy: -15))
            }
        }
    }
    func movePlayer(by vector: CGVector) {
        let move = SKAction.moveBy(x: vector.dx, y: vector.dy, duration: 0.2)
        player.run(move)
    }
    func startDefenderMovement(_ defender: SKSpriteNode) {
////        let left = SKAction.moveBy(x: -300, y: 0, duration: 2)
////        let right = SKAction.moveBy(x: 300, y: 0, duration: 2)
//        
//        let left = SKAction.moveTo(x: -260, duration: 2)
//        let right = SKAction.moveTo(x: 260, duration: 2)
//        
//        //SKAction.moveTo(x: 300, duration: 2)
//        let patrol = SKAction.sequence([left, right])
//        defender.run(SKAction.repeatForever(patrol))
        
        let randomSpeed = Double.random(in: 1.2...3.0)

           // keep defenders inside screen edges
           let leftEdge = -frame.width/2 + defender.size.width
           let rightEdge = frame.width/2 - defender.size.width

           let left = SKAction.moveTo(
               x: CGFloat.random(in: leftEdge...0),
               duration: randomSpeed
           )

           let right = SKAction.moveTo(
               x: CGFloat.random(in: 0...rightEdge),
               duration: randomSpeed
           )

           let wait = SKAction.wait(
               forDuration: Double.random(in: 0.1...0.5)
           )

           let patrol = SKAction.sequence([left, wait, right, wait])

           defender.run(SKAction.repeatForever(patrol))
        
        
    }
}

