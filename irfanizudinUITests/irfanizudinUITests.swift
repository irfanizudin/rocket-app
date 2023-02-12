//
//  irfanizudinUITests.swift
//  irfanizudinUITests
//
//  Created by Irfan Izudin on 12/02/23.
//

import XCTest

final class irfanizudinUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {

        continueAfterFailure = false
        app.launch()

    }

    func test_rocketlistScreenLoaded() {
        // given
        let navigationTitle = app.navigationBars.staticTexts["Rocket List"]
        let searchBar = app.navigationBars.searchFields.firstMatch
        let table = app.tables
        let falconPredicate = NSPredicate(format: "label beginswith 'Falcon'")

        // when
        let falconCell = table.containing(falconPredicate).element
        
        // then
        XCTAssertTrue(navigationTitle.exists)
        XCTAssertTrue(table.firstMatch.waitForExistence(timeout: 1))
        XCTAssertTrue(falconCell.waitForExistence(timeout: 1))
        XCTAssertTrue(searchBar.waitForExistence(timeout: 1))
    }
    
    func test_navigateToRocketDetailScreen() {
        // given
        let table = app.tables
        let navigationTitle = app.navigationBars.staticTexts["Rocket Detail"]
        let rocketImage = app.images.firstMatch
        let rocketName = app.staticTexts["Falcon 1"]
        let rocketDescPredicate = NSPredicate(format: "label contains 'The Falcon 1'")
        let costPerLaunchPredicate = NSPredicate(format: "label contains '6700000'")
        let countryPredicate = NSPredicate(format: "label contains 'Republic of the Marshall Islands'")
        let firstFlightPredicate = NSPredicate(format: "label contains '2006-03-24'")
        
        // when
        table.staticTexts["Falcon 1"].tap()
        let rocketDesc = app.staticTexts.containing(rocketDescPredicate).element
        let costPerLaunch = app.staticTexts.containing(costPerLaunchPredicate).element
        let country = app.staticTexts.containing(countryPredicate).element
        let firstFlight = app.staticTexts.containing(firstFlightPredicate).element

        // then
        XCTAssertTrue(navigationTitle.exists)
        XCTAssertTrue(rocketImage.waitForExistence(timeout: 1))
        XCTAssertTrue(rocketName.waitForExistence(timeout: 1))
        XCTAssertTrue(rocketDesc.waitForExistence(timeout: 1))
        XCTAssertTrue(costPerLaunch.waitForExistence(timeout: 1))
        XCTAssertTrue(country.waitForExistence(timeout: 1))
        XCTAssertTrue(firstFlight.waitForExistence(timeout: 1))
                
    }
    
    func test_searchRocketFoundData() {
        // given
        let searchBar = app.navigationBars.searchFields.firstMatch
        let table = app.tables
        let starshipCell = table.staticTexts["Starship"]
        /// navigate to rocket detail
        let navigationTitle = app.navigationBars.staticTexts["Rocket Detail"]
        let rocketImage = app.images.firstMatch
        let rocketName = app.staticTexts["Starship"]
        let rocketDescPredicate = NSPredicate(format: "label contains 'Starship and Super'")
        let costPerLaunchPredicate = NSPredicate(format: "label contains '7000000'")
        let countryPredicate = NSPredicate(format: "label contains 'United States'")
        let firstFlightPredicate = NSPredicate(format: "label contains '2021-12-01'")
        
        // when
        searchBar.tap()
        searchBar.typeText("star")
        /// navigate to rocket detail
        let rocketDesc = app.staticTexts.containing(rocketDescPredicate).element
        let costPerLaunch = app.staticTexts.containing(costPerLaunchPredicate).element
        let country = app.staticTexts.containing(countryPredicate).element
        let firstFlight = app.staticTexts.containing(firstFlightPredicate).element
        
        // then
        XCTAssertTrue(starshipCell.waitForExistence(timeout: 1))
        starshipCell.tap()
        /// navigate to rocket detail
        XCTAssertTrue(navigationTitle.exists)
        XCTAssertTrue(rocketImage.waitForExistence(timeout: 1))
        XCTAssertTrue(rocketName.waitForExistence(timeout: 1))
        XCTAssertTrue(rocketDesc.waitForExistence(timeout: 1))
        XCTAssertTrue(costPerLaunch.waitForExistence(timeout: 1))
        XCTAssertTrue(country.waitForExistence(timeout: 1))
        XCTAssertTrue(firstFlight.waitForExistence(timeout: 1))

    }
    
    func test_searchRocketNotFoundData() {
        // given
        let searchBar = app.navigationBars.searchFields.firstMatch
        let notFoundLabel = app.staticTexts["Rocket not found!"]
        
        // when
        searchBar.tap()
        searchBar.typeText("phoenix")
        
        // then
        XCTAssertTrue(notFoundLabel.waitForExistence(timeout: 1))
    }

}
