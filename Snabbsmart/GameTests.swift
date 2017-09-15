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

    class MockActionCableChannel: ActionCableChannel {
        var actionNameCalled = ""
        var actionMessageSent: [String: Any]? = nil

        func action(_ action: String, _ messsage: [String : Any]) {
            self.actionNameCalled = action
            self.actionMessageSent = messsage
        }

        var onReceive: ((Any?, Error?) -> Void)?
    }

    func testAnswerQuestion() {
        let channel = MockActionCableChannel()
        gameHandler.actionCableChannel = channel

        let json = [
            "answerNumber": 3
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])

        _ = gameHandler.answerQuestion(in: game, withData: data)

        XCTAssertEqual("answerQuestion", channel.actionNameCalled)
        XCTAssertEqual(3, channel.actionMessageSent!["answerNumber"] as! Int)

    }

    func testStartChannelObserver_whenStartQuestion_willUpdateCurrentQuestionNumber() {
        let channel = MockActionCableChannel()
        gameHandler.actionCableChannel = channel
        gameHandler.startChannelObserver(forGame: game!)
        let json: [String : Any] = [
            "eventname": "startQuestion",
            "data": [
                "questionNumber": 8
            ]
        ]
        var currentQuestionNumber = 0
        gameHandler.onStartQuestion = { game in
            currentQuestionNumber = game.currentQuestionNumber
        }
        channel.onReceive!(json, nil)

        XCTAssertEqual(8, currentQuestionNumber)
    }
}
