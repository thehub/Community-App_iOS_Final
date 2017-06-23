//
//  AddPostViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 23/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }

    @IBAction func onCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            
        })
    }

}
