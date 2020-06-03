import SpriteKit

class Button: SKSpriteNode {
    weak var delegate: ButtonDelegate?
    
    init(size: CGSize, imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: size)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.buttonDidTap(self)
    }
}

protocol ButtonDelegate: class {
    func buttonDidTap(_ button: Button)
}
