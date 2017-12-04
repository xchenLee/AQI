//
//  TodayViewController.swift
//  BluedNet
//
//  Created by danlan on 2017/9/26.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var resultLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        let url = "http://10.10.10.1/ac_portal/login.php?"
        let parameters: [String: Any] = ["opr": "pwdLogin",
                                         "userName": "孟德功",
                                         "pwd": "123123",
                                         "rememberPwd": 1]
        Alamofire.request(url, method: .post, parameters:parameters).responseString { (response) in
            
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let _ = response.result.value {
                let rawString = String(data: response.data!, encoding: String.Encoding.utf8)

                let valueCompat = rawString!.replacingOccurrences(of: "'", with: "\"")
                let parsedResult = JSON(parseJSON:valueCompat)
                
                let success = parsedResult["success"].bool!
                let msg = parsedResult["msg"].string!
                if success {
                    
                    let tip = "已连接，请立刻打开钉钉打卡!!!"
                    let range = NSMakeRange(9, 2)
                    let attrString = NSMutableAttributedString(string: tip)
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
                    attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold  ), range: range)
                    self.resultLabel.attributedText = attrString
                    
                    let dingdingScheme = "dingtalk://dingtalkclient"
                    let dingUrl = URL(string: dingdingScheme)!
                    
                    self.extensionContext?.open(dingUrl, completionHandler: nil)
                    
                } else {
                    self.resultLabel.text = msg
                }
            }
        }
    }
    
}
