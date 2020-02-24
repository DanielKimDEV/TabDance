//
//  TabExampleViewController.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import TabDance

class TabDanceExampleViewController: PagerBarTabStripViewController {
    
    var isReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylingViews()

    }
    
    func setViews() {
        
        
    }
    
    func stylingViews() {
        self.view.backgroundColor = .white
        self.title = "이모지 반응한 멤버"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        self.navigationItem.setLeftBarButton(closeButton, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: PagerBarViewCell?, newCell: PagerBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
        }
    }
    
    @objc
    func dismissVC() {
        self.dismiss(animated: true)
    }
    
    // PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = TableChildExampleViewController(style: .plain, itemInfo: "😍 999")
        let child_2 = TableChildExampleViewController(style: .plain, itemInfo: "🤗 56")
        let child_3 = TableChildExampleViewController(style: .plain, itemInfo: "🤑 9999")
        let child_4 = TableChildExampleViewController(style: .plain, itemInfo: "👍 929939")
        let child_5 = TableChildExampleViewController(style: .plain, itemInfo: "🙌 112939")
        let child_6 = TableChildExampleViewController(style: .plain, itemInfo: "🙏 1230981209319283")
        let child_7 = TableChildExampleViewController(style: .plain, itemInfo: "👋 10")
        let child_8 = TableChildExampleViewController(style: .plain, itemInfo: "👌 1")
        
        let childViewControllers = [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8]
  
        return childViewControllers
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
}
