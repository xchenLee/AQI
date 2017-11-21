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
import API
import Alamofire

//https://stackoverflow.com/questions/36805349/how-to-calculate-the-average-color-of-a-uiimage
//https://stackoverflow.com/questions/26330924/get-average-color-of-uiimage-in-swift

private let textColor  = UIColor(red: 62/255,  green: 64/255,   blue: 62/255,  alpha: 1)


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var co: UILabel!
    @IBOutlet weak var o3: UILabel!
    @IBOutlet weak var so2: UILabel!
    @IBOutlet weak var pm10: UILabel!
    @IBOutlet weak var pm25: UILabel!
    @IBOutlet weak var no2: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var wallBlur: UIVisualEffectView!
    @IBOutlet weak var wallPaper: UIImageView!

    
    
    // 位置相关
    @IBOutlet weak var tempLabel: UILabel!
    
    let clManager = CLLocationManager()
    var lastLatitude: Double = 0
    var lastLongitude: Double = 0
    
    var transitionMedia: TransitioningMedia?
    
    
    // UI相关
    var isContentLight: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestResources()
        self.requestQuality("beijing")
        self.requestUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.isContentLight ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 请求天气数据
    func requestQuality(_ city: String) {
        
        APIClient.shared.cityFeed(city) { (result, error) in
            //没有错误
            if error == nil && result.error == nil {
                self.updateUI(result)
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
        self.clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.clManager.requestWhenInUseAuthorization()
    }
    
    func requestUI() {
        // 背景图
        self.wallBlur.alpha = 0.5
        
        let image = self.randomImage()
        self.wallPaper.image = image
        
        // 文本
        self.locationLabel.text = "经纬度:"
        self.pm25Label.text = "Quality"
        self.pm25Label.textColor = textColor
        self.tempLabel.textColor = textColor
        self.locationLabel.textColor = textColor
        
        self.changeImage(image!)
    }
    
    func changeImage(_ image: UIImage) {
        DispatchQueue.global().async {
            
            //let coppedImage = image?.crop(CGRect(x: 0, y: 0, width: (image?.size.width)!, height: 50))
            let averageColor = image.areaAverage()
            let components = averageColor.cgColor.components!
            let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
            DispatchQueue.main.async {
                self.isContentLight = brightness > 0.5
            }
        }
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
        
        //let image = self.randomImage()
        //self.wallPaper.image = image
        //self.changeImage(image!)
    
//        APIClient.shared.locationFeed(self.lastLatitude, lon: self.lastLongitude) { (result, error) in
//            if error == nil && result.error == nil {
//                self.updateUI(result)
//            }
//        }
        
        transitionMedia = TransitioningMedia()
        let searchController = SearchController()
        searchController.modalPresentationStyle = .custom
        searchController.view.isOpaque = false
        searchController.transitioningDelegate = transitionMedia
        transitionMedia?.interact.prepareGesture(searchController)
        self.present(searchController, animated: true, completion: nil)
    }
    
    func updateUI(_ result: JSON) {
        
        let quality = result["data"]["aqi"].int!
        if result["data"]["iaqi"]["t"] != JSON.null {
            let temp = result["data"]["iaqi"]["t"]["v"].int!
            self.tempLabel.text = "\(temp)°C"
        }
        
        let pm25V = result["data"]["iaqi"]["pm25"]["v"].int!
        let pm10V = result["data"]["iaqi"]["pm10"]["v"].int!
        let o3V = result["data"]["iaqi"]["o3"]["v"].int!
        let so2V = result["data"]["iaqi"]["so2"]["v"].int!
        let coV = result["data"]["iaqi"]["co"]["v"].int!
        let no2V = result["data"]["iaqi"]["no2"]["v"].int!
        
        self.pm25Label.text = "\(quality)"
        self.pm25Label.textColor = Tool.qualityColor(quality)
        
        self.pm25.text = "\(pm25V)  μg/m3"
        self.pm10.text = "\(pm10V)  μg/m3"
        self.o3.text = "\(o3V)  μg/m3"
        self.so2.text = "\(so2V)  μg/m3"
        self.co.text = "\(coV) mg/m3"
        self.no2.text = "\(no2V) mg/m3"
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
        
//        let num: Int = Int(arc4random() % 8) + 1
//        let name: String = "n_0\(num)"
        return UIImage(named: "n_02")
    }
    
}

