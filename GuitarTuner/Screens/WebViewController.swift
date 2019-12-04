//
//  WebViewController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 28/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var link : String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: link)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
//    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
//            guard let html = html as? String else { return }
//            let range = NSRange(location: 0, length: html.count)
//            let regex = try! NSRegularExpression(pattern: "<pre>[a-z0-9]{64}</pre>")
//            let match = regex.firstMatch(in: html, options: [], range: range)
//
//            guard let _match = match else { return }
//            let tokenStr = String(html[Range(_match.range, in: html)!])
//            let tokenRange = Range(NSRange(location: 5, length: 64), in: tokenStr)
//            UserDefaults.standard.set(String(tokenStr.substring(with: tokenRange!)), forKey: "token")
//            UserDefaults.standard.set(NSDate().timeIntervalSince1970, forKey: "tokenDate")
//        }
//    }
}




