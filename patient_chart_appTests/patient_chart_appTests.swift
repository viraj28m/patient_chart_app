//
//  patient_chart_appTests.swift
//  patient_chart_appTests
//
//  Created by Viraj Mehta on 1/12/25.
//

import Testing
import Foundation
@testable import patient_chart_app
    
struct backendTests {
    // Test proper patient initialization and patientNameandAge function calling
    @Test("Patient Initialization") func testPatientInitialization() {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        #expect(patient.patientNameandAge() == "Doe, John (20)")
    }
    
    // Test that a medication is properly prescribed and that attempting to prescribe a duplicate medication throws an error
    @Test("Medication Prescription") func testMedicationPrescription() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        let medication = Medication(datePrescribed: Date(), name: "Losartan", dose: 15, route: "Oral", frequency: 1, duration: 90)
        
        try patient.prescribeMedication(medication: medication)
        #expect(patient.getActiveMedications().count == 1)
        
        // Create duplicate medication
        let newMedication = Medication(datePrescribed: Date(), name: "Losartan", dose: 15, route: "Oral", frequency: 1, duration: 90)
        #expect(throws: MedicationError.duplicateMedication) {
            try patient.prescribeMedication(medication: newMedication)
        }
    }
    
    // Test that a function call to getActiveMedications() correctly only returns active medications in the correct order
    @Test("Active Medications") func testActiveMedications() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        
        let expiredMed = Medication(datePrescribed: Calendar.current.date(byAdding: .day, value: -100, to: Date())!, name: "Metoprolol", dose: 25, route: "Oral", frequency: 1, duration: 90)
        
        let activeMed = Medication(datePrescribed: Date(), name: "Aspirin", dose: 80, route: "Oral", frequency: 1, duration: 90)
        
        let otherActiveMed = Medication(datePrescribed: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), name: "Losartan", dose: 25, route: "Oral", frequency: 1, duration: 90)
        
        try patient.prescribeMedication(medication: expiredMed)
        try patient.prescribeMedication(medication: activeMed)
        try patient.prescribeMedication(medication: otherActiveMed)
        
        let activeMeds = patient.getActiveMedications()
        #expect(activeMeds.count == 2)
        #expect(activeMeds[0].name == "Aspirin")
        #expect(activeMeds[1].name == "Losartan")
    }
    
    // Check that a list of compatible blood types for a patient's blood type is correctly returned
    @Test("Blood Type Compatibility") func testBloodTypeCompatibility() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150, bloodType: .O_Positive)
        let compatibleDonorTypes = patient.getCompatibleDonorBloodTypes()
        #expect(compatibleDonorTypes == [.O_Positive, .O_Negative])
    }
}
