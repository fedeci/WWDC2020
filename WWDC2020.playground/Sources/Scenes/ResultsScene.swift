import SpriteKit

final class ResultsScene: SKScene {
    private var didWin: Bool!
    private var label: SKLabelNode!
    private var continueButton: Button!
    
    private var emitterLayer: CAEmitterLayer?
    
    init(size: CGSize, didWin: Bool) {
        super.init(size: size)
        
        self.didWin = didWin
        label = SKLabelNode(fontNamed: .fontMedium)
        continueButton = Button(size: CGSize(width: 190, height: 60), imageNamed: "continue")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = .white
        setupLabel()
        setupButton()
        if didWin {
            setupConfetti()
        }
    }
    
    private func setupLabel() {
        label.text = didWin ? "Well done, you completed the level!😉" : "I'm sorry you lost, try again!😧"
        label.fontColor = .gray
        label.position = CGPoint(x: size.width / 2, y: 400)
        addChild(label)
    }
    
    private func setupButton() {
        continueButton.delegate = self
        continueButton.position = CGPoint(x: size.width - 16 - continueButton.frame.width, y: 16)
        addChild(continueButton)
    }
    
    private func setupConfetti() {
        let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemBlue, .systemPurple]
        emitterLayer = CAEmitterLayer()
        emitterLayer?.emitterSize = CGSize(width: frame.size.width, height: 1)
        emitterLayer!.position = CGPoint(x: frame.size.width / 2, y: 0)
        emitterLayer!.emitterShape = .line
        var emitterCells = [CAEmitterCell]()
        for color in colors {
            let cell = CAEmitterCell()
            cell.contents = UIImage(named: "confetti")?.cgImage
            cell.color = color.cgColor
            cell.birthRate = 3
            cell.lifetime = 12
            cell.velocity = 220
            cell.velocityRange = 40
            cell.xAcceleration = 10
            cell.yAcceleration = 70
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi
            cell.spin = 4
            cell.spinRange = 2
            cell.scale = 0.4
            emitterCells.append(cell)
        }
        
        emitterLayer!.emitterCells = emitterCells
        view?.layer.addSublayer(emitterLayer!)
    }
}

extension ResultsScene: ButtonDelegate {
    func buttonDidTap(_ button: Button) {
        emitterLayer?.removeFromSuperlayer()
        view?.presentScene(MainScene(size: size), transition: SKTransition.fade(withDuration: 0.6))
    }
}
