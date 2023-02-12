//
//  irfanizudinTests.swift
//  irfanizudinTests
//
//  Created by Irfan Izudin on 12/02/23.
//

import XCTest
@testable import irfanizudin

final class irfanizudinTests: XCTestCase {

    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_getAllRockets_withValidEndpoint_returnResponse() {
        
        // given
        let endpoint = "/rockets"
        let expectation = XCTestExpectation(description: "getAllRockets_withValidEndpoint_returnResponse")
        var responseError: Error?
        var responseData: [Rocket]?
        
        // when
        sut.getData(endpoint: endpoint, type: [Rocket].self) { result in
            switch result {
            case .success(let rockets):
                responseData = rockets
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
    }
    
    func test_getAllRockets_withInvalidEndpoint_returnError() {
        
        let endpoint = "/rocket"
        let expectation = XCTestExpectation(description: "getAllRockets_withInvalidEndpoint_returnError")
        var responseError: Error?
        var responseData: [Rocket]?
        
        
        sut.getData(endpoint: endpoint, type: [Rocket].self) { result in
            switch result {
            case .success(let rockets):
                responseData = rockets
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(responseError)
        XCTAssertNil(responseData)
    }

    func test_getDetailRocket_withValidEndpointAndValidRocketID_returnResponse() {
        
        let rocketId = "5e9d0d96eda699382d09d1ee"
        let endpoint = "/rockets/\(rocketId)"
        let expectation = XCTestExpectation(description: "getDetailRocket_withValidEndpointAndValidRocketID_returnResponse")
        var responseError: Error?
        var responseData: Rocket?
        
        
        sut.getData(endpoint: endpoint, type: Rocket.self) { result in
            switch result {
            case .success(let rocket):
                responseData = rocket
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
    }

    func test_getDetailRocket_withValidEndpointAndInvalidRocketID_returnError() {
        
        let rocketId = "1"
        let endpoint = "/rockets/\(rocketId)"
        let expectation = XCTestExpectation(description: "getDetailRocket_withValidEndpointAndInvalidRocketID_returnError")
        var responseError: Error?
        var responseData: Rocket?
        
        
        sut.getData(endpoint: endpoint, type: Rocket.self) { result in
            switch result {
            case .success(let rocket):
                responseData = rocket
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(responseError)
        XCTAssertNil(responseData)
    }
    
    func test_searchRocket_withValidEndpointAndContainsKeyword_returnResponse() {

        let endpoint = "/rockets/query"
        let keyword = "star"
        
        let body: [String: Any] = [
            "query": [
                "name": [
                    "$regex": keyword,
                    "$options": "i"
                ]
            ],
            "options": []
        ]

        let expectation = XCTestExpectation(description: "searchRocket_withValidEndpointAndContainsKeyword_returnResponse")
        var responseError: Error?
        var responseData: [Rocket]?
        
        sut.postData(endpoint: endpoint, body: body, type: QueryResponse.self) { result in
            switch result {
            case .success(let response):
                responseData = response.docs
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)

    }

    func test_searchRocket_withValidEndpointAndKeywordNotFound_returnResponse() {

        let endpoint = "/rockets/query"
        let keyword = "start"
        
        let body: [String: Any] = [
            "query": [
                "name": [
                    "$regex": keyword,
                    "$options": "i"
                ]
            ],
            "options": []
        ]

        let expectation = XCTestExpectation(description: "searchRocket_withValidEndpointAndKeywordNotFound_returnResponse")
        var responseError: Error?
        var responseData: [Rocket]?
        
        sut.postData(endpoint: endpoint, body: body, type: QueryResponse.self) { result in
            switch result {
            case .success(let response):
                responseData = response.docs
            case .failure(let error):
                responseError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
        XCTAssertTrue(responseData!.isEmpty)
    }


}
