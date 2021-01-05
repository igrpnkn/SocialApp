//
//  WebLoginViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import UIKit
import WebKit
import FirebaseDatabase

class WebLoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    private var userSessions = [FirebaseUserSession]()
    private let ref = Database.database().reference(withPath: "userSessions")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        let scope = VKScopeBitmask.all
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7676176"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "\(scope)"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
      
        webView.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension WebLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
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
        
        if let token = params["access_token"] {
            UserSession.instance.token = token
            print("\nINFO: Acctual user token is: \(UserSession.instance.token!)")
        }
        if let userID = params["user_id"] {
            UserSession.instance.userId = Int(userID)
            print("INFO: Acctual user ID is: \(UserSession.instance.userId!)")
            sendUserSessionToFirebase(userID: userID)
        }
        
        decisionHandler(.cancel)
//        let tbc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController") as! TabBarController
//        tbc.modalPresentationStyle = .fullScreen
//        present(tbc, animated: true, completion: nil)
        
        let controllerName: String = "TabBarController"
        guard
            let tbc = storyboard?.instantiateViewController(identifier: controllerName),
            let window = self.view.window
        else { return }
        window.rootViewController = tbc
    }
    
    func sendUserSessionToFirebase(userID: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let currentDate = dateFormatter.string(from: Date())
        let fbUserSession = FirebaseUserSession(authDate: currentDate, userID: UserSession.instance.userId!)
        let userRef = self.ref.child(userID)
        userRef.setValue(fbUserSession.toAnyObject())
    }
    
}
