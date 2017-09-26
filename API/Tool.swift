//
//  Tool.swift
//  API
//
//  Created by danlan on 2017/9/26.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import CoreLocation

private let goodColor  = UIColor(red: 21/255,  green: 136/255, blue: 82/255,  alpha: 1)
private let middColor  = UIColor(red: 253/255, green: 217/255, blue: 40/255,  alpha: 1)

private let poorColor  = UIColor(red: 251/255, green: 134/255, blue: 41/255,  alpha: 1)
private let badColor   = UIColor(red: 187/255, green: 0/255,   blue: 40/255,  alpha: 1)
private let worseColor = UIColor(red: 82/255,  green: 0/255,   blue: 135/255, alpha: 1)
private let worstColor = UIColor(red: 105/255, green: 0/255,   blue: 27/255,  alpha: 1)


public class Tool:NSObject {
    
    public class func qualityColor(_ quality: Int) -> UIColor {
        
        if quality <= 50 {
            return goodColor
        } else if quality <= 100 {
            return middColor
        } else if quality <= 150 {
            return poorColor
        } else if quality <= 200 {
            return badColor
        } else if quality <= 300 {
            return worseColor
        } else {
            return worstColor
        }
    }
    
    public class func qualityLevel(_ quality: Int) -> String {
        
        if quality <= 50 {
            return "优"
        } else if quality <= 100 {
            return "良"
        } else if quality <= 150 {
            return "轻度污染"
        } else if quality <= 200 {
            return "重度污染"
        } else if quality <= 300 {
            return "重度污染"
        } else {
            return "严重污染"
        }
    }
    
    public class func qualityImpact(_ quality: Int) -> String {
        
        if quality <= 50 {
            return "空气质量令人满意，基本无空气污染"
        } else if quality <= 100 {
            return "空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响"
        } else if quality <= 150 {
            return "易感人群症状有轻度加剧，健康人群出现刺激症状"
        } else if quality <= 200 {
            return "进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响"
        } else if quality <= 300 {
            return "心脏病和肺病患者症状显著加剧，运动耐受力降低，健康人群普遍出现症状"
        } else {
            return "健康人群运动耐受力降低，有明显强烈症状，提前出现某些疾病"
        }
    }
    
    public class func location(_ latitude: Double, _ longitude: Double, completionHandler: @escaping (CLPlacemark?) -> Void) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (result, error) in
            if error != nil || result == nil || result!.count == 0 {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            } else {
                let mark = result![0]
                DispatchQueue.main.async {
                    completionHandler(mark)
                }
            }
        }
    }
    
}

















