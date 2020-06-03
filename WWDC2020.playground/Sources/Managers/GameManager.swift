import Foundation

struct GameManager {
    
    var lives = 3
    var trashRecycled = 0
    var playerHasTrash = false
    
    static var gamesCompleted: [Bool] = [false, false, false]
    
    enum Difficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var gameValue: Int {
            switch self {
            case .easy:
                return 0
            case .medium:
                return 1
            case .hard:
                return 2
            }
        }
    }
}
