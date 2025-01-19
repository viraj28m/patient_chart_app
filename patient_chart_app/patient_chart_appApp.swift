//
//  patient_chart_appApp.swift
//  patient_chart_app
//
//  Created by Viraj Mehta on 1/12/25.
//

import SwiftUI

@main
struct patient_chart_appApp: App {
    var body: some Scene {
        WindowGroup {
            PatientListView(patientData: PatientData())
        }
    }
}
