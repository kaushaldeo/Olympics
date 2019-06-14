//
//  NetworkManager.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let `default` = NetworkManager()
    
    let session: SessionManager
    
    init() {
        self.session = SessionManager(configuration: .default)
    }
    
    func countries(router: Request.Router, completionBlock: @escaping ([Country]) -> Void) {
        let request = self.session.request(router)
        request.responseData { (response) in
            var items = [Country]()
            guard let data = response.value else {
                completionBlock(items)
                return
            }
            do {
                items = try JSONDecoder().decode([Country].self, from: data)
            }
            catch {
                print(error)
            }
            completionBlock(items)
        }
    }
    
    func sports(router: Request.Router, completionBlock: @escaping ([Sport]) -> Void) {
        let request = self.session.request(router)
        request.responseData { (response) in
            var items = [Sport]()
            guard let data = response.value else {
                completionBlock(items)
                return
            }
            do {
                items = try JSONDecoder().decode([Sport].self, from: data)
            }
            catch {
                print(error)
            }
            completionBlock(items)
        }
    }
}


struct Request {
    static let url = URL(string: "https://raw.githubusercontent.com/kaushaldeo/olympic-data/master")!
    
    enum Router: URLRequestConvertible {
        case countries
        case sports
        case event(_ sport: String)
        
        func asURLRequest() throws -> URLRequest {
            let path : String = {
                switch self {
                case .countries:
                    return "countries.json"
                case .sports:
                    return "sports.json"
                case .event(let sport):
                    return "events/\(sport).json"
                }
            }()
            
            return URLRequest(url: Request.url.appendingPathComponent(path))
        }
    }
}

