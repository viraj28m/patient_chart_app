//
//  BloodType.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/12/25.
//

// Representation for blood types
enum BloodType: String {
    case A_Positive = "A+"
    case A_Negative = "A-"
    case B_Positive = "B+"
    case B_Negative = "B-"
    case O_Positive = "O+"
    case O_Negative = "O-"
    case AB_Positive = "AB+"
    case AB_Negative = "AB-"
    
    func compatibleDonorBloodTypes() -> [BloodType] {
        switch self {
            case .A_Positive: return [.A_Positive, .A_Negative, .O_Positive, .O_Negative]
            case .A_Negative: return [.A_Negative, .O_Negative]
            case .B_Positive: return [.B_Positive, .B_Negative, .O_Positive, .O_Negative]
            case .B_Negative: return [.B_Negative, .O_Negative]
            case .O_Positive: return [.O_Positive, .O_Negative]
            case .O_Negative: return [.O_Negative]
            case .AB_Positive: return [.A_Positive, .A_Negative, .B_Positive, .B_Negative, .AB_Positive, .AB_Negative, .O_Positive, .O_Negative]
            case .AB_Negative: return [.AB_Negative, .A_Negative, .B_Negative, .O_Negative]
        }
    }
}
