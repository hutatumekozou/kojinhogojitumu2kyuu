import Foundation

enum QuizTopic: CaseIterable, Identifiable {
    case generalLegalSystem
    case privacyLawUnderstanding
    case personalDataObligations
    case personalDataDuties
    case personalRelatedInformation
    case threatAndCountermeasures
    case organizationalHumanSecurity
    case officePhysicalSecurity

    var id: String { fileName }

    var title: String {
        switch self {
        case .generalLegalSystem: return "総説・法体系／認定制度"
        case .privacyLawUnderstanding: return "個人情報保護法の理解"
        case .personalDataObligations: return "個人情報に関する義務"
        case .personalDataDuties: return "個人データの義務"
        case .personalRelatedInformation: return "個人関連情報（第三者提供の制限 等）"
        case .threatAndCountermeasures: return "脅威と対策（対策基準、ガイドライン理解）"
        case .organizationalHumanSecurity: return "組織的・人的セキュリティ（基本方針、リスク分析、教育、事故対応 など）"
        case .officePhysicalSecurity: return "オフィス（物理的）セキュリティ（入退室管理、設備管理、災害対策 など）"
        }
    }

    var fileName: String {
        switch self {
        case .generalLegalSystem: return "general_legal_system"
        case .privacyLawUnderstanding: return "privacy_law_understanding"
        case .personalDataObligations: return "personal_data_obligations"
        case .personalDataDuties: return "personal_data_duties"
        case .personalRelatedInformation: return "personal_related_information"
        case .threatAndCountermeasures: return "threat_and_countermeasures"
        case .organizationalHumanSecurity: return "organizational_human_security"
        case .officePhysicalSecurity: return "office_physical_security"
        }
    }
}