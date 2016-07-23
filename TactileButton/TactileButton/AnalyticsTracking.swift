//
//  AnalyticsTracking.swift
//  TactileButton
//
//  Created by Li Jiantang on 22/10/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

import Foundation

/**
 *  Convert object to tracking data
 */
public protocol AnalyticsTrackingDataConvertible {
    
    /**
     Convert current object to the tracking data dictionary with JSON format
     
     - returns: tracking data dictionary with JSON format
     */
    func trackingData() -> [String: String]?
}

// MARK: - Be able to use dictionary as tracking data directly
extension NSDictionary: AnalyticsTrackingDataConvertible  {
    
    public func trackingData() -> [String: String]? {
        if let data = self as? [String: String] {
            return data
        }
        
        return nil
    }
}

extension NSError: AnalyticsTrackingDataConvertible {
    
    public func trackingData() -> [String: String]? {
        
        return ["error": self.localizedDescription]
    }
}

// MARK: - Screen names and tracking Events

public class AnalyticsTrackingService: NSObject {
    
    public override init() {
        super.init()
    }
    
    /**
     Track event
     
     - param screen:       Screen name
     - param event:        Event type name
     - param trackingData: Tracking data JSON format
     */
    public func track(screen: TrackingScreen?, event: TrackingEvent, trackingData: AnalyticsTrackingDataConvertible?) {
        
    }
    
    /**
     Tracking screen name
     
     */
    public enum TrackingScreen: String {
        
        case IntroScreen1 = "intro-1"
        case IntroScreen2 = "intro-2"
        case IntroScreen3 = "intro-3"
        case IntroScreen4 = "intro-4"
        case IntroScreen5 = "intro-5"
        case Signup = "signup"
    }
    
    /**
     Tracking event name
     
     */
    public enum TrackingEvent: String {
        
        case PageHit = "page-hit"
        case AppLaunch = "app-launch"
        case AppClose = "app-close"
        case ButtonClicked = "button-clicked"
    }
}
