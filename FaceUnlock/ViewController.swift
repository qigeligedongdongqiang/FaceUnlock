//
//  ViewController.swift
//  FaceUnlock
//
//  Created by Ngmm_Jadon on 2018/2/26.
//  Copyright © 2018年 Ngmm_Jadon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addTestButton()
    }
    
    private func addTestButton() {
        let btn = UIButton(type: .custom)
        btn.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        btn.center = view.center
        btn.backgroundColor = UIColor.red
        btn.setTitle("点击开始识别", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }
    
    @objc private func btnAction() {
        if FaceUnlockViewController.isSupported {
            let vc = FaceUnlockViewController()
            vc.onSuccess = {
                self.dismiss(animated: true, completion: nil)
            }
            self.present(vc, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

