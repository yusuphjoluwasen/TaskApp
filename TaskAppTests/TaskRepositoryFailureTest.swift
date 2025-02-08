//
//  TaskRepositoryFailureTest.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import XCTest
import Combine
@testable import TaskApp

final class TaskRepositoryFailureTest: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private var mockNetwork = MockNetworkFailure()
    private var taskRepository: TaskRepositoryProtocol!

    override func setUp() {
        taskRepository = TaskRepository(service: mockNetwork)
    }

    override func tearDown() {
        taskRepository = nil
        cancellables = []
    }

    func testFailureFetchNextPath() {
        let exp = XCTestExpectation(description: "couldntFetchNextPath")

        taskRepository?.fetchNextPath()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error.localizedDescription)
                    XCTAssertEqual(error.localizedDescription, "should fail")
                case .finished:
                    print("Execution Finished.")
                }
                exp.fulfill()
            } receiveValue: {_ in }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 0.5)
    }

    func testFailureFetchResponseCode() {
        let exp = XCTestExpectation(description: "couldntFetchResponseCode")

        taskRepository?.fetchResponsecode("responsecode")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error.localizedDescription)
                    XCTAssertEqual(error.localizedDescription, "should fail")
                case .finished:
                    print("Execution Finished.")
                }
                exp.fulfill()
            } receiveValue: {_ in }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 0.5)
    }
}
