//
//  Service.swift
//  OttoCodingChallenge
//
//  Created by Developer on 11.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import UIKit

fileprivate let APIKey = "hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD"
fileprivate let MenuRequestURLString = "https://mytoysiostestcase1.herokuapp.com/api/navigation"

typealias RequestSuccess = ((Dictionary<String, Any>) -> Void)
typealias RequestFailure = ((Error) -> Void)

protocol ServiceProtocol {
    func requestMenu(success: @escaping RequestSuccess, failure: @escaping RequestFailure)
}

class Service {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func requestMenu(success: @escaping RequestSuccess, failure: @escaping RequestFailure) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        if let url = URL(string: MenuRequestURLString) {
            var request = URLRequest(url: url)
            request.setValue(APIKey, forHTTPHeaderField: "x-api-key")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard error == nil else {
                    debugPrint(error.debugDescription)
                    failure(error!)
                    return
                }
                
                var menu: [String:Any]?
                
                if let data = data {
                    try? menu = (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]) ?? nil
                }
                
                if let menu = menu {
                    success(menu)
                }
            })
            
            task.resume()
        }
    }
}
