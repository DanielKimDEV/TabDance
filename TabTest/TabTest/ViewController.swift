//
//  ViewController.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var button: UIButton!
    var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUpLayout()
        setupStyling()
        // Do any additional setup after loading the view.
    }

}


extension ViewController {
    
    func setUpLayout() {
        button = UIButton()
        label = UILabel()
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        
        label.snp.makeConstraints{ m in
            m.centerX.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints{ m in
            m.top.equalTo(label.snp.bottom).offset(20)
            m.centerX.equalToSuperview()
            m.height.equalTo(32)
        }
        
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
    }
    
    func setupStyling() {
        button.setTitle("😤 Play Tab Dacne~ 😍", for: .normal)
        button.titleLabel?.textColor = UIColor.black
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setBackgroundColor(.gray, for: .selected)
        
        label.text = "TESTING TAB"
        label.textColor = .black

    }
    
    @objc
    func tapButton(_ btn: UIButton) {
        let tabDanceViewController = TabDanceExampleViewController()
        let inset :CGFloat = 20
        tabDanceViewController.pagerBarBackgroundColor = .white
        tabDanceViewController.pagerBarLeftContentInset = inset
        tabDanceViewController.pagerBarRightContentInset = inset
        tabDanceViewController.pagerBarHeight = 38
        tabDanceViewController.pagerBarMinimumInteritemSpacing = 24
        tabDanceViewController.pagerBarItemLeftRightMargin = 0
        let nvc = UINavigationController(rootViewController: tabDanceViewController)
        self.present(nvc, animated: true)
    }
    
    @objc
    func closeNavigation() {
        self.dismiss(animated: true)
    }
}


extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}





