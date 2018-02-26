//
//  CheckView.swift
//  FaceUnlock
//
//  Created by Ngmm_Jadon on 2018/2/26.
//  Copyright © 2018年 Ngmm_Jadon. All rights reserved.
//

import UIKit

class CheckView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width/4, y: frame.height*0.75))
        path.addLine(to: CGPoint(x: frame.width/2, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height/3))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }

}
