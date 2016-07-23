//
//  SecondViewController.swift
//  TactileButton
//
//  Created by Li Jiantang on 23/07/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

import UIKit

class SecondViewController: AnalyticsBasedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override var currentScreen: TrackingScreen? {
        get {
            return .IntroScreen2
        }
    }

}
