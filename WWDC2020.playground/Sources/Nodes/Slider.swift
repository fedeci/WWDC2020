import SpriteKit

class Slider: SKShapeNode {
    private var handle: SKShapeNode!
    private var percentage: Float = 0
    
    var width: CGFloat {
        get {
            return frame.width
        }
    }
    
    weak var delegate: SliderDelegate?
    
    init(size: CGSize, color: SKColor) {
        super.init()
        
        let path = CGPath(roundedRect: CGRect(origin: .zero, size: size), cornerWidth: size.height / 2, cornerHeight: size.height / 2, transform: nil)
        self.path = path
        fillColor = color
        strokeColor = .clear
        
        handle = SKShapeNode(circleOfRadius: (frame.height / 2) + 10)
        handle.fillColor = .white
        handle.strokeColor = .gray
        handle.position = CGPoint(x: 0, y: frame.height / 2)
        addChild(handle)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCompletion(at percentage: Float) {
        if percentage > 1 {
            self.percentage = 1
        } else if percentage < 0 {
            self.percentage = 0
        } else {
            self.percentage = percentage
        }
        handle.position = CGPoint(x: CGFloat(self.percentage) * width, y: frame.height / 2)
        delegate?.valueDidChange(in: self, to: self.percentage)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handle.fillColor = .lightGray
        if let touch = touches.first {
            let location = touch.location(in: self)
            let handlePosition = max(min(width, location.x), 0)
            handle!.position = CGPoint(x: handlePosition, y: frame.height / 2)
            percentage = Float(handlePosition / width)
            delegate?.valueDidChange(in: self, to: percentage)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handle.fillColor = .white
    }
}

protocol SliderDelegate: class {
    func valueDidChange(in slider: Slider, to value: Float)
}

