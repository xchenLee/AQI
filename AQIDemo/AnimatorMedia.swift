//
//  AnimatorMedia.swift
//  AQIDemo
//
//  Created by danlan on 2017/9/28.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit

/**
 
 这个类是创建动画用的, 我看官方的一段示例代码是在 animateTransition:
 方法中，使用了 self.isPresenting
 
 
 //官方文档
 https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html#//apple_ref/doc/uid/TP40007457-CH16-SW1
 
 */

let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height

class AnimatorMedia: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var presenting: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    //这个方法最关键，最实际的动画效果，错略分为三步
    //1.拿到动画参数
    
    //2.用Core Animation 或者 UIViewAnimation 创建动画
    
    //3.清理， 完成transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        /**
         如何拿参数
             1.不要自己缓存数据或者从vc里边拿，
             2.要从transitionContext里边获取
             3.Presenting and dismissing view controllers有时包含了vc没有的东西
         */
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC   = transitionContext.viewController(forKey: .to)
        
        
        //除了vc的view，中间可能添加和删除很多别的控件
        //看猫身的代码，不用这个获取，直接拿VC的view
        var fromView = transitionContext.view(forKey: .from)
        var toView   = transitionContext.view(forKey: .to)
        
        
        /**
         把所有关键的子控件放到这里
         比如：presentation的时候，把presented viewcontroler's view 加到这里
         
         */
        let containerView = transitionContext.containerView
        
        
        //获取 要被添加或者删除的view的最终frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC!)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        
        var fromViewStartFrame = transitionContext.initialFrame(for: fromVC!)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
        
        // Always add the "to" view to the container.
        // And it doesn't hurt to set its start frame.
        
        /*if fromView == nil {
            //这样子好像不太好 ，会有问题
            //这篇文章也提到了
            //https://satanwoo.github.io/2015/11/12/Swift-UITransition-iOS8/
            fromView = fromVC?.view
        }
        
        if toView == nil {
            toView = toVC?.view
        }*/
        
        if self.presenting {
            // test_1
            //toViewStartFrame.origin.x = 0
            //toViewStartFrame.origin.y = containerView.frame.size.height
            
            // test_2
            toViewStartFrame = CGRect(x: 0, y: screenH, width: screenW, height: screenH)
            
        } else {
            // test_1
            //fromViewFinalFrame = CGRect(x: 0, y: containerView.frame.size.height, width: (toView?.frame.size.width)!, height: (toView?.frame.size.height)!)
            
            // test_2
            fromViewFinalFrame = CGRect(x: 0, y: screenH, width: screenW, height: screenH)
        }
        
        //containerView.addSubview(fromView!)
        //fromView?.frame = fromViewStartFrame
        
        containerView.addSubview((toVC?.view)!)
        toView?.frame = toViewStartFrame
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            if self.presenting {
                toView?.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
                
            } else {
                fromView?.frame = fromViewFinalFrame
            }
        }) { (finish) in
            
            let success = !transitionContext.transitionWasCancelled
            if ((self.presenting && !success) || (!self.presenting && success)) {
                //toView?.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
    }
    
    
    //稍后再做复杂动画
    //代码来自: http://www.open-open.com/lib/view/open1484621258313.html
    func initialTransform() -> CATransform3D {
        
        var transform = CATransform3DIdentity
        
        transform = CATransform3DTranslate(transform, 0, 0, -60)
        transform.m34 = 1 / -900
        transform = CATransform3DScale(transform, 0.95, 0.95, 1)
        transform = CATransform3DRotate(transform, CGFloat(10 / 180 * M_PI), 1, 0, 0)
        return transform
    }
    
}















