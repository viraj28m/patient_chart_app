//
//  Medication.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/12/25.
//
import Foundation

// Class to represent a medication prescribed to a patient in the EMR
class Medication {
    let datePrescribed: Date
    let name: String
    var dose: String // format: x mg
    let route: String // i.e. "By mouth"
    var frequency: Int // number of times per day
    var duration: Int // number of days
    
    init(datePrescribed: Date, name: String, dose: String, route: String, frequency: Int, duration: Int) {
        self.datePrescribed = datePrescribed
        self.name = name
        self.dose = dose
        self.route = route
        self.frequency = frequency
        self.duration = duration
    }
    
    // Property for whether a medication is currently active or expired
    var isActive: Bool {
        let expiry = Calendar.current.date(byAdding: .day, value: duration, to: datePrescribed) ?? datePrescribed
        return Date() <= expiry
    }
}

enum MedicationError: Error, CustomStringConvertible {
    case duplicateMedication
    
    var description: String {
        switch self {
        case .duplicateMedication:
            return "Attempted to prescribe duplicate medication."
        }
    }
}
