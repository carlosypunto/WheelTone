//
//  ViewController.swift
//  WheelTone
//
//  Created by Simon Gladman on 25/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var firstWheelWidget: WheelWidget!
    let conductor = Conductor()
 
    var previuosPanOrigin: CGPoint?
    var previousPinchRadius: CGFloat?
    var rotatedWidgets = [WheelWidget]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        firstWheelWidget = WheelWidget(radius: 100, origin: CGPointZero, conductor: conductor)
        firstWheelWidget.origin = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        firstWheelWidget.frequency = WheelWidget.getFrequencyForRadius(100)
        view.layer.addSublayer(firstWheelWidget)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinchHandler:")
        view.addGestureRecognizer(pinch)
    
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:")
        pan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        view.addGestureRecognizer(longPress)
    }
    
    var selectedWheelWidget: WheelWidget?
    {
        didSet
        {
            oldValue?.selected = false
            selectedWheelWidget?.selected = true
        }
    }
    
    func start()
    {
        let timer = CADisplayLink(target: self, selector: Selector("step"))
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func step()
    {
        firstWheelWidget.rotation += 0.025

        rotatedWidgets = [WheelWidget]()
        
        updateAdjacentWheelWidgets(firstWheelWidget, angle: firstWheelWidget.rotation)
    }
    
    func updateAdjacentWheelWidgets(sourceWidget: WheelWidget, angle: CGFloat)
    {
        rotatedWidgets.append(sourceWidget)
        
        for sublayer in view.layer.sublayers!
        {
            if let targetWidget = sublayer as? WheelWidget where
                                    rotatedWidgets.indexOf(targetWidget) == nil &&
                                    targetWidget != sourceWidget && abs(sourceWidget.origin.distance(targetWidget.origin) - (sourceWidget.radius + targetWidget.radius)) < 8
            {
                let newAngle = -angle * (sourceWidget.radius / targetWidget.radius)
                
                targetWidget.rotation = newAngle

                updateAdjacentWheelWidgets(targetWidget, angle: newAngle)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let locationInView = touches.first?.locationInView(view)
        {
            selectedWheelWidget = getWheelWidgetAtLocation(locationInView)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        selectedWheelWidget = nil
    }
    
    func panHandler(recognizer: UIPanGestureRecognizer)
    {
        let locationInView = recognizer.locationInView(view)
        
        switch recognizer.state
        {
        case .Began:
            selectedWheelWidget = getWheelWidgetAtLocation(locationInView)
            
            previuosPanOrigin = locationInView
        case .Changed:
            selectedWheelWidget?.origin.x = (selectedWheelWidget?.origin.x)! + locationInView.x - previuosPanOrigin!.x
            selectedWheelWidget?.origin.y = (selectedWheelWidget?.origin.y)! + locationInView.y - previuosPanOrigin!.y
            
            previuosPanOrigin = locationInView
        default:
            selectedWheelWidget = nil
            previuosPanOrigin = nil
        }
    }

    func pinchHandler(recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state
        {
        case .Began:
            selectedWheelWidget = getWheelWidgetAtLocation(recognizer.locationInView(view))
            
            if selectedWheelWidget == nil && recognizer.numberOfTouches() == 2
            {
                selectedWheelWidget = getWheelWidgetAtLocation(recognizer.locationOfTouch(1, inView: self.view))
            }
            
            previousPinchRadius = selectedWheelWidget?.radius
        case .Changed:
            selectedWheelWidget?.radius = previousPinchRadius! * recognizer.scale
        default:
            selectedWheelWidget = nil
            previousPinchRadius = nil
        }
    }
    
    func longPressHandler(recognizer: UILongPressGestureRecognizer)
    {
        switch recognizer.state
        {
        case .Began:
            if selectedWheelWidget == nil
            {
                let locationInView = recognizer.locationInView(view)
                let widget = WheelWidget(radius: 100, origin: locationInView, conductor: conductor)
                view.layer.addSublayer(widget)
                
                selectedWheelWidget = widget
            }
            else
            {
                if let selectedWheelWidget = selectedWheelWidget where selectedWheelWidget.frequency == nil
                {
                    selectedWheelWidget.frequency = WheelWidget.getFrequencyForRadius(selectedWheelWidget.radius)
                }
                else
                {
                    selectedWheelWidget?.frequency = nil
                }
                
            }
        default:
            selectedWheelWidget = nil
        }
    }
    
    func getWheelWidgetAtLocation(location: CGPoint) -> WheelWidget?
    {
        var returnValue: WheelWidget?
        
        for sublayer in view.layer.sublayers!
        {
            if let widget = sublayer as? WheelWidget where (location.distance(widget.origin) < widget.radius)
            {
                returnValue = widget
                
                break
            }
        }

        return returnValue
    }
    
}

