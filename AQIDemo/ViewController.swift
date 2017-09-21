//
//  ViewController.swift
//  AQIDemo
//
//  Created by danlan on 2017/9/14.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

let goodColor  = UIColor(red: 21/255,  green: 136/255, blue: 82/255,  alpha: 1)
let middColor  = UIColor(red: 253/255, green: 217/255, blue: 40/255,  alpha: 1)

let poorColor  = UIColor(red: 251/255, green: 134/255, blue: 41/255,  alpha: 1)
let badColor   = UIColor(red: 187/255, green: 0/255,   blue: 40/255,  alpha: 1)
let worseColor = UIColor(red: 82/255,  green: 0/255,   blue: 135/255, alpha: 1)
let worstColor = UIColor(red: 105/255, green: 0/255,   blue: 27/255,  alpha: 1)




class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var wallBlur: UIVisualEffectView!
    @IBOutlet weak var wallPaper: UIImageView!
    
    
    // 位置相关
    let clManager = CLLocationManager()
    var lastLatitude: Double = 0
    var lastLongitude: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestResources()
        self.requestQuality("beijing")
        self.requestUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 请求天气数据
    func requestQuality(_ city: String) {
        
        AQIAPI.cityFeed(city) { (result, error) in
            //没有错误
            if error == nil {
                let pm25 = result["data"]["iaqi"]["pm25"]["v"].int!
                self.pm25Label.text = "PM2.5: \(pm25)"
                self.pm25Label.textColor = self.textColor(pm25)
                return
            }
        }
    }
    
    
    // MARK: 初始化, 请求位置权限
    func requestResources() {
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if status == .denied {
            
            // 要不要提示用户
            // 修改UI上的图标
        }
        
        // 不管状态是什么都要设置delegate, 发生变化的时候才能获取到
        self.clManager.delegate = self;
        self.clManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clManager.requestWhenInUseAuthorization()
    }
    
    func requestUI() {
        // 背景图
        self.wallPaper.image = self.randomImage()
        self.wallBlur.alpha = 0.5
        
        // 文本
        self.pm25Label.text = "PM2.5:"
        self.locationLabel.text = "经纬度:"
        
    }
    
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //可能是我初始化方法调用了requestWhenInUseAuthorization,
        //如果是第一次安装，会走这里，权限同意了也会走
        
        switch status {
        case .denied, .notDetermined, .restricted:
            //修改图标 为不能使用状态
            break
        case .authorizedWhenInUse://, .authorizedAlways:
            self.clManager.requestLocation()
            break
        default: break
            //default
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // api 建议取最后一个, 而且至少返回一个
        
        let location = locations.last!
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // 赋值
        self.lastLatitude = latitude
        self.lastLongitude = longitude
        
        //更新UI描述，或者更新，当前的PM值
        self.locationLabel.text = "经纬度:" + String(format: "%.3f", latitude) + "," +  String(format: "%.3f", longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }

    @IBAction func refreshBtnClicked(_ sender: Any) {
        
        AQIAPI.locationFeed(self.lastLatitude, lon: self.lastLongitude) { (result, error) in
            
            let pm25 = result["data"]["iaqi"]["pm25"]["v"].int!
            self.pm25Label.text = "PM2.5: \(pm25)"
            self.pm25Label.textColor = self.textColor(pm25)
            
        }
    }
}

// MARK: 加载图片
extension ViewController {
    
    func loadImage(_ name: String) -> UIImage? {
        //不合适
        /*let bundlePath = Bundle.main.resourcePath!
        let path = bundlePath + "/wall/" + name + ".png"
        
        let image = UIImage(contentsOfFile: path)
        return image*/
        return UIImage(named: name)
    }
    
    func randomImage() -> UIImage? {
        let num: Int = Int(arc4random() % 8) + 1
        let name: String = "n_0\(num)"
        return UIImage(named: name)
    }
    
    func textColor(_ quality: Int) -> UIColor {
        
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
    
}




















