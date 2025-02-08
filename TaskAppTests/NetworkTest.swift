//
//  NetworkTest.swift
//  TaskAppTests
//
//  Created by Guru King on 08/02/2025.
//

import XCTest
import Combine
@testable import TaskApp
class MockNetworkTests: XCTestCase {
    private var mockNetwork: NetworkProtocol!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetwork()
    }

    override func tearDown() {
        mockNetwork = nil
        super.tearDown()
    }

    func testFetchNextPath() {
        let expectation = XCTestExpectation(description: "Fetch next path")

        mockNetwork.call(request: TaskApi.nextpath)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected failure: \(error.localizedDescription)")
                }
            } receiveValue: { (response: NextPathModel) in
                XCTAssertEqual(response.nextPath, "http://localhost:8000/0a79f9d4-e5f4-11ef-84af-ea5c06feb90b/")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchResponseCode() {
        let expectation = XCTestExpectation(description: "Fetch Response Code")

       mockNetwork.call(request: TaskApi.responsecode("responseCode"))
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected failure: \(error.localizedDescription)")
                }
            } receiveValue: { (response: ResponseCodeModel) in
                XCTAssertEqual(response.path, "c3830414-e574-11ef-967d-ea5c06feb90b")
                XCTAssertEqual(response.responseCode, "40d92bde-49bc-4c54-bb49-75557247e820")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFailureForMissingResource() {
        let expectation = XCTestExpectation(description: "Resource doesn't exist")

        mockNetwork.call(request: MockTaskApi.nonexistent)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Invalid URL. Unable to proceed with the request.")
                    expectation.fulfill()
                }
            } receiveValue: { (_: ResponseCodeModel) in
                XCTFail("Expected failure but received value instead")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
