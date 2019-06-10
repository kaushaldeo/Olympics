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
    
    func get(router: Router, completionBlock: @escaping ([Country]) -> Void) {
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
}


enum Router: URLRequestConvertible {
    case countries
    
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(string: "https://restcountries.eu/rest/v2/all")!)
    }
    
    
}
