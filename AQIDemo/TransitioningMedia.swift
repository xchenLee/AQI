//
//  TransitioningMedia.swift
//  AQIDemo
//
//  Created by danlan on 2017/9/28.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit

class TransitioningMedia: NSObject, UIViewControllerTransitioningDelegate {
    
    
    //实际动画效果类
    var animator = AnimatorMedia()
    var interact = SwipeVerticalTransition()
    
    //如果presented viewcontroller的 transitioningDelegate 设置了

    //1.UIKit 调用这个方法去拿到custom animator
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //用来标示是开启还是消失
        self.animator.presenting = true
        
        //self.interact.prepareGesture(presented)
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //用来标示是开启还是消失
        animator.presenting = false
        return animator
    }
    
    //2.如果custom animator不为空
    //  UIKit 会调用这个方法，看是否interactive animator是否可用，nil的话，就执行动画，不涉及用户交互
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        interact.presenting = true
        return nil
        
        //不为空
        //2.1 UIKit 调用 animator 的 transitionDuration:方法去获取duration
        
        //2.2 UIKit 调用适当的方法来开始动画
        
        //2.2.1 非可交互的动画 调用animator的animateTransition方法
        
        //2.2.3 可交互的动画 调用animator的startInteractiveTransition方法
        
        
        //2.3 UIKit 等待animator调用 context transitioning object的 completeTransition方法
        
        //2.3.1 自定义的animator在动画结束的时候，调用这个方法
        //      调用这个方法来结束 transition，并且可以让UIKit知道它可以调用
        //      presentViewController:animated:completion: 的completionHandler
        //      并且可以调用animator的 animationEnded:方法
        
    }
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        interact.presenting = false
        return interact
    }
    
}























