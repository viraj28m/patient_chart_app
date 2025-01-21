//
//  NewPatientFormView.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/17/25.
//

import SwiftUI

struct NewPatientFormView: View {
    @Environment(\.dismiss) var dismiss
    var patientData: PatientData
    
    // State variables for form inputs
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var DOB = Date()
    @State private var height = ""
    @State private var weight = ""
    @State private var bloodType: BloodType? = nil
    @State private var errorMessage: String? = nil
    
    // Check if the form contains all required fields
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && DOB < Date() && !height.isEmpty && !weight.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Section for entering patient details
                Section(header: Text("Required Patient Details")) {
                    TextField("First Name", text: $firstName).accessibilityIdentifier("firstNameField")
                    TextField("Last Name", text: $lastName).accessibilityIdentifier("lastNameField")
                    DatePicker("Date of Birth", selection: $DOB, displayedComponents: .date).accessibilityIdentifier("dobPicker")
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad).accessibilityIdentifier("heightField")
                    TextField("Weight (lbs)", text: $weight)
                        .keyboardType(.decimalPad).accessibilityIdentifier("weightField")
                }
                
                Section(header: Text("Optional Patient Information")) {
                    Picker("Blood Type", selection: $bloodType) {
                        Text("None").tag(nil as BloodType?)
                        ForEach(BloodType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type as BloodType?)
                        }
                    }
                    .accessibilityIdentifier("bloodTypePicker")
                }
                // Error message if height and weight are not numeric
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red).accessibilityIdentifier("error_invalidInput")
                }
            }
            .navigationTitle("New Patient")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancelButton")
                }
                // Save button to error check and add new patient
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if Double(height) == nil || Double(weight) == nil {
                            errorMessage = "Height and weight must be numeric."
                            return
                        }
                        let newPatient = Patient(
                            firstName: firstName,
                            lastName: lastName,
                            DOB: DOB,
                            height: Double(height) ?? 0,
                            weight: Double(weight) ?? 0,
                            bloodType: bloodType
                        )
                        patientData.addPatient(newPatient)
                        dismiss()
                    }
                    .disabled(!isFormValid) // Save button disabled if all required fields not filled
                    .accessibilityIdentifier("saveButton")
                }
            }
        }
    }
}

#Preview {
    NewPatientFormView(patientData: {
        let previewPatientData = PatientData()
        previewPatientData.addPatient(Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!, height: 180, weight: 170, bloodType: .A_Positive))
        previewPatientData.addPatient(Patient(firstName: "Jane", lastName: "Smith", DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!, height: 165, weight: 130, bloodType: .B_Negative))
        previewPatientData.addPatient(Patient(firstName: "Gordon", lastName: "Wood", DOB: Calendar.current.date(byAdding: .year, value: -45, to: Date())!, height: 170, weight: 150, bloodType: .O_Positive))
        return previewPatientData
    }())
}
