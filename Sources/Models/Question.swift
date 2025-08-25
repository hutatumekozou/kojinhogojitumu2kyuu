import Foundation

struct Question: Codable, Identifiable {
    let id = UUID()
    let text: String
    let choices: [String]
    let correct: Int
    let explanation: String
    
    enum CodingKeys: String, CodingKey {
        case text, choices, correct, explanation
    }
}