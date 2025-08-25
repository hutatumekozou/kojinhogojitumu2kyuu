import Foundation

enum QuizTopic: CaseIterable, Identifiable {
    case coordinator1, coordinator2
    case health1, health2
    case counseling1, counseling2
    case environment1, environment2
    case welfare1, welfare2

    var id: String { fileName }

    var title: String {
        switch self {
        case .coordinator1:   return "福祉住環境コーディネーターの役割 1"
        case .coordinator2:   return "福祉住環境コーディネーターの役割 2"
        case .health1:        return "疾患・障害別住環境整備 1"
        case .health2:        return "疾患・障害別住環境整備 2"
        case .counseling1:    return "相談援助技術 1"
        case .counseling2:    return "相談援助技術 2"
        case .environment1:   return "住環境整備の技術 1"
        case .environment2:   return "住環境整備の技術 2"
        case .welfare1:       return "福祉用具の活用 1"
        case .welfare2:       return "福祉用具の活用 2"
        }
    }

    var fileName: String {
        switch self {
        case .coordinator1:   return "coordinator_1"
        case .coordinator2:   return "coordinator_2"
        case .health1:        return "health_1"
        case .health2:        return "health_2"
        case .counseling1:    return "counseling_1"
        case .counseling2:    return "counseling_2"
        case .environment1:   return "environment_1"
        case .environment2:   return "environment_2"
        case .welfare1:       return "welfare_1"
        case .welfare2:       return "welfare_2"
        }
    }
}