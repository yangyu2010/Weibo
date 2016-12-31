//
//  YoungPresentationContr.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/11.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class YoungPresentationContr: UIPresentationController {

    var presentedFrame : CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        
        //containerView 容器view

        presentedView?.frame = presentedFrame
        
        setupCoverView()
    }
}

// MARK: -设置ui界面
extension YoungPresentationContr {

    fileprivate func setupCoverView() {
    
        let coverView = UIView()
        
        coverView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.3)
        
        coverView.frame = (containerView?.bounds)!
        
        containerView?.addSubview(coverView)

        //给view添加手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(coverViewTapClick))
        
        coverView.addGestureRecognizer(tap)
    }
}


// MARK: -事件监听
extension YoungPresentationContr {

    @objc fileprivate func coverViewTapClick() {
    
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
