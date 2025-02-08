//
//  TaskViewModelTest.swift
//  TaskAppTests
//
//  Created by Guru King on 08/02/2025.
//

import XCTest
import Combine
@testable import TaskApp

final class TaskViewModelTest: XCTestCase {

    private var cancelables = Set<AnyCancellable>()
    private var mockNetwork: MockNetwork!
    private var repository: TaskRepositoryProtocol!
    private var viewModel: TaskViewModel!

    override func setUp() {
        mockNetwork = MockNetwork()
        repository = TaskRepository(service: mockNetwork)
        viewModel = TaskViewModel(repo: repository)
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        mockNetwork = nil
        cancelables = []
    }

    func testViewModelInit() {
        XCTAssertEqual(viewModel.loading, false)
        XCTAssertEqual(viewModel.error, "")
        XCTAssertEqual(viewModel.responseCode, "")
        XCTAssertEqual(viewModel.fetchCount, 0)
    }

    func testFailure() {
        viewModel.error = "forced error"
        XCTAssertEqual(viewModel.error, "forced error")
    }

    func testLoadingUpdatedCorrectly() {
        viewModel.loading = true
        XCTAssertEqual(viewModel.loading, true)
    }

    func testValuesUpdatedCorrectly() {
        viewModel.responseCode = "ResponseCode"
        viewModel.fetchCount = 1
        XCTAssertEqual(viewModel.responseCode, "ResponseCode")
        XCTAssertEqual(viewModel.fetchCount, 1)
    }

    func testCanIncrementFetchCount() {
        viewModel.incrementFetchCount()
        XCTAssertEqual(viewModel.fetchCount, 1)
    }

    func testCanUpdateData() {
        viewModel.updateData(with: "ResponseCode")
        XCTAssertEqual(viewModel.responseCode, "ResponseCode")
        XCTAssertEqual(viewModel.fetchCount, 1)
    }

    func testFetchTaskSuccess() {
        let expectation = XCTestExpectation(description: "Task fetched successfully")

        viewModel.fetchTask()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.viewModel.loading, "Loading should be false after fetch")
            XCTAssertEqual(self.viewModel.responseCode, "40d92bde-49bc-4c54-bb49-75557247e820")
            XCTAssertEqual(self.viewModel.fetchCount, 1, "Fetch count should increment")
            XCTAssertEqual(self.viewModel.error, "", "Error should still be empty")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchTaskFailure() {
        let expectation = XCTestExpectation(description: "Task fetching should fail")

        let mockNetwork = MockNetworkFailure()
        let repository = TaskRepository(service: mockNetwork)
        let viewModel: TaskViewModel = .init(repo: repository)

        viewModel.fetchTask()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(viewModel.loading, "Loading should be false after fetch")
            XCTAssertEqual(viewModel.responseCode, "", "Response code should remain empty")
            XCTAssertEqual(viewModel.fetchCount, 0, "Fetch count should not increment on failure")
            XCTAssertEqual(viewModel.error, "should fail", "Error should match the expected failure message")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
