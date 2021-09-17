//
//  AuthVKViewController.swift
//  SecondVkClient
//
//  Created by Ilona Skerberga on 20/08/2021.
//

import UIKit
import WebKit

class AuthVKViewController: UIViewController {
    
    var session = Session.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthVK()
        
        
    }
    
    @IBOutlet weak var webView: WKWebView!//{
    //        didSet{
    //            webView.navigationDelegate = self
    //        }
    //    }
    
    func loadAuthVK() {
        // constructor for url
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: "7548358"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.120")
        ]
        
        guard let url = urlConstructor.url  else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
}

extension AuthVKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // checking for the received address and receiving data from the url
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let token = params["access_token"], let userID = params["user_id"] {
            session.token = token
            session.userId = Int(userID)!
            
            decisionHandler(.cancel)
            
    }
}
}
