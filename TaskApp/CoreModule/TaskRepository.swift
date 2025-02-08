//
//  TaskRepository.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation
import Combine

protocol TaskFetchingProtocol{
    func fetchNextPath() -> AnyPublisher<NextPathModel, Error>
    func fetchResponsecode(_ url:String) -> AnyPublisher<ResponseCodeModel, Error>
}

protocol TaskExecuteProtocol{
    func executeTask() -> AnyPublisher<ResponseCodeModel, Error>
}

typealias TaskRepositoryProtocol = TaskFetchingProtocol & TaskExecuteProtocol

final class TaskRepository:TaskRepositoryProtocol{
    
    let service:NetworkProtocol
    init(service:NetworkProtocol) {
        self.service = service
    }
    
    func fetchNextPath() -> AnyPublisher<NextPathModel, Error> {
        let req = TaskApi.nextpath
        return service.call(request: req)
    }
    
    func fetchResponsecode(_ url:String) -> AnyPublisher<ResponseCodeModel, Error> {
        let req = TaskApi.responsecode(url)
        return service.call(request: req)
    }
    
    func executeTask() -> AnyPublisher<ResponseCodeModel, Error> {
        return fetchNextPath()
            .flatMap { [unowned self] res -> AnyPublisher<ResponseCodeModel, Error> in
                return fetchResponsecode(res.nextPath.orEmpty)
            }
            .eraseToAnyPublisher()
    }
}
