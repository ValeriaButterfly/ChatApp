//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Valeria Muldt on 14.12.2021.
//

import XCTest

class ChatAppUITests: XCTestCase {

    // MARK: - Private Properties

    private var app: XCUIApplication!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()

        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app = nil
    }

    // MARK: - Methods

    func testTextFieldsAvailability() {

        app.tabBars["Tab Bar"].buttons["Profile"].tap()

        let nameTF = app.textFields["nameTF"]
        let specialityTF = app.textFields["specialityTF"]
        let livingPlaceTF = app.textFields["livingPlaceTF"]
        
        XCTAssertTrue(nameTF.exists && specialityTF.exists && livingPlaceTF.exists)
    }
}
