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

class GameHandler {
    static let shared = GameHandler()

    func startQuestion(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
    }

    func questionAnswerable(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
    }

    func endQuestion(in game: Game, withData data: Data) -> Game {
        return handleEvent(in: game, withData: data)
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
