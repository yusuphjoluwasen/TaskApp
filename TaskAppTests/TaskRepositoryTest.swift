//
//  TaskRepositoryTest.swift
//  TaskAppTests
//
//  Created by Guru King on 08/02/2025.
//

import XCTest
import Combine
@testable import TaskApp

final class TaskRepositoryTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var mockNetwork = MockNetwork()
    private var taskRepository: TaskRepositoryProtocol!

    override func setUp() {
        taskRepository = TaskRepository(service: mockNetwork)
        cancellables = []
    }

    override func tearDown() {
        taskRepository = nil
        cancellables = []
    }

    func testFetchNextPath() {
        let expectation = XCTestExpectation(description: "Fetch Next Path")

        taskRepository.fetchNextPath()
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

        taskRepository.fetchResponsecode("responsecode")
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

    func testExecuteTask() {
        let expectation = XCTestExpectation(description: "Fetch Response Code")

        taskRepository.executeTask()
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

    func testExecuteTaskFailure() {
        let expectation = XCTestExpectation(description: "Execute Task should fail")

        let mockNetwork = MockNetworkFailure()
        let repository = TaskRepository(service: mockNetwork)

        repository.executeTask()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "should fail")
                    expectation.fulfill()
                }
            } receiveValue: { (_: ResponseCodeModel) in
                XCTFail("Expected failure but received value instead")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
