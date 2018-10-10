//
//  activity_chceck.swift
//  prd
//
//  Created by Jan Catlos on 03/05/2018.
//  Copyright © 2018 Jan Catlos. All rights reserved.
//
import Cocoa
import Foundation
import SwiftyTimer
import WebKit
import AppKit
import Alamofire

var currentDateTime : Double = 0
var newBreakTime : Double = 0
var breakTime : Int = 0


func activityChceck(){
    var currentMouse = NSEvent.mouseLocation
    print(currentMouse)
    Timer.every(5.seconds) {
        print(currentMouse)
        print(",,,")
        if currentMouse == NSEvent.mouseLocation{
            
            if workActivity == 1{
                currentDateTime = Date().timeIntervalSince1970
                _ = forgotBreak(activity: "3", type: "1",question: "Observio", text: "No activity, do you forgot to use break?  \n", Token: usrToken, Id: usrId)
            }
        }
            currentMouse = NSEvent.mouseLocation
    }
}




//alert
func forgotBreak(activity : String,type: String, question: String, text: String, Token: String, Id: String) -> Bool {
    
    var parameters: Parameters = [
        "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
        "userToken" : usrToken,
        "userId" : usrId,
        "data": ["activity" : activity,
                 "type" : type,
                 "breakTime" : 0
                ]
    ]
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Yes, go to break")
    alert.addButton(withTitle: "No its okay")
    if alert.runModal() == .alertFirstButtonReturn{
        newBreakTime = Date().timeIntervalSince1970
        
        breakTime = Int((newBreakTime - currentDateTime) + (180 * 2))
        parameters["data"] = ["activity" : activity,
                              "type" : type,
                              "breakTime" : breakTime
        ]
        print(breakTime)
            Alamofire.request("https://observio.org/observio/public/api/tracking", method: .post, parameters: parameters )
    }else{
        activityChceck()
    }
    return true
}

func readJson(adresa: String) {
    URLSession.shared.dataTask(with: NSURL(string: adresa)! as URL, completionHandler: { (data, response, error) -> Void in
        // Check if data was received successfully
        if error == nil && data != nil {
            do {
                _ = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                // Access specific key with value of type String
                // let str = json["sha1"] as! String
            } catch {
            }
        }
    }).resume()
}
