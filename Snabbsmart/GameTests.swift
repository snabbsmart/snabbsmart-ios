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
}
