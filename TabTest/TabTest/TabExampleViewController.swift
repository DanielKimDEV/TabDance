//
//  TabExample2ViewController.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/24.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TabExampleViewController : BasePagerViewController {
    
    
    var isReload = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.contentStyle.infinitiScroll = false
        settingStyling()

    }
    
    func settingStyling() {
        self.view.backgroundColor = .white
        self.title = "이모지 반응한 멤버"
        var customSettings = BasePagerSettings()
        let inset :CGFloat = 20
        customSettings.barStyle.tabDanceBarBackgroundColor = .white
        customSettings.barStyle.tabDanceLeftContentInset = inset
        customSettings.barStyle.tabDanceRightContentInset = inset
        customSettings.barStyle.tabDanceHeight = 38
        customSettings.barStyle.tabDanceMinimumInteritemSpacing = 24
        customSettings.barStyle.tabDanceItemLeftRightMargin = 0
        
        settings = customSettings
        
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.setLeftBarButton(closeButton, animated: true)
        
        changeCurrentIndexProgressive = {
            (oldCell: BasePagerViewCell?, newCell: BasePagerViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
       }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    
    override func viewControllers(for pagerTabStripController: BasePagerStripViewController) -> [UIViewController] {
           

           let child_1 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "😍 999")
           let child_2 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🤗 56")
           let child_3 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🤑 9999")
           let child_4 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👍 929939")
           let child_5 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🙌 112939")
           let child_6 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🙏 1230981209319283")
           let child_7 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👋 10")
           let child_8 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👌 1")
           
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

