import SpriteKit

final class LobbyCell: SKShapeNode {
    
    private(set) var title: String!
    private var titleLabel: SKLabelNode!
    
    private var completedLabel: SKLabelNode!
    private var difficultyLabel: SKLabelNode!
    private(set) var difficulty: GameManager.Difficulty!
    private var difficultyColour: UIColor {
        switch difficulty! {
        case .easy:
            return .systemGreen
        case .medium:
            return .systemYellow
        case .hard:
            return .systemRed
        }
    }
    
    private var arrow: SKSpriteNode!
    
    var segue: SKScene?
    
    init(size: CGSize, title: String, difficulty: GameManager.Difficulty) {
        super.init()
        self.title = title
        self.difficulty = difficulty
        
        let path = CGPath(roundedRect: CGRect(origin: .zero, size: size), cornerWidth: 25, cornerHeight: 25, transform: nil)
        self.path = path
        fillColor = .lightGray
        strokeColor = .clear
        
        initTitleLabel()
        initDifficultyLabel()
        initCompletedLabel()
        
        arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.size = CGSize(width: frame.height * 0.5, height: frame.height * 0.5)
        arrow.anchorPoint = CGPoint(x: 1, y: 0.5)
        arrow.position = CGPoint(x: frame.width - 16, y: frame.height / 2)
        addChild(arrow)
        
        isUserInteractionEnabled = true
    }
    
    private func initTitleLabel() {
        titleLabel = SKLabelNode(text: title)
        titleLabel.fontName = .fontMedium
        titleLabel.fontSize = frame.height / 2.5
        titleLabel.fontColor = .gray
        titleLabel.horizontalAlignmentMode = .left
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: 16, y: frame.height / 2)
        addChild(titleLabel)
    }
    
    private func initDifficultyLabel() {
        difficultyLabel = SKLabelNode(text: difficulty.rawValue)
        difficultyLabel.fontName = .fontMedium
        difficultyLabel.fontSize = frame.height / 3.5
        difficultyLabel.fontColor = difficultyColour
        difficultyLabel.verticalAlignmentMode = .center
        difficultyLabel.position = CGPoint(x: frame.width - 100, y: frame.height / 2)
        addChild(difficultyLabel)
    }
    
    private func initCompletedLabel() {
        if GameManager.gamesCompleted[difficulty.gameValue] {
            completedLabel = SKLabelNode(text: "✅")
            completedLabel.fontSize = frame.height / 3.5
            completedLabel.verticalAlignmentMode = .center
            completedLabel.position = CGPoint(x: frame.width - 200, y: frame.height / 2)
            addChild(completedLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let segue = segue {
            scene?.view?.presentScene(segue, transition: SKTransition.fade(withDuration: 0.6))
        }
    }
}
