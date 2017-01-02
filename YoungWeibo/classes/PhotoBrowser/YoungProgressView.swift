//
//  YoungProgressView.swift
//  YoungWeibo
//
//  Created by Young on 2017/1/2.
//  Copyright © 2017年 杨羽. All rights reserved.
//

import UIKit

class YoungProgressView: UIView {

    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLine(to: center)
        path.close()
        
        UIColor.init(white: 0.8, alpha: 0.7).setFill()
        
        path.fill()
    }

}
