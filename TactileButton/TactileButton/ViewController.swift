//
//  ViewController.swift
//  TactileButton
//
//  Created by Li Jiantang on 22/10/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

import UIKit

class ViewController: AnalyticsBasedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override var currentScreen: TrackingScreen? {
        get {
            return .IntroScreen1
        }
    }
    
    @IBAction func debounce(sender: UIButton) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            sender.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0)
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    sender.layer.transform = CATransform3DIdentity
                }, completion: { (finished) -> Void in
                        
                })
        })
    }
}