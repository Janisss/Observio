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

var usrToken:String = ""
var usrId:String = ""
var showAlert:Bool = true
var limit:Int = 0

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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        URLCache.shared.removeAllCachedResponses()
//        URLCache.shared.diskCapacity = 0
//        URLCache.shared.memoryCapacity = 0
        webView.reload()
        
        func deleteCookie(){
            let storage : HTTPCookieStorage = HTTPCookieStorage.shared
            for cookie in storage.cookies  as [HTTPCookie]!{
                storage.deleteCookie(cookie)
            }
        }
        
        func breakAlert(question: String, text: String, Token: String, Id: String) -> Bool {
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = text
            alert.alertStyle = .informational
            alert.icon = NSImage!(#imageLiteral(resourceName: "smoking"))
            alert.addButton(withTitle: "Continue Working...")
            if alert.runModal() == .alertFirstButtonReturn{
                if showAlert == true{
                    readJson(adresa: "https://observio.org/observio/public/api/tracking/mac/track?userToken=\(Token)&userId=\(Id)&data[activity]=4")
                    showAlert = false
                    deleteCookie()
                }
            }
            return true
        }
        
        func lunchAlert(question: String, text: String, Token: String, Id: String) -> Bool {
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = text
            alert.alertStyle = .informational
            alert.icon = NSImage!(#imageLiteral(resourceName: "lunch"))
            alert.addButton(withTitle: "Continue Working...")
                if alert.runModal() == .alertFirstButtonReturn{
                    readJson(adresa: "https://observio.org/observio/public/api/tracking/mac/track?userToken=\(Token)&userId=\(Id)&data[activity]=4")
                    showAlert = false
                    deleteCookie()
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
                        // print(str)
                        // hlavička print(response!)
                    } catch {
                    }
                }
            }).resume()
        }
        
        //timer
        func twoSeconds(){
            //disable alert repeat
            _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
                (_) in
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        if cookie.name == "userToken"{
                            usrToken = cookie.value
                        }
                        if cookie.name == "userId"{
                            usrId = cookie.value
                        }
                    }
                    
                    for cookie in cookies {
                        if cookie.name == "activity"{
                            if cookie.value == "31" && showAlert == true{
                                
                                _ = breakAlert(question: "Observio", text: "You are on break!",Token: usrToken, Id: usrId)
                            }
                            if cookie.value == "32" && showAlert == true{
                               
                                _ = lunchAlert(question: "Observio", text: "You are on lunch!",Token: usrToken, Id: usrId)
                            }
                            else{
                                showAlert = true
                            }
                        }
                    }
                }
                //print(cookie.name)
            }
            
        }
        twoSeconds()
//        let rndmNmbr = arc4random()
        //web adresa fullscreen
        let url = URL(string: "https://app.observio.org/?v=12345556666777777")
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

