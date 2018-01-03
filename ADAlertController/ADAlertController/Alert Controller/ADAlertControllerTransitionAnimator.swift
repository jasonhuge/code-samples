//
//  ADAlertControllerTransitionAnimator.swift
//
//  Created by Jason Hughes on 11/8/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit

/// ADAlertController Animator for Presenting
class ADAlertControllerTransitionAnimatorForPresenting: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? ADAlertController else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        
        toVC.containerView.transform = CGAffineTransform(translationX: 0, y: 15)
        toVC.view.alpha = 0
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.setAnimationCurve(.easeOut)
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC.view.alpha = 1
                toVC.containerView.transform = .identity
            })
            
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

/// ADAlertController Animator for Dismissing
class ADAlertControllerTransitionAnimatorForDismissing: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ADAlertController else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromVC.view)
        
        fromVC.view.alpha = 1
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.setAnimationCurve(.easeOut)
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                fromVC.view.alpha = 0
                fromVC.containerView.transform = CGAffineTransform(translationX: 0, y: 15)
            })
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}



