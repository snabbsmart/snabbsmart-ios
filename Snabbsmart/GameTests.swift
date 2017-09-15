import XCTest
@testable import Snabbsmart
class GameTests: XCTestCase {
    var gameHandler: GameHandler!
    var game: Game!

    func testExample() {
    }

    override func setUp() {
        super.setUp()
        game = Game()
        gameHandler = GameHandler.shared
    }
    func testStartQuestionWithDataWillReturnCurrentQuestionNumber() {
        let json: [String: Any] = [
            "questionNumber": 17
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        game = gameHandler.startQuestion(in: game, withData: data)

        XCTAssertEqual(17, game.currentQuestionNumber)
    }

    func testQuestionAnswerableWithDataWillReturnCurrentQuestionNumber() {
        let json: [String: Any] = [
            "questionNumber": 17
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        game = gameHandler.questionAnswerable(in: game, withData: data)

        XCTAssertEqual(17, game.currentQuestionNumber)
    }

    func testEndQuestionWithDataWillReturnQuestionResult() {
        let json: [String: Any] = [
            "questionNumber": 17,
            "myStreak": 2,
            "myGamePosition": 1,
            "myQuestionPosition": 2,
            "myGameScore": 2094,
            "myQuestionScore": 710
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        game = gameHandler.endQuestion(in: game, withData: data)

        XCTAssertEqual(17, game.currentQuestionNumber)
        XCTAssertEqual(2, game.currentPlayer.streak)
        XCTAssertEqual(1, game.currentPlayer.gamePosition)
        XCTAssertEqual(2, game.currentPlayer.questionPosition)
        XCTAssertEqual(2094, game.currentPlayer.gameScore)
        XCTAssertEqual(710, game.currentPlayer.questionScore)
    }
}
