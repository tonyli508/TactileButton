//
//  TactileButton.swift
//  Ridepool
//
//  Created by Li Jiantang on 15/06/2015.
//  Copyright (c) 2015 Carma. All rights reserved.
//

import UIKit

@IBDesignable
public class TactileButton: UIButton, AnalyticsDataProvider {
    
    private static var exclusiveTapExecutingFlag = false
    
    private var executingFlagLocker = NSLock()
    
    // iOS 7 wrap with container and center constrain, if already did set to true
    private var alreadyWrapViewInContainer = false
    
    /// target events array
    private var touchUpInsideTargets = [TouchUpInsideEvent]()
    
    /// wrap touch up insdie event with target and selector
    class TouchUpInsideEvent {
        var selector: String
        weak var target: AnyObject?
        
        init(Target: AnyObject?, Selector: String) {
            target = Target
            selector = Selector
        }
        
        deinit {
            target = nil
        }
    }
    
    // MARK: - initializations
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.config()
    }
    
    public required init(eventType: TrackingEvent) {
        super.init(frame: CGRectZero)
        
        self.eventType = eventType
        
        self.config()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.config()
    }
    
    /**
     initial config
     */
    private func config() {
        self.addTactileEvents()
    }
    
    /**
     add debounce effect
     */
    private func addTactileEvents() {
        super.addTarget(self, action: #selector(performPressedEffect), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: - Handle events
    
    /**
    Rewrite add target to achieve the required debounce effect for TouchUpInside event, for others do default behavior
    
    :param: target        Target
    :param: action        Selector
    :param: controlEvents Event type
    */
    public override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        if controlEvents == UIControlEvents.TouchUpInside {
            
            removeTouchUpInsideTarget(target, action: action)
            touchUpInsideTargets.append(TouchUpInsideEvent(Target: target, Selector: String(_sel: action)))
            
        } else {
            super.addTarget(target, action: action, forControlEvents: controlEvents)
        }
    }
    
    /**
     Remove touch up inside target from array
     
     :param: target Target
     :param: action Selector
     */
    private func removeTouchUpInsideTarget(target: AnyObject?, action: Selector) {
        
        var found = -1
        
        for (index, _eventTarget) in touchUpInsideTargets.enumerate() {
            
            if target === _eventTarget.target && _eventTarget.selector == String(_sel: action) {
                
                found = index
                
                break
            }
        }
        
        if found != -1 {
            touchUpInsideTargets.removeAtIndex(found)
        }
    }
    
    /**
     Remove target from TouchUpInside event array, for other events do default behavior
     
     :param: target        Target
     :param: action        Selector
     :param: controlEvents Event type
     */
    public override func removeTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        
        if controlEvents == UIControlEvents.TouchUpInside {
            
            self.removeTouchUpInsideTarget(target, action: action)
            
        } else {
            
            super.removeTarget(target, action: action, forControlEvents: controlEvents)
        }
    }
    
    /**
     Perform debounce effect
     */
    func performPressedEffect() {
        
        if !TactileButton.exclusiveTapExecutingFlag {
            
            if executingFlagLocker.tryLock() {
                TactileButton.exclusiveTapExecutingFlag = true
                executingFlagLocker.unlock()
            }
            
            UIView.animateWithDuration(0.1, animations: { [unowned self] () -> Void in
                
                self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0)
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.layer.transform = CATransform3DIdentity
                    }, completion: { (finished) -> Void in
                        self.triggerTouchUpInsideEvent()
                    })
            })
            
            if let eventName = self._eventType {
                analyticsContainerDelegate?.track(eventName)
            }
        }
    }
    
    /**
     Trigger registered custom TouchUpInsdie events in the array
     */
    private func triggerTouchUpInsideEvent() {
        
        for _eventTarget in touchUpInsideTargets {
            
            if let target: AnyObject = _eventTarget.target {
                NSTimer.scheduledTimerWithTimeInterval(0, target: target, selector: Selector(_eventTarget.selector), userInfo: nil, repeats: false)
            }
        }
        
        unlockButtons()
    }
    
    private func unlockButtons(retryCount: Int = 0) {
        
        // dispatch on the main queue
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1)), dispatch_get_main_queue()) { [unowned self] () -> Void in
            if self.executingFlagLocker.tryLock() {
                TactileButton.exclusiveTapExecutingFlag = false
                self.executingFlagLocker.unlock()
            } else {
                let retriedCount = retryCount + 1
                if retriedCount < 4 {
                    self.unlockButtons(retriedCount)
                } else {
                    // just to be safe let them tap two simultaneously this time
                    TactileButton.exclusiveTapExecutingFlag = false
                }
            }
        }
    }
    
    deinit {
        TactileButton.exclusiveTapExecutingFlag = false
        touchUpInsideTargets.removeAll(keepCapacity: false)
    }
    
    // - MARK: AnalyticsDataProvider
    
    private var _eventType: TrackingEvent?
    
    @IBInspectable
    var trackingEventType: String {
        
        set (_newEventType) {
            _eventType = TrackingEvent(rawValue: _newEventType)
        }
        
        get {
            if let _eventType = self._eventType {
                return _eventType.rawValue
            } else {
                return ""
            }
        }
    }
    
    // father container delegate to get the screen name
    @IBOutlet var analyticsContainerDelegate: AnalyticsBasedViewController?
    
    /// default implementation for screen name, override this
    public var currentScreen: TrackingScreen? {
        get {
            return analyticsContainerDelegate?.currentScreen
        }
    }
    
    /// default implementation for event type, override this
    public var eventType: TrackingEvent? {
        get {
            return nil
        }
        
        set(newType) {
            _eventType = newType
        }
    }
    
    /// default implementation for tracking data, override this
    public var trackingData: AnalyticsTrackingDataConvertible? {
        get {
            return nil
        }
    }
}



/// shorter name for TrackingScreen
public typealias TrackingScreen = AnalyticsTrackingService.TrackingScreen
/// shorter name for TrackingEvent
public typealias TrackingEvent = AnalyticsTrackingService.TrackingEvent

/**
 *  Analytics data provider
 */
public protocol AnalyticsDataProvider {
    
    /// screen name
    var currentScreen: TrackingScreen? {
        get
    }
    
    /// event type
    var eventType: TrackingEvent? {
        get
    }
    
    /// tracking data
    var trackingData: AnalyticsTrackingDataConvertible? {
        get
    }
}

