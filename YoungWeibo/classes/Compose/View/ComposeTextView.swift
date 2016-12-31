//
//  ComposeTextView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/17.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {

    lazy var placeHolderLab : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
}


// MARK: -设置UI界面
extension ComposeTextView {
    fileprivate func setupUI() {
    
        placeHolderLab.text = "分享新鲜事"
        placeHolderLab.textColor = UIColor.lightGray
        placeHolderLab.font = font
        addSubview(placeHolderLab)
        
        textContainerInset = UIEdgeInsetsMake(8, 6, 8, 6)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeHolderLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(8)
        }
    }
}
