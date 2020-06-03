import SpriteKit

final class GameScene: SKScene {
    typealias Difficulty = GameManager.Difficulty
    
    var gameManager = GameManager()
    
    var difficulty: Difficulty?
    private var player: SKSpriteNode!
    private var trashCan: SKSpriteNode!
    private var trash = [SKSpriteNode]()
    private var trashLabel: SKLabelNode!
    private var carryTrashLabel: SKLabelNode!
    private var enemies = [SKSpriteNode]()
    private var hearts = [SKSpriteNode]()
    private var joystick: Joystick!
    private var backButton: Button!
    
    private var enemiesSpeed: CGFloat {
        get {
            switch difficulty {
            case .medium, .hard:
                return 45
            default:
                return 40
            }
        }
    }
    private var lastPlayerAlpha: CGFloat = 0
    private var lastPlayerSpeed: CGFloat = 0
    
    
    class func createGame(fileNamed: String, difficulty: Difficulty) -> GameScene {
        guard let scene = GameScene(fileNamed: fileNamed) else { fatalError("Scene file not found") }
        scene.difficulty = difficulty
        return scene
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        
        loadNodes()
        setupBackButton()
        setupJoystick()
        setupHearts()
        setupTrashLabel()
        setupCarryTrashLabel()
        
        AudioManager.shared.playBackgroundMusic(type: .game)
    }
    
    private func loadNodes() {
        player = childNode(withName: "player") as? SKSpriteNode
        trashCan = childNode(withName: "trashCan") as? SKSpriteNode
        for child in children {
            if child.name == "enemy", let child = child as? SKSpriteNode {
                enemies.append(child)
            } else if child.name == "trash", let child = child as? SKSpriteNode {
                trash.append(child)
            }
        }
    }
    
    private func setupBackButton() {
        backButton = Button(size: CGSize(width: 24, height: 24), imageNamed: "back")
        backButton.delegate = self
        backButton.position = CGPoint(x: 16, y: size.height - 16 - backButton.size.height)
        backButton.zPosition = 100
        addChild(backButton)
    }
    
    private func setupJoystick() {
        joystick = Joystick(radius: 50)
        joystick.delegate = self
        joystick.position = CGPoint(x: size.width - 100, y: 100)
        joystick.zPosition = 100
        addChild(joystick)
    }
    
    private func setupHearts() {
        for i in 0..<3 {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.anchorPoint = CGPoint(x: 1, y: 1)
            heart.size = CGSize(width: 24, height: 26)
            heart.position = CGPoint(x: size.width - 16 - 30 * CGFloat(2 - i), y: size.height - 16)
            heart.zPosition = 100
            hearts.append(heart)
            addChild(heart)
        }
    }
    
    private func setupTrashLabel() {
        trashLabel = SKLabelNode(fontNamed: .fontMedium)
        trashLabel.fontSize = 14
        trashLabel.zPosition = 100
        trashLabel.position = CGPoint(x: size.width / 2, y: backButton.frame.midY)
        trashLabel.text = "Trash Recycled: 0"
        trashLabel.verticalAlignmentMode = .center
        
        let background = SKShapeNode(rectOf: CGSize(width: trashLabel.frame.width + 16, height: trashLabel.frame.height + 8), cornerRadius: 10)
        background.position = CGPoint(x: 0, y: 2)
        background.strokeColor = .clear
        background.fillColor = .main
        background.zPosition = -1
        trashLabel.addChild(background)
        addChild(trashLabel)
    }
    
    private func setupCarryTrashLabel() {
        carryTrashLabel = SKLabelNode(fontNamed: .fontMedium)
        carryTrashLabel.fontSize = 14
        carryTrashLabel.zPosition = 100
        carryTrashLabel.position = CGPoint(x: size.width / 2, y: 30)
        carryTrashLabel.text = "You are carrying trash!"
        carryTrashLabel.verticalAlignmentMode = .center
        
        let background = SKShapeNode(rectOf: CGSize(width: carryTrashLabel.frame.width + 16, height: carryTrashLabel.frame.height + 8), cornerRadius: 10)
        background.position = CGPoint(x: 0, y: 2)
        background.strokeColor = .clear
        background.fillColor = .main
        background.zPosition = -1
        carryTrashLabel.addChild(background)
        carryTrashLabel.alpha = 0
        addChild(carryTrashLabel)
    }
    
    override func didSimulatePhysics() {
        if let player = player {
            updatePlayer(player, to: lastPlayerAlpha, speed: lastPlayerSpeed)
            for enemy in enemies {
                updateEnemy(enemy, to: player.position, speed: enemiesSpeed)
            }
        }
    }
    
    private func updatePlayer(_ player: SKSpriteNode, to angle: CGFloat, speed: CGFloat) {
        let rotation = SKAction.rotate(toAngle: angle - CGFloat.pi / 2, duration: 0.0)
        player.run(rotation)
        
        let velocityX = speed * 60 * cos(angle < 0 ? 2 * CGFloat.pi - abs(angle) : angle)
        let velocityY = speed * 60 * sin(angle < 0 ? 2 * CGFloat.pi - abs(angle) : angle)
        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        player.physicsBody?.velocity = newVelocity
    }
    
    private func updateEnemy(_ enemy: SKSpriteNode, to position: CGPoint, speed: CGFloat) {
        let currentPosition = enemy.position
        let angle = CGFloat.pi + atan2(currentPosition.y - position.y, currentPosition.x - position.x)
        
        let rotation = SKAction.rotate(toAngle: angle - CGFloat.pi / 2, duration: 0.0)
        enemy.run(rotation)
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
        enemy.physicsBody?.velocity = CGVector(dx: velocityX, dy: velocityY)
    }
    
    private func gameOver(_ didWin: Bool) {
        view?.presentScene(ResultsScene(size: size, didWin: didWin), transition: SKTransition.fade(withDuration: 0.6))
    }
    
}

extension GameScene: JoystickDelegate {
    func positionChanged(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat) {
        lastPlayerAlpha = alpha
        lastPlayerSpeed = distance
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody // Player
        var secondBody: SKPhysicsBody // Enemy, trash or trash can
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == player.physicsBody?.categoryBitMask && secondBody.categoryBitMask == enemies.first?.physicsBody?.categoryBitMask {
            
            guard secondBody.collisionBitMask != 0 else { return }
            secondBody.collisionBitMask = 0
            let action = SKAction.sequence([.fadeAlpha(to: 0.6, duration: 0.08), .fadeAlpha(to: 0.8, duration: 0.05), .fadeAlpha(to: 0.2, duration: 0.1), .removeFromParent()])
            secondBody.node?.run(action)
            
            gameManager.lives -= 1
            let targetHeart = hearts[gameManager.lives]
            targetHeart.run(action)
            
            if gameManager.lives == 0 {
                gameOver(false)
            }
            // player touched an enemy.
        } else if firstBody.categoryBitMask == player.physicsBody?.categoryBitMask && secondBody.categoryBitMask == trash.first?.physicsBody?.categoryBitMask {
            if !gameManager.playerHasTrash {
                gameManager.playerHasTrash = true
                secondBody.node?.removeFromParent()
                carryTrashLabel.run(.fadeIn(withDuration: 0.3))
            }
        } else if firstBody.categoryBitMask == player.physicsBody?.categoryBitMask && secondBody.categoryBitMask == trashCan.physicsBody?.categoryBitMask {
            if gameManager.playerHasTrash {
                gameManager.playerHasTrash = false
                gameManager.trashRecycled += 1
                
                trashLabel.text = "Trash recycled: \(gameManager.trashRecycled)"
                carryTrashLabel.run(.fadeOut(withDuration: 0.15))
            }
            if gameManager.trashRecycled == 3 {
                if let difficulty = difficulty {
                    GameManager.gamesCompleted[difficulty.gameValue] = true
                }
                gameOver(true)
            }
        }
    }
}

extension GameScene: ButtonDelegate {
    func buttonDidTap(_ button: Button) {
        view?.presentScene(LobbyScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
    }
}
