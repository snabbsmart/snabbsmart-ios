import Foundation

struct Player {
    var streak: Int = 0
    var gamePosition: Int = 0
    var questionPosition: Int = 0
    var gameScore: Int = 0
    var questionScore:Int = 0
}

struct Game {
    var questionCount: Int = 0
    var currentPlayer: Player = Player()
    var currentQuestionNumber: Int = 1
}

protocol ActionCableChannel {
    var onReceive: ((_ json : Any?, _ error : Error?) -> Void)? { get set }
    func action(_ action: String, _ messsage: [String: Any])
}

class GameHandler {
    static let shared = GameHandler()

    var actionCableChannel: ActionCableChannel?

    var onStartQuestion: ((Game) -> Void)?

    func startChannelObserver(forGame game: Game) {
        actionCableChannel?.onReceive = { json, error in
            let jsonDict = json as! [String: Any]
            let data = try! JSONSerialization.data(withJSONObject: jsonDict["data"] as! [String: Any], options: [])
            let game = self.startQuestion(in: game, withData: data)
            self.onStartQuestion?(game)
        }
    }

    func startQuestion(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
    }

    func questionAnswerable(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
    }

    func endQuestion(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
    }

    func answerQuestion(in game: Game, withData data: Data) -> Game {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        actionCableChannel?.action("answerQuestion", json)
        return game
    }

    fileprivate func handleEvent(in game: Game, withData data: Data) -> Game {
        var game = game
        parseDataToGame(data: data, game: &game)
        return game
    }

    fileprivate func parseDataToGame(data: Data, game: inout Game) {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

        if let questionNumber = json["questionNumber"] as? Int {
            game.currentQuestionNumber = questionNumber
        }

        if let streak = json["myStreak"] as? Int {
            game.currentPlayer.streak = streak
        }

        if let gamePosition = json["myGamePosition"] as? Int {
            game.currentPlayer.gamePosition = gamePosition
        }

        if let questionPosition = json["myQuestionPosition"] as? Int {
            game.currentPlayer.questionPosition = questionPosition
        }

        if let gameScore = json["myGameScore"] as? Int {
            game.currentPlayer.gameScore = gameScore
        }

        if let questionScore = json["myQuestionScore"] as? Int {
            game.currentPlayer.questionScore = questionScore
        }
    }
}
