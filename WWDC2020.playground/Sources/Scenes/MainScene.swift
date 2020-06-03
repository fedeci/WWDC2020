import SpriteKit

final public class MainScene: SKScene {
    private var marco: SKSpriteNode!
    private var playButton: Button!
    private var settingsButton: Button!
    private var title: SKSpriteNode!
    
    private var treeSX: SKSpriteNode!
    private var treeC: SKSpriteNode!
    private var treeDX: SKSpriteNode!
    private var ground: SKSpriteNode!
    
    public override init(size: CGSize) {
        super.init(size: size)
        
        settingsButton = Button(size: CGSize(width: 60, height: 60), imageNamed: "settings")
        playButton = Button(size: CGSize(width: 128, height: 60), imageNamed: "play")
        marco = SKSpriteNode(imageNamed: "marco")
        initTreesAndGround()
    }
    
    private func initTreesAndGround() {
        treeSX = !GameManager.gamesCompleted[0] ? SKSpriteNode(imageNamed: "treeSX") : SKSpriteNode(imageNamed: "treeSXLeaves")
        treeC = !GameManager.gamesCompleted[1] ? SKSpriteNode(imageNamed: "treeC") : SKSpriteNode(imageNamed: "treeCLeaves")
        treeDX = !GameManager.gamesCompleted[2] ? SKSpriteNode(imageNamed: "treeDX") : SKSpriteNode(imageNamed: "treeDXLeaves")
        ground = GameManager.gamesCompleted.filter({ $0 == true }).count != 3 ? SKSpriteNode(imageNamed: "ground") : SKSpriteNode(imageNamed: "groundGreen")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = .white
        playMusic()
        
        setupButtons()
        setupTreesAndGround()
        setupMarco()
    }
    
    func playMusic() {
        if let playing = AudioManager.shared.playing, playing == .main {
            return
        }
        AudioManager.shared.playBackgroundMusic(type: .main)
    }
    
    private func setupButtons() {
        settingsButton.delegate = self
        settingsButton.position = CGPoint(x: 16, y: view!.frame.height - 16 - settingsButton.size.height)
        addChild(settingsButton)
        
        playButton.delegate = self
        playButton.position = CGPoint(x: view!.frame.width - 16 - playButton.size.width, y: view!.frame.height - 16 - playButton.size.height)
        addChild(playButton)
    }
    
    private func setupTreesAndGround() {
        treeSX.setScale(0.7)
        treeC.setScale(0.7)
        treeDX.setScale(0.7)
        treeSX.position = CGPoint(x: 100, y: 230)
        treeC.position = CGPoint(x: 250, y: 315)
        treeDX.position = CGPoint(x: 430, y: 285)
        addChild(treeSX)
        addChild(treeC)
        addChild(treeDX)
        
        ground.anchorPoint = CGPoint(x: 0, y: 0)
        ground.position = CGPoint(x: 0, y: 0)
        ground.zPosition = -1
        addChild(ground)
    }
    
    private func setupMarco() {
        marco.zPosition = 5
        marco.setScale(0.55)
        marco.anchorPoint = CGPoint(x: 1, y: 0)
        marco.position = CGPoint(x: view!.frame.width + 20, y: -5)
        addChild(marco)
    }
}

extension MainScene: ButtonDelegate {
    func buttonDidTap(_ button: Button) {
        if button == settingsButton {
            view?.presentScene(SettingsScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
        } else if button == playButton {
            view?.presentScene(LobbyScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
        }
    }
}
