//
//  NavTitleButton.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/11.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class NavTitleButton: UIButton {

   
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        
        guard let width = titleLabel?.frame.size.width else {
            return
        }
        
        imageView?.frame.origin.x = width + 5
    }

}
