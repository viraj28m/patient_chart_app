//
//  PrescribeMedicationView.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/17/25.
//

import SwiftUI

struct PrescribeMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var patient: Patient
    
    // State variables for form inputs
    @State private var name = ""
    @State private var dose = ""
    @State private var route = ""
    @State private var frequency = ""
    @State private var duration = ""
    @State private var errorMessage: String? = nil
    
    // Check if the form contains all required fields
    var isFormValid: Bool {
        !name.isEmpty && !dose.isEmpty && !route.isEmpty && !frequency.isEmpty && !duration.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Section for entering medication details
                Section(header: Text("Medication Details")) {
                    TextField("Name", text: $name).accessibilityIdentifier("medicationNameField")
                    TextField("Dose (mg)", text: $dose).accessibilityIdentifier("medicationDoseField")
                    TextField("Route (i.e. Oral)", text: $route).accessibilityIdentifier("medicationRouteField")
                    TextField("Frequency (per day)", text: $frequency)
                        .keyboardType(.numberPad).accessibilityIdentifier("medicationFrequencyField")
                    TextField("Duration (days)", text: $duration)
                        .keyboardType(.numberPad).accessibilityIdentifier("medicationDurationField")
                }
                // Error message for duplicate medication prescription
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red).accessibilityIdentifier("medicationError")
                }
            }
            .navigationTitle("Prescribe Medication")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()                    }
                    .accessibilityIdentifier("cancelMedicationButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let medication = Medication(
                            datePrescribed: Date(),
                            name: name,
                            dose: Int(dose) ?? 0,
                            route: route,
                            frequency: Int(frequency) ?? 0,
                            duration: Int(duration) ?? 0
                        )
                        do {
                            try patient.prescribeMedication(medication: medication)
                            dismiss()
                        } catch MedicationError.duplicateMedication {
                            errorMessage = "This medication is already prescribed."
                        } catch {
                            errorMessage = "An unexpected error occurred."
                        }
                    }
                    .disabled(!isFormValid) // Save button disabled if all required fields not filled
                    .accessibilityIdentifier("saveMedicationButton")
                }
            }
        }
    }
}

#Preview {
    PrescribeMedicationView(patient: createSamplePatient())
}

func createSamplePatient() -> Patient {
    let samplePatient = Patient(
        firstName: "John",
        lastName: "Doe",
        DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
        height: 180,
        weight: 170,
        bloodType: .A_Positive
    )
    
    try? samplePatient.prescribeMedication(
        medication: Medication(
            datePrescribed: Date(),
            name: "Ibuprofen",
            dose: 200,
            route: "Oral",
            frequency: 2,
            duration: 30
        )
    )
    
    return samplePatient
}
