//
//  NavigationViewController.swift
//  ImpactHub
//
//  Created by Niklas on 15/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = false
        self.navigationBar.layer.borderColor = UIColor.white.cgColor
        self.navigationBar.layer.borderWidth = 3
        self.navigationBar.layer.shadowColor = UIColor(hexString: "f2f2f2").cgColor
        self.navigationBar.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 6.0
        self.navigationBar.layer.shadowOpacity = 1.0
        self.navigationBar.layer.masksToBounds = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
