import SpriteKit

final class SettingsScene: SKScene {
    private var backButton: Button!
    private var volumeSlider: Slider!
    private var titleLabel: SKLabelNode!
    private var volumeLabel: SKLabelNode!
    private var volumePercentageLabel: SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        volumeSlider = Slider(size: CGSize(width: scene!.frame.width - 32, height: 15), color: .main)
        backButton = Button(size: CGSize(width: 60, height: 60), imageNamed: "back")
        titleLabel = SKLabelNode(fontNamed: .fontMedium)
        volumeLabel = SKLabelNode(fontNamed: .fontMedium)
        volumePercentageLabel = SKLabelNode(fontNamed: .fontMedium)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupSlider()
        setupBackButton()
        setupLabels()
        
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    private func setupSlider() {
        volumeSlider.delegate = self
        volumeSlider.position = CGPoint(x: 16, y: 380)
        volumeSlider.setCompletion(at: AudioManager.shared.volume)
        addChild(volumeSlider)
    }
    
    private func setupBackButton() {
        backButton.delegate = self
        backButton.position = CGPoint(x: 16, y: view!.frame.height - 16 - backButton.size.height)
        addChild(backButton)
    }
    
    private func setupLabels() {
        titleLabel.text = "Settings"
        titleLabel.fontColor = .gray
        titleLabel.verticalAlignmentMode = .center
        titleLabel.horizontalAlignmentMode = .right
        titleLabel.position = CGPoint(x: view!.frame.width - 16, y: backButton.position.y + backButton.size.height / 2)
        addChild(titleLabel)
        
        volumeLabel.text = "Music volume"
        volumeLabel.fontColor = .gray
        volumeLabel.fontSize = 18
        volumeLabel.horizontalAlignmentMode = .left
        volumeLabel.position = CGPoint(x: 16, y: volumeSlider.position.y + 32)
        addChild(volumeLabel)
        
        volumePercentageLabel.fontColor = .gray
        volumePercentageLabel.fontSize = 18
        volumePercentageLabel.horizontalAlignmentMode = .right
        volumePercentageLabel.position = CGPoint(x: view!.frame.width - 16, y: volumeSlider.position.y + 32)
        addChild(volumePercentageLabel)
    }
}

extension SettingsScene: ButtonDelegate {
    func buttonDidTap(_ button: Button) {
        view?.presentScene(MainScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
    }
}

extension SettingsScene: SliderDelegate {
    func valueDidChange(in slider: Slider, to value: Float) {
        AudioManager.shared.setVolume(to: value)
        volumePercentageLabel.text = "\(Int(round(value * 100)))%"
    }
}
