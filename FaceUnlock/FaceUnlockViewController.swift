//
//  FaceUnlockViewController.swift
//  FaceUnlock
//
//  Created by Ngmm_Jadon on 2018/2/26.
//  Copyright © 2018年 Ngmm_Jadon. All rights reserved.
//

import UIKit
import ARKit

enum FaceUnlockThemeColor {
    case blue
    case red
    case purple
    case other(UIColor)
}

class FaceUnlockViewController: UIViewController {

    /// 是否支持
    class var isSupported: Bool {
        return ARFaceTrackingConfiguration.isSupported
    }
    
    /// 成功回调
    var onSuccess: (() -> Void)?
    
    /// 成功音效
    var successSoundPlaying: (() -> Void)? = {
        AudioServicesPlaySystemSound(1075)
    }
    
    /// 成功判定条件
    var successCondition: CGFloat = 0.7
    
    /// 主题颜色
    var backgroundColor: FaceUnlockThemeColor = .purple
    
    private var titleLabel: UILabel!
    var titleText: String? = "你好，" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    private var subtitleLabel: UILabel!
    var subtitleText: String? = "微笑可以解锁哦~" {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }
    
    private var skipButton: UIButton!
    var skipButtonText: String? = "跳过" {
        didSet {
            skipButton.setTitle(skipButtonText, for: .normal)
        }
    }
    
    /// 是否已解锁
    var isUnlocked: Bool = false
    
    /// 笑脸
    lazy var smileView: FaceView! = {
        let faceView = FaceView()
        faceView.backgroundColor = UIColor.clear
        return faceView
    }()
    
    /// 对勾
    lazy var checkView: CheckView! = {
        let tempView = CheckView()
        tempView.backgroundColor = UIColor.clear
        tempView.alpha = 0.0
        return tempView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initMySubViews()
        layoutMySubViews()
        startFaceDistinguish()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMySubViews() {
        switch backgroundColor {
        case .blue:
            view.backgroundColor = UIColor(red: 67.0/255.0, green: 173.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        case .red:
            view.backgroundColor = UIColor(red: 255.0/255.0, green: 79.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        case .purple:
            view.backgroundColor = UIColor(red: 185.0/255.0, green: 81.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        case .other(let color):
            view.backgroundColor = color
        }
    
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = titleText
        view.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = subtitleText
        subtitleLabel.numberOfLines = 0
        view.addSubview(subtitleLabel)
        
        skipButton = UIButton()
        skipButton.layer.cornerRadius = 3.0
        skipButton.layer.borderColor = UIColor.white.cgColor
        skipButton.layer.borderWidth = 1.0
        skipButton.setTitle(skipButtonText, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .light)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        view.addSubview(skipButton)
        
        view.addSubview(smileView)
        view.addSubview(checkView)
    }
    
    private func layoutMySubViews() {
        titleLabel.frame = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: view.bounds.size.width, height: 50)
        smileView.frame = CGRect(x: 40, y: subtitleLabel.frame.maxY + 20, width: view.bounds.size.width - 80, height: view.bounds.size.width - 80)
        checkView.frame = CGRect(x: (view.bounds.size.width - 100) / 2.0, y: smileView.frame.maxY, width: 100, height: 100)
    }
    
    @objc private func skipAction() {
        
    }
    
    private func startFaceDistinguish() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        let sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.isHidden = true
        sceneView.delegate = self
    }

}

extension FaceUnlockViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let blendShapes = faceAnchor.blendShapes
        if let left = blendShapes[.mouthSmileLeft], let right = blendShapes[.mouthSmileRight] {
            let smileParameter = min(max(CGFloat(truncating: left), CGFloat(truncating: right))/successCondition, 1.0)
            DispatchQueue.main.async {
                self.smileView.updateSmile(parameter: smileParameter)
                if smileParameter == 1 {
                    if !self.isUnlocked {
                        self.isUnlocked = true
                        
                        self.successSoundPlaying?()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.checkView.alpha = 1.0
                        }, completion: { _ in
                            self.onSuccess?()
                        })
                    }
                }
            }
        }
    }
}
