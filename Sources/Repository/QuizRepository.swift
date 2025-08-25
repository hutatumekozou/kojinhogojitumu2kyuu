import Foundation

class QuizRepository: ObservableObject {
    static let shared = QuizRepository()
    
    private init() {}
    
    func loadQuestions(for topic: QuizTopic) -> [Question] {
        guard let url = Bundle.main.url(forResource: topic.fileName, withExtension: "json", subdirectory: "questions"),
              let data = try? Data(contentsOf: url),
              let questions = try? JSONDecoder().decode([Question].self, from: data) else {
            print("Failed to load questions for \(topic.fileName)")
            return []
        }
        
        // 2問のダミーデータを10問に拡張（重複補完）
        var expandedQuestions: [Question] = []
        for i in 0..<10 {
            let questionIndex = i % questions.count
            expandedQuestions.append(questions[questionIndex])
        }
        
        return expandedQuestions.shuffled()
    }
}