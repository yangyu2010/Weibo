//
//  PhotoBrowserAnimator.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/3.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit

// MARK: -弹出动画的代理
protocol PhotoBrowserAnimatorPresentedDelegate : NSObjectProtocol {
    
    func startRectForPresented(indexPath : IndexPath) -> CGRect
    func endRectForPresented(indexPath : IndexPath) ->CGRect
    func imageViewForPresented(indexPath : IndexPath) -> UIImageView
}

// MARK: -消息动画的代理
protocol PhotoBrowserAnimatorDismissDelegate : NSObjectProtocol {

    func indexPathForDismiss() -> IndexPath
    func imageViewForDismiss() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {

    var isPresented : Bool = false
    var indexPath : IndexPath?
    var presentedDelegate : PhotoBrowserAnimatorPresentedDelegate?
    var dismissDelegate : PhotoBrowserAnimatorDismissDelegate?
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
        return 0.5
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
        
        let startRect = presentedDelegate.startRectForPresented(indexPath: indexPath)
        let imgView = presentedDelegate.imageViewForPresented(indexPath: indexPath)
        let endRect = presentedDelegate.endRectForPresented(indexPath: indexPath)
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
    
        guard let dismissDelegate = dismissDelegate ,let presentedDelegate = presentedDelegate else {
            return
        }
        
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview()
        
        let imgV = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(imgV)
        
        let indexPath = dismissDelegate.indexPathForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
           imgV.frame = presentedDelegate.startRectForPresented(indexPath: indexPath)
        }) { (_) in
            
            transitionContext.completeTransition(true)
        }
    }
    
}






