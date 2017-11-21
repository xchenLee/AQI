//
//  SwipeupTransition.swift
//  AQIDemo
//
//  Created by danlan on 2017/10/10.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit

class SwipeVerticalTransition: UIPercentDrivenInteractiveTransition {
    
    var presenting: Bool = false
    var shouldComplete: Bool = false
    
    var contextData: UIViewControllerContextTransitioning?
    var iPanGesture: UIPanGestureRecognizer?
    
    var viewController: UIViewController?
    
//    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
//
//        // 文档说总是调用父类的
//        super.startInteractiveTransition(transitionContext)
//
//        //存起来后边用
//        //self.contextData = transitionContext
//    }
    
    public func prepareGesture(_ viewController: UIViewController) {
        
        self.viewController = viewController
        self.iPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        self.iPanGesture?.maximumNumberOfTouches = 1
        viewController.view.addGestureRecognizer(self.iPanGesture!)
    }
    
    func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        
        
        if gesture.state == .began {
            
            self.viewController?.dismiss(animated: true, completion: nil)
        } else if gesture.state == .changed {
            
            let translation = self.iPanGesture?.translation(in: gesture.view?.superview)
            let percentage = fabsf(Float((translation?.y)! / 400))
            
            self.shouldComplete = percentage > 0.5
            self.update(CGFloat(percentage))
            
        } else if gesture.state == .ended {
            
            if !self.shouldComplete {
                self.cancel()
            } else {
                self.finish()
            }
            //container?.removeGestureRecognizer(self.iPanGesture!)
        } else if gesture.state == .cancelled || gesture.state == .failed {
            
            self.cancel()
            //container?.removeGestureRecognizer(self.iPanGesture!)
        }
    }
    
    
    func handleDismiss(_ gesture: UIPanGestureRecognizer) {

    }
}



















