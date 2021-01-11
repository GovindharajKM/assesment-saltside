//
//  AssesmentUITests.swift
//  AssesmentUITests
//
//  Created by Govindharaj Murugan on 09/01/21.
//

import XCTest

class AssesmentUITests: XCTestCase {

    let app = XCUIApplication()
    let tableView = XCUIApplication().tables
    let navigationBars = XCUIApplication().navigationBars
    let staticSearchText = "commanders"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        self.app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableView() {
        self.waitingForAPIResponse()
        sleep(1)
        
        if self.tableView.cells.count == 0 {
            self.record(XCTIssue(type: .assertionFailure, compactDescription: "No data found"))
            return
        }
        sleep(2)
        
        let element = self.app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        sleep(3)
        
        self.app.navigationBars["Assesment.DetailsView"].buttons["Saltside"].tap()
        sleep(2)
       
    }
    
}

extension AssesmentUITests {
    
    func waitingForAPIResponse() {
        
        let startDate = Date()
        
        while self.app.otherElements["loadingViewAppear"].exists {
            let seconds = self.getDateDiff(start: startDate)
            if seconds > 30 {
                self.record(XCTIssue(type: .assertionFailure, compactDescription: "Waiting timeout for API response - loadingViewAppear"))
            }
        }
        sleep(1)
        return
    }
    
    func getDateDiff(start: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: Date())
        let seconds = dateComponents.second ?? 0
        return seconds
    }
    
    func waiterResultWithExpectation(_ element: XCUIElement) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "exists == true")
        let myExpectation = expectation(for: myPredicate, evaluatedWith: element, handler: nil)
        
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 10)
        return result
    }
    
    func waiterResultWithXCTPredicateExpectation(_ element: XCUIElement) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "exists == true")
        let myExpectation = XCTNSPredicateExpectation(predicate: myPredicate,object: element)
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 30)
        return result
    }
    
    func scrollTableToBottom(name: String) {
        let table = self.tableView.element(boundBy: 0)
        let wellIndex = self.findIndexOfTheWell(name: name)
        if wellIndex != -1 {
            let lastCell = table.cells.element(boundBy: wellIndex)
            table.scrollToElement(lastCell)
        }
    }
    
    func findIndexOfTheWell(name: String) -> Int {
        for index in 0..<self.tableView.cells.count {
            if self.tableView.cells.element(boundBy: index).staticTexts[name].exists {
                return index
            }
        }
        return -1
    }
    
    func takeScreenShot() {
        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)
        screenshot.lifetime = .keepAlways
        // if we don't set lifetime to .keepAlways, Xcode will delete the image if the test passes.
        self.add(screenshot)
    }
    
}


// MARK:- XCUIElement
extension XCUIElement {
    
    func scrollToElement(_ element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }

}
