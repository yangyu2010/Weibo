//
//  ComposeTitleView.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/17.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    //懒加载属性
    fileprivate lazy var titleLab : UILabel = UILabel()
    fileprivate lazy var nameLab : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: -设置UI界面
extension ComposeTitleView {

    fileprivate func setupUI() {
    
        addSubview(titleLab)
        addSubview(nameLab)
        
        titleLab.text = "发微博"
        nameLab.text = UserAccountViewModel.shareIntance.account?.screen_name
        
        titleLab.font = UIFont.systemFont(ofSize: 15.0)
        nameLab.font = UIFont.systemFont(ofSize: 12.0)
        nameLab.textColor = UIColor.lightGray
        
        titleLab.textAlignment = .center
        nameLab.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLab.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(3)
            make.centerX.equalTo(self)
        }
    }
    
}



