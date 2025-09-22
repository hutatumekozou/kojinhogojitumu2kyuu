import Foundation

enum QuizTopic: CaseIterable, Identifiable {
    case generalLegalSystem

    var id: String { fileName }

    var title: String {
        switch self {
        case .generalLegalSystem: return "総説・法体系／認定制度"
        }
    }

    var fileName: String {
        switch self {
        case .generalLegalSystem: return "general_legal_system"
        }
    }
}