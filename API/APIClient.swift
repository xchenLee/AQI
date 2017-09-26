//
//  APIClient.swift
//  API
//
//  Created by danlan on 2017/9/26.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


private let instanceOfAQI = APIClient()

public class APIClient: NSObject {
    
    let tokenOfAQI: String = "d08c38afaca02d63ab102c066fac8e8e5e8b47fd"
    let baseUrl: String = "https://api.waqi.info"

    // to write a singleton method
    public class var shared: APIClient {
        return instanceOfAQI
    }
    
    public func cityFeed(_ city: String, completionHandler: @escaping (JSON, Error?) -> Void) {
        let url = baseUrl + "/feed/" + city + "/" + "?token=" + tokenOfAQI
        
        //let serverTrustPolicies: [String: ServerTrustPolicy] = ["instore.meduzaradio.com": .DisableEvaluation]
        
        Alamofire.request(url).responseJSON { (response) in
            
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let jsonValue = response.result.value {
                let parsedResult = JSON(jsonValue)
                DispatchQueue.main.async {
                    completionHandler(parsedResult, nil)
                }
                print("JSON: \(parsedResult)")
            } else {
                DispatchQueue.main.async {
                    completionHandler(JSON({}), nil)
                }
            }
        }
    }
    
    public func locationFeed(_ lat: Double, lon: Double, completionHandler: @escaping (JSON, Error?) -> Void) {
        let url = baseUrl + "/feed/geo:\(lat);\(lon)/" + "?token=" + tokenOfAQI
        Alamofire.request(url).responseJSON { (response) in
            
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let jsonValue = response.result.value {
                let parsedResult = JSON(jsonValue)
                DispatchQueue.main.async {
                    completionHandler(parsedResult, nil)
                }
                print("JSON: \(parsedResult)")
            } else {
                DispatchQueue.main.async {
                    completionHandler(JSON({}), nil)
                }
            }
        }
    }
}

