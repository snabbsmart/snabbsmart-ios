import Foundation



class Game {
    let questionCount: Int
    let token: String

    init(questionCount: Int, token: String) {
        self.questionCount = questionCount
        self.token = token
    }

    func startQuestion(withData data: Data) -> Int {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return json["questionNumber"] as! Int
    }
}
