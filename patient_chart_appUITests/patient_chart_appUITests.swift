//
//  patient_chart_appUITests.swift
//  patient_chart_appUITests
//
//  Created by Viraj Mehta on 1/12/25.
//

import XCTest

final class patient_chart_appUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func addPatient(firstName: String, lastName: String, height: String, weight: String) {
        let app = XCUIApplication()
        app.buttons["addPatientButton"].tap()
        app.textFields["firstNameField"].tap()
        app.textFields["firstNameField"].typeText(firstName)
        app.textFields["lastNameField"].tap()
        app.textFields["lastNameField"].typeText(lastName)
        app.textFields["heightField"].tap()
        app.textFields["heightField"].typeText(height)
        app.textFields["weightField"].tap()
        app.textFields["weightField"].typeText(weight)
        app.buttons["saveButton"].tap()
    }
    
    @MainActor
    func addMedication(medicationName: String, medicationDose: Int, medicationRoute: String, medicationFrequency: Int, medicationDuration: Int) {
        let app = XCUIApplication()
        app.buttons["prescribeMedicationButton"].tap()
        app.textFields["medicationNameField"].tap()
        app.textFields["medicationNameField"].typeText(medicationName)
        app.textFields["medicationDoseField"].tap()
        app.textFields["medicationDoseField"].typeText(String(medicationDose))
        app.textFields["medicationRouteField"].tap()
        app.textFields["medicationRouteField"].typeText(medicationRoute)
        app.textFields["medicationFrequencyField"].tap()
        app.textFields["medicationFrequencyField"].typeText(String(medicationFrequency))
        app.textFields["medicationDurationField"].tap()
        app.textFields["medicationDurationField"].typeText(String(medicationDuration))
        app.buttons["saveMedicationButton"].tap()
    }

    @MainActor
    func testAddNewPatient() throws {
        let app = XCUIApplication()
        app.launch()
        addPatient(firstName: "John", lastName: "Doe", height: "180", weight: "170")
        XCTAssertTrue(app.staticTexts["patientName_Doe_John"].exists)
    }

    @MainActor
    func testErrorMessageForInvalidInput() throws {
        let app = XCUIApplication()
        app.launch()
        addPatient(firstName: "John", lastName: "Doe", height: "abc", weight: "xyz")
        XCTAssertTrue(app.staticTexts["Height and weight must be numeric."].exists)
    }
    
    @MainActor
    func testPrescribeMedicationAndHandleDuplicate() throws {
        let app = XCUIApplication()
        app.launch()
        addPatient(firstName: "John", lastName: "Doe", height: "180", weight: "170")
        app.staticTexts["patientName_Doe_John"].tap()
        addMedication(medicationName: "Ibuprofen", medicationDose: 200, medicationRoute: "Oral", medicationFrequency: 2, medicationDuration: 30)
        XCTAssertTrue(app.staticTexts["medication_Ibuprofen"].exists)
        addMedication(medicationName: "Ibuprofen", medicationDose: 200, medicationRoute: "Oral", medicationFrequency: 2, medicationDuration: 30)
        XCTAssertTrue(app.staticTexts["medicationError"].exists)
    }
    
    @MainActor
    func testSearchByLastName() throws {
        let app = XCUIApplication()
        app.launch()

        addPatient(firstName: "John", lastName: "Doe", height: "180", weight: "170")
        addPatient(firstName: "Jane", lastName: "Smith", height: "165", weight: "130")

        let searchField = app.searchFields["Search by last name"]
        searchField.tap()
        searchField.typeText("Doe")

        XCTAssertTrue(app.staticTexts["patientName_Doe_John"].exists)
        XCTAssertFalse(app.staticTexts["patientName_Smith_Jane"].exists)
        searchField.buttons["Clear text"].tap()
        XCTAssertTrue(app.staticTexts["patientName_Doe_John"].exists)
        XCTAssertTrue(app.staticTexts["patientName_Smith_Jane"].exists)
    }

}
