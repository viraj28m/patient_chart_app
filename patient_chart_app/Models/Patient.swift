//
//  Patient.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/12/25.
//
import Foundation

// Class to represent a patient in the EMR
@Observable class Patient: Identifiable {
    let MRN: UUID
    var id: UUID {MRN}
    let firstName: String
    let lastName: String
    let DOB: Date
    var height: Double // cm
    var weight: Double // lbs
    var bloodType: BloodType?
    var medications: [Medication] = []
    
    init(firstName: String, lastName: String, DOB: Date, height: Double, weight: Double, bloodType: BloodType? = nil) {
            self.MRN = UUID()
            self.firstName = firstName
            self.lastName = lastName
            self.DOB = DOB
            self.height = height
            self.weight = weight
            self.bloodType = bloodType
    }
    
    func patientNameandAge() -> String {
        let age = Calendar.current.dateComponents([.year], from: DOB, to: Date()).year ?? 0
        return "\(lastName), \(firstName) (\(age))"
    }
    
    // Function to get a list of all active medications for the patient
    func getActiveMedications() -> [Medication] {
        let activeMeds = medications.filter{medication in medication.isActive}
        return activeMeds.sorted{firstMed, secondMed in firstMed.datePrescribed > secondMed.datePrescribed
        }
    }
    
    // Function to prescribe a new medication to the patient
    func prescribeMedication(medication: Medication) throws {
        // Check if medicaiton is a duplicate by comparing medication names only
        let alreadyTaking = medications.contains{existingMedication in existingMedication.name.lowercased() == medication.name.lowercased() && existingMedication.isActive
        }
        
        if alreadyTaking {
            throw MedicationError.duplicateMedication
        }

        medications.append(medication)
    }
    
    func getCompatibleDonorBloodTypes() -> [BloodType]? {
        return bloodType?.compatibleDonorBloodTypes()
    }
}
