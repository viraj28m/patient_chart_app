//
//  PatientDetailView.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/16/25.
//

import SwiftUI

struct PatientDetailView: View {
    var patient: Patient
    var patientData: PatientData
    @State private var showingMedicationForm = false // Determines whether the PrescribeMedicationView is showing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section for displaying patient information
            Group {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(patient.patientNameandAge())")
                        .font(.title2)
                        .bold()
                    Divider()
                    Text("MRN: \(patient.MRN.uuidString)")
                        .font(.body)
                    Divider()
                    Text(String(format: "Height: %.1f cm", patient.height))
                        .font(.body)
                    Divider()
                    Text(String(format: "Weight: %.1f lbs", patient.weight))
                        .font(.body)
                    Divider()
                }
            }
            
            if let bloodType = patient.bloodType {
                Text("Blood Type: \(bloodType.rawValue)")
                    .font(.body)
            }
            
            Divider()
            
            // Section for displaying medication information
            Text("Medications")
                .font(.headline)
            List(patient.medications, id: \.id) { medication in
                VStack(alignment: .leading) {
                    Text(medication.name)
                        .font(.headline).accessibilityIdentifier("medication_\(medication.name)")
                    Text("Dose: \(medication.dose)")
                    Text("Route: \(medication.route)")
                    Text("Frequency (per day): \(medication.frequency)")
                    Text("Duration (days): \(medication.duration)")
                }
            }
            // Button to prescribe new medication
            Button("Prescribe Medication") {
                showingMedicationForm = true
            }
            .sheet(isPresented: $showingMedicationForm) {
                PrescribeMedicationView(patient: patient)
            }
            .accessibilityIdentifier("prescribeMedicationButton")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Patient Details")
    }
}

#Preview {
    let samplePatient = Patient(
        firstName: "Jane",
        lastName: "Smith",
        DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
        height: 165,
        weight: 130,
        bloodType: .O_Positive
    )
    samplePatient.medications.append(
        Medication(
            datePrescribed: Date(),
            name: "Acetaminophen",
            dose: 500,
            route: "Oral",
            frequency: 2,
            duration: 30
        )
    )
    
    let samplePatientData = PatientData()
    samplePatientData.addPatient(samplePatient)
    
    return PatientDetailView(patient: samplePatient, patientData: samplePatientData)
}

