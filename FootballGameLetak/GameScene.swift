import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var defender: SKSpriteNode!
    var defenders: [SKSpriteNode] = []
    var score = 0
    var dScore = 0
    
    var pScoreLabel = SKLabelNode()
    var dScoreLabel = SKLabelNode()
    
    var time = 60
    var timeLabel = SKLabelNode()
    
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }
    
    
    override func didMove(to view: SKView) {
        
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
        pScoreLabel.fontColor = .white
        pScoreLabel.position = CGPoint(x: -260, y: -590)
        addChild(pScoreLabel)
        
        let dash = SKLabelNode()
        dash.text = "-"
        pScoreLabel.fontSize = 50
        pScoreLabel.fontColor = .lightGray
        dash.position = CGPoint(x: -230, y: -585)
        addChild(dash)

        dScoreLabel.text = "0"
        dScoreLabel.fontSize = 45
        dScoreLabel.fontColor = .red
        dScoreLabel.position = CGPoint(x: -200, y: -590)
        addChild(dScoreLabel)
        
        timeLabel.text = "1:00"
        timeLabel.fontSize = 40
        timeLabel.position = CGPoint(x: -230, y: -630)
        addChild(timeLabel)
        
        timer()
        
        let back = SKSpriteNode(imageNamed: "fbField")
        
        addChild(back)
        
    }
    
    func timer(){
        let wait = SKAction.wait(forDuration: 1)

        let countdown = SKAction.run{
            self.time -= 1
            self.timeLabel.text = "0:\(self.time)"
        }
        
        let sequence = SKAction.sequence([wait, countdown])
        
        run(SKAction.repeatForever(sequence))
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
//        let left = SKAction.moveBy(x: -300, y: 0, duration: 2)
//        let right = SKAction.moveBy(x: 300, y: 0, duration: 2)
        
        let left = SKAction.moveTo(x: -260, duration: 2)
        let right = SKAction.moveTo(x: 260, duration: 2)
        
        //SKAction.moveTo(x: 300, duration: 2)
        let patrol = SKAction.sequence([left, right])
        defender.run(SKAction.repeatForever(patrol))
    }
}

