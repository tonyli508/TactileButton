//
//  AnalyticsBasedViewController.swift
//  TactileButton
//
//  Created by Li Jiantang on 22/10/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

import UIKit

/**
 AnalyticsTrackingDelegate
 
 For where to record your trackings
 */
protocol AnalyticsTrackingDelegate: class {
    func track(event: AnalyticsTrackingService.TrackingEvent, trackingData: AnalyticsTrackingDataConvertible?, inScreen: TrackingScreen?)
}

/** AnalyticsBasedViewController

- Just override currentScreen name, then will trigger page hit automatically
- Override trackingData if you need send some custom tracking data
*/
public class AnalyticsBasedViewController: UIViewController, AnalyticsDataProvider {
    
    weak var delegate: AnalyticsTrackingDelegate?
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.track(.PageHit)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /// default implementation for screen name, override this
    public var currentScreen: TrackingScreen? {
        get {
            return nil
        }
    }
    
    /// default implementation for event type, override this
    public var eventType: TrackingEvent? {
        get {
            return nil
        }
    }
    
    /// default implementation for tracking data, override this
    public var trackingData: AnalyticsTrackingDataConvertible? {
        get {
            return nil
        }
    }
    
    private func analyticsWarning() {
        print("You need to override func `currentScreenName` in viewDidLoad to use AnalyticsBasedViewController!!!! [View-Controller-Name: \(self.classForCoder)]")
    }
    
    /**
     Analytics track
     
     :param: event        event type
     :param: trackingData tracking data
     */
    func track(event: AnalyticsTrackingService.TrackingEvent, trackingData: AnalyticsTrackingDataConvertible? = nil) {
        
        if let screen = self.currentScreen {
            // tracking event
            print("event - \(event) triggered in screen - \(screen)")
        } else {
            analyticsWarning()
        }
    }
}
