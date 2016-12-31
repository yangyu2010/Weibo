//
//  PopoverAnimaor.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/11.
//  Copyright © 2016年 杨羽. All rights reserved.
//  

import UIKit

class PopoverAnimaor: NSObject {

    fileprivate var isPresented = false
    
    var presentedFrame : CGRect = CGRect.zero
 
    var animationChangedBlock : ((Bool) -> ())?
 
    
    init(changedBlock : ((Bool) -> ())?) {
        animationChangedBlock = changedBlock
    }
}


// MARK: -自定义转场代理
extension PopoverAnimaor : UIViewControllerTransitioningDelegate {
    
    //改变转场view大小
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        //要改变转场容器view的大小 得自定义UIPresentationController
        let presentation = YoungPresentationContr(presentedViewController: presented, presenting: presenting)
        
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    //自定义出现动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        
        animationChangedBlock!(isPresented)
        
        return self
    }
    
    //自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        animationChangedBlock!(isPresented)
        
        return self
    }
    
}


// MARK: -设置转场出现和消失的动画
extension PopoverAnimaor : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    
    //自定义出现动画
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        //先拿到要做动画的view
        //UITransitionContext From ViewKey 消失的view
        //UITransitionContext To ViewKey 弹出的view
        let presentedView = transitionContext.view(forKey:.to)!
        
        //拿到 containerView
        transitionContext.containerView.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.0)
        
        UIView .animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            presentedView.transform = CGAffineTransform.identity
            
        }) { (_) in
            //必须告诉上下文 动画已经完成
            transitionContext.completeTransition(true)
        }
    }
    
    //消失动画
    fileprivate func animationForDismissView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let dismissView = transitionContext.view(forKey:.from)!
        
        UIView .animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            dismissView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.01)
            
        }) { (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
