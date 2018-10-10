//
//  QuotesViewController.swift
//  prd
//
//  Created by Jan Catlos on 23/01/2018.
//  Copyright © 2018 Jan Catlos. All rights reserved.
//

import Cocoa
import WebKit
import AppKit
import SwiftyJSON
import SwiftyTimer
import Alamofire
import JavaScriptCore

var usrToken:String = ""
var usrId:String = ""
var showAlert:Bool = true
var limit:Int = 0
var workActivity : Int = 0
var pauseActivity : Int = 0
var workType : Int = 0
var pauseType : Int = 0
var parameters : [String : Any] = [:]
var alertObservioName : String = ""
var alertObservioText : String = ""
var observioAlert : Int = 0

var statusCode : String? = ""
var convertString : Int = 0




class QuotesViewController: NSViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func ExtiApp(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func refresh(_ sender: Any) {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        webView.reload()
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.reload()
        
        activityChceck()
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "userToken"{
                    usrToken = cookie.value
                }
                if cookie.name == "userId"{
                    usrId = cookie.value
                }
            }
        }
        
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        parameters = [
            "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
            "userToken" : usrToken,
            "userId" : usrId,
            "code" : statusCode!
        ]
        print("USERID:\(usrId)")
        print("USRTOKEN:\(usrToken)")
        
        func controlMyStatus(){
            Alamofire.request("https://observio.org/observio/public/api/tracking/Ping", method: .post, parameters: parameters, headers: headers).responseJSON{
                response in
                if response.result.isSuccess{
                    let ourdataJSON : JSON = JSON(response.result.value!)
                    workActivity = ourdataJSON["data"]["lastWorkTrack"]["activity"].intValue
                    pauseActivity = ourdataJSON["data"]["lastPauseTrack"]["activity"].intValue
                    workType = ourdataJSON["data"]["lastWorkTrack"]["work_type"].intValue
                    
                    
// custom alerts
                    observioAlert = ourdataJSON["alert"]["code"].intValue
                    
                    
                    if observioAlert > 0{
                        alertObservioName = ourdataJSON["alert"]["name"].stringValue
                        alertObservioText = ourdataJSON["alert"]["text"].stringValue
                        observioAlert = 0
                        _ = cusomAlert(question: alertObservioName, text: alertObservioText, Token: usrToken, Id: usrId)
                    }
                    if ourdataJSON["noChanged"] != true{
                        if workActivity == 2{
                            statusCode = "\(workActivity)0\(pauseActivity)"
                        }
                        else if pauseActivity == 4{
                            statusCode = "\(workActivity)\(workType)0\(pauseActivity)"
                        }else
                        {
                            pauseType = ourdataJSON["data"]["lastPauseTrack"]["pause_type"].intValue
                            statusCode = "\(workActivity)\(workType)0\(pauseActivity)\(pauseType)"
                        }
                    }
                    
                    if workActivity == 1{
                        if pauseActivity == 3{
                            if pauseType == 1{
                                // BREAK
                                print("<----------Break")
                                _ = breakAlert(question: "Observio", text: "You are on a break!", Token: usrToken, Id: usrId)
                            } else if pauseType == 2{
                                // LUNCH
                                print("<----------Lunch")
                                _ = lunchAlert(question: "Observio", text: "You are on Lunch!", Token: usrToken, Id: usrId)
                            }else if pauseType == 0{
                                activityChceck()
                            }
                        }
                    }
                    
                    parameters["code"] = statusCode
                    controlMyStatus()
                }else{
                    print("error: \(String(describing: response.result.error)) cxxxxxddffdfvv")
                    Timer.after(3.second) {
                        controlMyStatus()
                    }
                }
            }
        }
        
        controlMyStatus()
        
        func deleteCookie(){
            let storage = HTTPCookieStorage.shared
            for cookie in storage.cookies! {
                storage.deleteCookie(cookie)
            }
        }
        
        
        
        
        
        func readJson(adresa: String) {
            URLSession.shared.dataTask(with: NSURL(string: adresa)! as URL, completionHandler: { (data, response, error) -> Void in
                // Check if data was received successfully
                if error == nil && data != nil {
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        
                    } catch {
                    }
                }
            }).resume()
        }
        
        //        //timer
        //        func twoSeconds(){
        //            //disable alert repeat
        //            _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
        //                (_) in
        //                if let cookies = HTTPCookieStorage.shared.cookies {
        //                    for cookie in cookies {
        //                        if cookie.name == "userToken"{
        //                            usrToken = cookie.value
        //                        }
        //                        if cookie.name == "userId"{
        //                            usrId = cookie.value
        //                        }
        //                    }
        //
        //                    for cookie in cookies {
        //                        if cookie.name == "activity"{
        //                            if cookie.value == "31" && showAlert == true{
        //
        //                                _ = breakAlert(question: "Observio", text: "You are on break!",Token: usrToken, Id: usrId)
        //                            }
        //                            if cookie.value == "32" && showAlert == true{
        //
        //                                _ = lunchAlert(question: "Observio", text: "You are on lunch!",Token: usrToken, Id: usrId)
        //                            }
        //                            if cookie.value == "11"{
        //                                activityChceck()
        //                            }
        //                            if cookie.value == "12"{
        //                                activityChceck()
        //                            }
        //                            else{
        //                                showAlert = true
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //
        //        }
        //        twoSeconds()
        //        let rndmNmbr = arc4random()
        //web adresa fullscreen
        let url = URL(string: "https://app.observio.org/?v=1234555087677778")
        let request = URLRequest(url: url!)
        //load webu do fullscreenframu
        
        webView.load(request)
        if NSAppKitVersion.current.rawValue > 1500 {
            webView.setValue(false, forKey: "drawsBackground")
        }
        else {
            webView.setValue(true, forKey: "drawsTransparentBackground")
        }
    }
}

extension QuotesViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> QuotesViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "QuotesViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? QuotesViewController else {
            fatalError("Error")
        }
        return viewcontroller
    }
}

