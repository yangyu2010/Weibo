//
//  PhotoBrowserAnimator.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/3.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {

    var isPresented : Bool = false
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        if isPresented {
//            presentedViewAnimate(transitionContext: transitionContext)
//        }else {
//            dismissedViewAnimate(transitionContext: transitionContext)
//        }

        isPresented ? presentedViewAnimate(transitionContext: transitionContext) : dismissedViewAnimate(transitionContext: transitionContext)
    }
    
    
    fileprivate func presentedViewAnimate(transitionContext: UIViewControllerContextTransitioning) {
    
        //1.取出要弹出来的view
        let presentedView = transitionContext.view(forKey: .to)!
        
        //2.添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //3.执行动画
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func dismissedViewAnimate(transitionContext: UIViewControllerContextTransitioning) {
    
        let dismissView = transitionContext.view(forKey: .from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView?.alpha = 0.0
        }) { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
}
