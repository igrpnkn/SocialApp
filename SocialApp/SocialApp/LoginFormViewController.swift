//
//  LoginFormViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 29.09.2020.
//

import UIKit

class LoginFormViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        loginField.delegate = self
        passwordField.delegate = self
        
        //Hide Bar on Login Form, to make it visible on next VC add string below with "false"
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func authorization() {
        let login = loginField.text!
        let password = passwordField.text!
        
        if login == "admin" && password == "1234" {
            print("Success!")
            
            let tbc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController") as! TabBarController
            
            tbc.modalPresentationStyle = .fullScreen
            present(tbc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(tbc, animated: true)
            
        } else {
            print("Access denied!")
            //performSegue(withIdentifier: "showError", sender: self)
            let alert = UIAlertController(title: "Error", message: "Authorization failed: invalid login or password.", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        authorization()
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        // getting keyboard size
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // aading bottom scroll equals keyboard height
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Hide Bar on Login Form, to make it visible on next VC add string below with "false"
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

}

extension LoginFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginField {
            passwordField.becomeFirstResponder()
        } else {
            authorization()
        }
        return true
    }
}
