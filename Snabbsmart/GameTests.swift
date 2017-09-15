import XCTest
@testable import Snabbsmart
class GameTests: XCTestCase {
    
    func testExample() {

    }


    func testInitilizationWithQuestionCountAndToken() {
        let game = Game(questionCount: 3, token: "123asd")

        XCTAssertEqual(3, game.questionCount)
        XCTAssertEqual("123asd", game.token)
    }

    func testStartQuestionWithDataWillReturnCurrentQuestionNumber() {
        let game = Game(questionCount: 3, token: "123asd")

        let json: [String: Any] = [
            "questionNumber": 17
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        let questionNumber = game.startQuestion(withData: data)

        XCTAssertEqual(17, questionNumber)
    }
}
