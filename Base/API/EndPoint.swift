//
//  EndPoint.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 05/01/23.
//

import Foundation

enum EndPoint {
    case people(page: Int)
    case detail(id: Int) 
    case create(submissionData: Data?)
}

extension EndPoint {
    enum MethodType {
        case GET
        case POST(data: Data?)
    }
}

extension EndPoint {
    
    var host: String { "reqres.in" }
    
    var path: String {
        switch self {
        case .people,
             .create:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .people,
             .detail:
            return .GET
        case .create(let data):
            return .POST(data: data)
            
        }
    }
    
    var queryItems: [String : String]? {
        switch self {
        case .people(let page):
            return ["page":"\(page)"]
        default:
            return nil
        }
    }
}

extension EndPoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        //Loop through compactMap, and to handle nil
        var requestQueryItems = queryItems?.compactMap { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        
        //if DEBUG will get execute when only in debug mode only, and wont execute if the app release
//        #if DEBUG
        requestQueryItems?.append(URLQueryItem(name: "delay", value: "4 "))
//        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
    
}
