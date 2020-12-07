//
//  TabBarController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 01.10.2020.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
        // Do any additional setup after loading the view.
        print("INFO: TabBarController is loaded with token \(UserSession.instance.token!)\n")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
