//
//  AQIAPI.swift
//  AQIDemo
//
//  Created by danlan on 2017/9/14.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let instanceOfAQI = AQIAPI()
private let tokenOfAQI: String = "d08c38afaca02d63ab102c066fac8e8e5e8b47fd"

class AQIAPI: NSObject {

    class var shared: AQIAPI {
        return instanceOfAQI
    }
    
    
    class func cityFeed(_ city: String, completionHandler: @escaping (JSON, Error?) -> Void) {
        let url = "https://api.waqi.info/feed/" + city + "/" + "?token=" + tokenOfAQI
        
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
    
    class func locationFeed(_ lat: Double, lon: Double, completionHandler: @escaping (JSON, Error?) -> Void) {
        let url = "https://api.waqi.info/feed/geo:\(lat);\(lon)/" + "?token=" + tokenOfAQI
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










