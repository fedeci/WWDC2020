import SpriteKit

final class Joystick: SKNode {
    private var background: SKShapeNode!
    private var handle: SKShapeNode!
    private(set) var radius: CGFloat = 50
    
    weak var delegate: JoystickDelegate?
    
    init(radius: CGFloat) {
        super.init()
        self.radius = radius
        background = SKShapeNode(circleOfRadius: self.radius)
        background.strokeColor = .white
        
        handle = SKShapeNode(circleOfRadius: self.radius / 3)
        handle.fillColor = .white
        
        addChild(background)
        addChild(handle)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handle.fillColor = .gray
        if let touch = touches.first {
            let location = touch.location(in: self)
            let handleDistance = sqrt(pow(location.x, 2) + pow(location.y, 2))
            let alpha = atan2(location.y, location.x)

            if handleDistance > radius {
                let handleX = (radius * location.x) / handleDistance
                let handleY = (radius * location.y) / handleDistance
                handle.position = CGPoint(x: handleX, y: handleY)
            } else {
                handle.position = CGPoint(x: location.x, y: location.y)
            }
            
            // Polar coordinates with max distance equal to 1
            let distance = round((sqrt(pow(handle.position.x, 2) + pow(handle.position.y, 2)) / radius ) * 100) / 100
            delegate?.positionChanged(self, distance: distance, alpha: alpha)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handle.fillColor = .white
        handle.position = CGPoint(x: 0, y: 0)
        delegate?.positionChanged(self, distance: 0, alpha: 0)
    }
}

protocol JoystickDelegate: class {
    func positionChanged(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat)
}
