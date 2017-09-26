//
//  TodayViewController.swift
//  AQIWidget
//
//  Created by danlan on 2017/9/25.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import API

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate  {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    var lastLatitude: Double = 0
    var lastLongitude: Double = 0
    
    var lastTimestamp: Date?
    
    var clManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clManager.delegate = self
        self.clManager.desiredAccuracy = kCLLocationAccuracyBest
        self.clManager.distanceFilter = 10
        self.clManager.requestWhenInUseAuthorization()
        //self.clManager.allowsBackgroundLocationUpdates = true 报错
        self.clManager.startUpdatingLocation()
        
        //self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.preferredContentSize = CGSize(width: 0, height: 40)
    }
    
    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = CGSize(width: 0, height: 40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            self.lastLatitude = location.coordinate.latitude
            self.lastLongitude = location.coordinate.longitude
            
            self.parseLocation(location)
            self.requestQuality(lastLatitude, lastLongitude)
            self.clManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    // MARK: - request quality
    func requestQuality(_ latitude: Double, _ longitude: Double) {
    
        if latitude == 0 || longitude == 0 {
            return
        }
        print("request location quality")
        APIClient.shared.locationFeed(latitude, lon: longitude) { (result, error) in
            if error == nil && result.error == nil {
                let quality = result["data"]["aqi"].int!
                self.qualityLabel.text = "\(quality)"
                self.qualityLabel.textColor = Tool.qualityColor(quality)
                
                self.tipLabel.text = Tool.qualityLevel(quality)
            }
        }
    }
    
    // MARK: - get location
    func parseLocation(_ location: CLLocation) {
        
        Tool.location(location.coordinate.latitude, location.coordinate.longitude) { (mark) in
            
            if let clMark = mark {
                print("location: \(String(describing: clMark))")
                
                var result = ""
//                if let country = clMark.country {
//                    result += country
//                }
                if let city = clMark.locality {
                    result += city
                }
                if let subLocality = clMark.subLocality {
                    result += subLocality
                }
                if let subLocality = clMark.subLocality {
                    result += subLocality
                }
                if let thoroughfare = clMark.thoroughfare {
                    result += thoroughfare
                }
                if let subThoroughfare = clMark.subThoroughfare {
                    result += subThoroughfare
                }
                self.placeLabel.text = result
                
            } else {
                print("parse location error")
            }
        }
    }
}















