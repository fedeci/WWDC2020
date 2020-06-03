/*
 Every image found in this playground is made by me, Federico Ciardi and is Copyright Free.
 The two sound tracks included are instead open source.
*/
import SpriteKit
import PlaygroundSupport

let view = SKView(frame: CGRect(origin: .zero, size: CGSize(width: 600, height: 600)))

let scene = MainScene(size: CGSize(width: 600, height: 600))
scene.scaleMode = .aspectFit
view.presentScene(scene)

PlaygroundPage.current.liveView = view
