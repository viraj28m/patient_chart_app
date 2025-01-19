//
//  PatientListView.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/16/25.
//

import SwiftUI

struct PatientListView: View {
    @StateObject var patientData = PatientData()
    @State private var showingNewPatientForm = false
    
    var body : some View {
        NavigationStack {
            List(patientData.filteredPatients) { patient in
                // Navigates to PatientDetailView when a patient is clicked
                NavigationLink(destination: PatientDetailView(patient: patient, patientData: patientData)) {
                    VStack(alignment: .leading) {
                        Text(patient.patientNameandAge())
                            .font(.headline)
                            .accessibilityIdentifier("patientName_\(patient.lastName)_\(patient.firstName)")
                        Text("MRN: \(patient.MRN.uuidString.prefix(8))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Patients")
            .toolbar {
                // Button to add new patient
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewPatientForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addPatientButton")
                }
            }
            // Search bar for filtering patients by last name
            .searchable(text: $patientData.searchQuery, prompt: "Search by last name")
            .textFieldStyle(.roundedBorder)
            .accessibilityIdentifier("searchBar")
            .sheet(isPresented: $showingNewPatientForm) {
                NewPatientFormView(patientData: patientData)
            }
        }
    }
}

#Preview {
    PatientListView(patientData: {
        let previewPatientData = PatientData()
        previewPatientData.addPatient(Patient(firstName: "John", lastName: "Doe", DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!, height: 180, weight: 170, bloodType: .A_Positive))
        previewPatientData.addPatient(Patient(firstName: "Jane", lastName: "Smith", DOB: Calendar.current.date(byAdding: .year, value: -25, to: Date())!, height: 165, weight: 130, bloodType: .B_Negative))
        previewPatientData.addPatient(Patient(firstName: "Gordon", lastName: "Wood", DOB: Calendar.current.date(byAdding: .year, value: -45, to: Date())!, height: 170, weight: 150, bloodType: .O_Positive))
        return previewPatientData
    }())
}
