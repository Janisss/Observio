//
//  alerts.swift
//  prd
//
//  Created by Jan Catlos on 07/05/2018.
//  Copyright © 2018 Jan Catlos. All rights reserved.
//

import Foundation
import AppKit
import Alamofire

var showMe : Bool = true

func breakAlert(question: String, text: String, Token: String, Id: String) -> Bool {
    
    let parameters: Parameters = [
        "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
        "userToken" : usrToken,
        "userId" : usrId,
        "data": ["activity" : "4"]
    ]
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .informational
    alert.icon = NSImage?(#imageLiteral(resourceName: "smoking"))
    alert.addButton(withTitle: "Continue Working...")
    if alert.runModal() == .alertFirstButtonReturn{
            Alamofire.request("https://observio.org/observio/public/api/tracking", method: .post, parameters: parameters ).validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("JSON SEND OK!")
                    case .failure(let error):
                        print(error)
                    }
            }
}
    return true
}


func lunchAlert(question: String, text: String, Token: String, Id: String) -> Bool {
    let parameters: Parameters = [
        "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
        "userToken" : usrToken,
        "userId" : usrId,
        "data": ["activity" : "4"]
    ]
    
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .informational
    alert.icon = NSImage?(#imageLiteral(resourceName: "lunch"))
    alert.addButton(withTitle: "Continue Working...")
    if alert.runModal() == .alertFirstButtonReturn{
        Alamofire.request("https://observio.org/observio/public/api/tracking", method: .post, parameters: parameters ).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("JSON SEND OK!")
                case .failure(let error):
                    print(error)
                }
        }
    }
    return true
}

func cusomAlert(question: String, text: String, Token: String, Id: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .informational
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    
    let r = alert.runModal()
    switch r {
    case .alertFirstButtonReturn:
        let parameters: Parameters = [
            "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
            "userToken" : usrToken,
            "userId" : usrId,
            "alert": ["code" : ["status": true , "value" : "1"]]
        ]
        Alamofire.request("https://observio.org/observio/public/api/tracking/Ping", method: .post, parameters: parameters ).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("JSON SEND OK!")
                case .failure(let error):
                    print(error)
                }
        }
    default:
        let parameters: Parameters = [
            "appToken" :  "4c7090241b7c7577037b2da6c07bf74bc09d2a2a",
            "userToken" : usrToken,
            "userId" : usrId,
            "alert": ["code" : ["status": false , "value" : "1"]]
        ]
        Alamofire.request("https://observio.org/observio/public/api/tracking/Ping", method: .post, parameters: parameters ).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("JSON SEND OK!")
                case .failure(let error):
                    print(error)
                }
        }
    }
    return true
}
