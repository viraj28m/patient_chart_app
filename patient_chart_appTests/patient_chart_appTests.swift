//
//  patient_chart_appTests.swift
//  patient_chart_appTests
//
//  Created by Viraj Mehta on 1/12/25.
//

import XCTest
@testable import patient_chart_app

final class patient_chart_appTests: XCTestCase {
    
    // Test proper patient initialization and patientNameandAge function calling
    func testPatientInitialization() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        XCTAssertEqual(patient.patientNameandAge(), "Doe, John (20)")
    }
    
    // Test that a medication is properly prescribed and that attempting to prescribe a duplicate medication throws an error
    func testMedicationPrescription() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        let medication = Medication(datePrescribed: Date(), name: "Losartan", dose: "12.5 mg", route: "By mouth", frequency: 1, duration: 90)
        
        try patient.prescribeMedication(medication: medication)
        XCTAssertEqual(patient.getActiveMedications().count, 1)
        
        // Create duplicate medication
        let newMedication = Medication(datePrescribed: Date(), name: "Losartan", dose: "12.5 mg", route: "By mouth", frequency: 1, duration: 90)
        XCTAssertThrowsError(try patient.prescribeMedication(medication: newMedication)) { error in
            XCTAssertEqual(error as? MedicationError, MedicationError.duplicateMedication)
        }
    }
    
    // Test that a function call to getActiveMedications() correctly only returns active medications in the correct order
    func testActiveMedications() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150)
        
        let expiredMed = Medication(datePrescribed: Calendar.current.date(byAdding: .day, value: -100, to: Date())!, name: "Metoprolol", dose: "25 mg", route: "By mouth", frequency: 1, duration: 90)
        
        let activeMed = Medication(datePrescribed: Date(), name: "Aspirin", dose: "81 mg", route: "By mouth", frequency: 1, duration: 90)
        
        let otherActiveMed = Medication(datePrescribed: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), name: "Losartan", dose: "12.5 mg", route: "By mouth", frequency: 1, duration: 90)
        
        try patient.prescribeMedication(medication: expiredMed)
        try patient.prescribeMedication(medication: activeMed)
        try patient.prescribeMedication(medication: otherActiveMed)
        
        let activeMeds = patient.getActiveMedications()
        XCTAssertEqual(activeMeds.count, 2)
        XCTAssertEqual(activeMeds[0].name, "Aspirin")
        XCTAssertEqual(activeMeds[1].name, "Losartan")
    }

    // Check that a list of compatible blood types for a patient's blood type is correctly returned
    func testBloodTypeCompatibility() throws {
        let patient = Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -20, to: Date())!, height: 180, weight: 150, bloodType: .O_Positive)
        let compatibleDonorTypes = patient.getCompatibleDonorBloodTypes()
        XCTAssertEqual(compatibleDonorTypes, [.O_Positive, .O_Negative])
    }
}
