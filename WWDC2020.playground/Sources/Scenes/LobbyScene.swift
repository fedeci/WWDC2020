import SpriteKit

final class LobbyScene: SKScene {
    private var backButton: Button!
    private var titleLabel: SKLabelNode!
    private var lobbyCellEasy: LobbyCell!
    private var lobbyCellMedium: LobbyCell!
    private var lobbyCellHard: LobbyCell!
    
    override init(size: CGSize) {
        super.init(size: size)
        backButton = Button(size: CGSize(width: 60, height: 60), imageNamed: "back")
        titleLabel = SKLabelNode(fontNamed: .fontMedium)
        
        lobbyCellEasy = LobbyCell(size: CGSize(width: scene!.frame.width - 32, height: 70), title: "The Park", difficulty: .easy)
        lobbyCellMedium = LobbyCell(size: CGSize(width: scene!.frame.width - 32, height: 70), title: "The Wood", difficulty: .medium)
        lobbyCellHard = LobbyCell(size: CGSize(width: scene!.frame.width - 32, height: 70), title: "The Forest", difficulty: .hard)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackButton()
        setupTitleLabel()
        setupCells()
        
        backgroundColor = .white
    }
    
    private func setupBackButton() {
        backButton.delegate = self
        backButton.position = CGPoint(x: 16, y: view!.frame.height - 16 - backButton.size.height)
        addChild(backButton)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Select a Level"
        titleLabel.fontColor = .gray
        titleLabel.verticalAlignmentMode = .center
        titleLabel.horizontalAlignmentMode = .right
        titleLabel.position = CGPoint(x: view!.frame.width - 16, y: backButton.position.y + backButton.size.height / 2)
        addChild(titleLabel)
    }
    
    private func setupCells() {
        lobbyCellEasy.segue = GameScene.createGame(fileNamed: "easy.sks", difficulty: .easy)
        lobbyCellMedium.segue = GameScene.createGame(fileNamed: "medium.sks", difficulty: .medium)
        lobbyCellHard.segue = GameScene.createGame(fileNamed: "hard.sks", difficulty: .hard)
        
        lobbyCellEasy.position = CGPoint(x: 16, y: 400)
        lobbyCellMedium.position = CGPoint(x: 16, y: lobbyCellEasy.position.y - 52 - lobbyCellMedium.frame.height)
        lobbyCellHard.position = CGPoint(x: 16, y: lobbyCellMedium.position.y - 52 - lobbyCellHard.frame.height)
        
        addChild(lobbyCellEasy)
        addChild(lobbyCellMedium)
        addChild(lobbyCellHard)
    }
}

extension LobbyScene: ButtonDelegate {
    func buttonDidTap(_ button: Button) {
        if button == backButton {
            view?.presentScene(MainScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
        }
    }
}
