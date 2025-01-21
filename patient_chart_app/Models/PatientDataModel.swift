//
//  PatientDataModel.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/16/25.
//

import Foundation
import SwiftUI

@Observable class PatientData {
    var patients: [Patient] = []
    var searchQuery: String = ""
    
    var filteredPatients: [Patient] {
        if searchQuery.isEmpty {
            return patients.sorted { $0.lastName < $1.lastName }
        } else {
            return patients.filter { $0.lastName.lowercased().contains(searchQuery.lowercased()) }.sorted { $0.lastName < $1.lastName }
        }
    }
    
    func addPatient(_ patient: Patient) {
        patients.append(patient)
    }
}
