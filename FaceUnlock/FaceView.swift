//
//  FaceView.swift
//  FaceUnlock
//
//  Created by Ngmm_Jadon on 2018/2/26.
//  Copyright © 2018年 Ngmm_Jadon. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var distanceBetweenEyes: CGFloat = 100
    var eyesRadius: CGFloat = 15
    
    var mouseHorizontalPadding: CGFloat = 45
    var mouseVerticalPadding: CGFloat = 120
    var mouseBottomPadding: CGFloat = 150
    
    private var smileParameter: CGFloat = 0
    private var currentMouseLayer: CAShapeLayer?
    
    func updateSmile(parameter: CGFloat) {
        smileParameter = parameter
        createMouse()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        createFaceContour()
        createEyes()
        createMouse()
    }
    
    private func createShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        
        return shapeLayer
    }
    
    private func createFaceContour() {
        let faceContourPath = UIBezierPath(ovalIn: bounds)
        let shapeLayerForFaceCountour = createShapeLayer()
        shapeLayerForFaceCountour.path = faceContourPath.cgPath
        layer.addSublayer(shapeLayerForFaceCountour)
    }
    
    private func createEyes() {
        let leftEyeCenter = CGPoint(x: frame.width/2 - distanceBetweenEyes/2,
                                    y: frame.height/3)
        let leftEyePath = UIBezierPath(arcCenter: leftEyeCenter,
                                       radius: eyesRadius,
                                       startAngle: 0,
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        let shapeLayerForLeftEye = createShapeLayer()
        shapeLayerForLeftEye.path = leftEyePath.cgPath
        layer.addSublayer(shapeLayerForLeftEye)
        
        let rightEyeCenter = CGPoint(x: frame.width/2 + distanceBetweenEyes/2,
                                     y: frame.height/3)
        let rightEyePath = UIBezierPath(arcCenter: rightEyeCenter,
                                        radius: eyesRadius,
                                        startAngle: 0,
                                        endAngle: CGFloat(Double.pi * 2),
                                        clockwise: true)
        let shapeLayerForRightEye = createShapeLayer()
        shapeLayerForRightEye.path = rightEyePath.cgPath
        layer.addSublayer(shapeLayerForRightEye)
    }
 
    private func createMouse() {
        if let previousLayer = currentMouseLayer {
            previousLayer.removeFromSuperlayer()
        }
        
        let lipsPath = UIBezierPath()
        let leftLipsPoint = CGPoint(x: mouseHorizontalPadding, y: frame.height-mouseVerticalPadding)
        lipsPath.move(to: leftLipsPoint)
        
        let rightLipsPoint = CGPoint(x: frame.width-mouseHorizontalPadding, y: frame.height-mouseVerticalPadding)
        let bottomLipsPoint = CGPoint(x: frame.width/2, y: frame.height-mouseVerticalPadding+mouseBottomPadding*smileParameter)
        lipsPath.addQuadCurve(to: rightLipsPoint, controlPoint: bottomLipsPoint)
        
        currentMouseLayer = createShapeLayer()
        currentMouseLayer!.path = lipsPath.cgPath
        
        layer.addSublayer(currentMouseLayer!)
    }

}
