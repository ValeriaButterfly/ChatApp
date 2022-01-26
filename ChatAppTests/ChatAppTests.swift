//
//  ChatAppTests.swift
//  ChatAppTests
//
//  Created by Valeria Muldt on 13.12.2021.
//

@testable import ChatApp
import XCTest

class ChatAppTests: XCTestCase {

    // MARK: - Private Properties

    private var networkService: NetworkServiceProtocol!
    private var imageURL = "https://cdn.pixabay.com/photo/2021/11/15/05/52/red-fox-6796430_150.jpg"

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        networkService = NetworkService()
    }

    override func tearDown() {
        super.tearDown()

        networkService = nil
    }

    // MARK: - Methods

    func testGettingImageList() {

        let exp = expectation(description: "Loading images")
        var globResult: Result<[Image], Error>?

        networkService.sendRequestForImageList { result in
            globResult = result
            exp.fulfill()
        }

        waitForExpectations(timeout: 3.0) { error in
            XCTAssertNil(error, "Getting Images is OK")
        }

        XCTAssertNotNil(globResult)

        switch globResult {
        case .success(let imageList): XCTAssertFalse(imageList.isEmpty)
        case .failure(let error): XCTAssertNil(error)
        default: XCTFail("Non of accepted options.")
        }
    }

    func testLoadImage() {

        let exp = expectation(description: "Loading image")
        var globResult: Result<Data, Error>?

        networkService.sendRequestForImage(url: imageURL) { result in
            globResult = result
            exp.fulfill()
        }

        waitForExpectations(timeout: 3.0) { error in
            XCTAssertNil(error, "Getting Image is OK")
        }

        XCTAssertNotNil(globResult)

        switch globResult {
        case .success(let data): XCTAssertNotNil(UIImage(data: data))
        case .failure(let error): XCTAssertNil(error)
        default: XCTFail("Non of accepted options.")
        }
    }
}
