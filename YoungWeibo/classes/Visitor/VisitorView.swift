//
//  VisitorView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/10.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func visitorView() -> VisitorView {
        
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
        
    }

    // MARK: -xib里的控件
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    /// 给xib控件设值
    ///
    /// - Parameters:
    ///   - imageName: 图标的名字
    ///   - title: 提示语
    func setupVisitorViewInfo(_ imageName : String , title : String) {
        iconImg.image = UIImage.init(named: imageName)
        tipLab.text = title
        rotationView.isHidden = true
    }

    
    
    func setVisitorViewAnim() {
    
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = M_PI * 2
        anim.repeatCount = MAXFLOAT
        anim.duration = 6.0
        anim.isRemovedOnCompletion = false
        rotationView.layer.add(anim, forKey: nil)

    }
    
}






