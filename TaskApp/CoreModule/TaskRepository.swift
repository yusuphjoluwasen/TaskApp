//
//  TaskRepository.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

/// **TaskFetchingProtocol**
/// A protocol that defines methods for fetching data from the API.
/// - `fetchNextPath()`: Retrieves the next available API path.
/// - `fetchResponsecode(_ url: String)`: Fetches a response code from a given URL.
/// This protocol is only needed in the taskrepository and will not be exposed to the view
protocol TaskFetchingProtocol {
    func fetchNextPath() -> AnyPublisher<NextPathModel, Error>
    func fetchResponsecode(_ url: String) -> AnyPublisher<ResponseCodeModel, Error>
}

/// **TaskExecuteProtocol**
/// A protocol that defines the method for executing a full task operation.
/// - `executeTask()`: Fetches the next path and then retrieves the response code.
/// This protocol will be exposed to the view
protocol TaskExecuteProtocol {
    func executeTask() -> AnyPublisher<ResponseCodeModel, Error>
}

/// **TaskRepositoryProtocol**
/// A typealias that combines both `TaskFetchingProtocol` and `TaskExecuteProtocol`.
/// This ensures that any repository conforming to this protocol has both fetching and execution capabilities.
/// The task fetching protocol will not be exposed to the view since it doesn't need it, to obey
///  the interface segregation principle
typealias TaskRepositoryProtocol = TaskFetchingProtocol & TaskExecuteProtocol

/// **TaskRepository**
/// The repository responsible for handling task-related API calls.
///
/// This class fetches the next available API path, retrieves response codes,
/// and executes full task operations in a structured manner.
///
/// - Uses `NetworkProtocol` for making API calls.
/// - Implements `TaskRepositoryProtocol`, meaning it supports both fetching and executing tasks.
/// - Uses `Combine` publishers to handle asynchronous operations.
final class TaskRepository: TaskRepositoryProtocol {

    /// The network service responsible for making API calls.
    let service: NetworkProtocol

    /// Initializes the repository with a network service.
    /// - Parameter service: A `NetworkProtocol` instance that handles API requests.
    init(service: NetworkProtocol) {
        self.service = service
    }

    /// **Fetches the next path for retrieving a response code.**
    /// - Returns: A publisher that emits a `NextPathModel` or an error.
    func fetchNextPath() -> AnyPublisher<NextPathModel, Error> {
        let req = TaskApi.nextpath
        return service.call(request: req)
    }

    /// **Fetches the response code using the provided URL.**
    /// - Parameter url: The URL received from `fetchNextPath()`, used to get the response code.
    /// - Returns: A publisher that emits a `ResponseCodeModel` or an error.
    func fetchResponsecode(_ url: String) -> AnyPublisher<ResponseCodeModel, Error> {
        let req = TaskApi.responsecode(url)
        return service.call(request: req)
    }

    /// **Executes the full task process by fetching the next path and retrieving the response code.**
    ///
    /// - First, calls `fetchNextPath()` to get the next API endpoint.
    /// - Then, it passes the retrieved path to `fetchResponsecode(_:)` to get the response code.
    /// - Uses `flatMap` to ensure that the second request only starts after the first one succeeds
    /// .`flatMap` helps to combine both the operations of both fetchNextPath and fetchResponsecode
    /// - The result is returned as a `ResponseCodeModel` publisher.
    ///
    /// - Returns: A publisher that emits a `ResponseCodeModel` or an error.
    func executeTask() -> AnyPublisher<ResponseCodeModel, Error> {
        return fetchNextPath()
            .flatMap { [unowned self] res in
                return fetchResponsecode(res.nextPath.orEmpty)
            }
            .eraseToAnyPublisher()
    }
}
