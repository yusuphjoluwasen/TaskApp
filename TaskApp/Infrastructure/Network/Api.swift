//
//  Api.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

enum TaskApi {
    case nextpath
    case responsecode(String)
}

extension TaskApi: EndPointType {
    var name: String {
        switch self {
        case .nextpath:
            return ApiConstants.nextpath
        case .responsecode:
            return ApiConstants.responsecode
        }
    }

    var url: String {
        switch self {
        case .nextpath:
            return ApiConstants.root
        case .responsecode(let url):
            return url
        }
    }
}

enum ApiConstants {
    static let nextpath = "nextpath"
    static let responsecode = "responsecode"
    static let root = "http://localhost:8000"
}
