//
//  PhotoBrowserAnimator.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/3.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit

protocol PhotoBrowserAnimatorPresentedDelegate : NSObjectProtocol {
    
    func startRect(indexPath : IndexPath) -> CGRect
    func endRect(indexPath : IndexPath) ->CGRect
    func imageView(indexPath : IndexPath) -> UIImageView
}

class PhotoBrowserAnimator: NSObject {

    var isPresented : Bool = false
    var presentedDelegate : PhotoBrowserAnimatorPresentedDelegate?
    var indexPath : IndexPath?
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
        
        isPresented ? presentedViewAnimate(transitionContext: transitionContext) : dismissedViewAnimate(transitionContext: transitionContext)
    }
    
    
    fileprivate func presentedViewAnimate(transitionContext: UIViewControllerContextTransitioning) {
    
        guard let presentedDelegate = presentedDelegate , let indexPath = indexPath else {
            return
        }
        
        //1.取出要弹出来的view
        let presentedView = transitionContext.view(forKey: .to)!
        
        //2.添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imgView = presentedDelegate.imageView(indexPath: indexPath)
        let endRect = presentedDelegate.endRect(indexPath: indexPath)
        transitionContext.containerView.addSubview(imgView)
        imgView.frame = startRect
        
        //3.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imgView.frame = endRect
        }) { (_) in
            imgView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = UIColor.clear
            presentedView.alpha = 1.0
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






