//
//  Api.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

enum TaskApi{
    case nextpath
    case responsecode(String)
}

extension TaskApi:EndPointType{
    var url: String {
        switch self {
        case .nextpath:
            return Constants.root
        case .responsecode(let url):
            return url
        }
    }
}
