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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.contentStyle.infinitiScroll = false
        initViewControllers()
        settingStyling()

    }
    
    func settingStyling() {
        self.view.backgroundColor = .white
        self.title = "이모지 반응한 멤버"
        
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

}

extension TabExampleViewController {
    
    func initViewControllers() {
        
        self.dataSource = self
        self.delegate = self
        
        let child_1 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "😍 999")
        let child_2 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🤗 56")
        let child_3 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🤑 9999")
        let child_4 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👍 929939")
        let child_5 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🙌 112939")
        let child_6 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "🙏 1230981209319283")
        let child_7 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👋 10")
        let child_8 = EmojiReactionMemberTableViewController(style: .plain, itemInfo: "👌 1")
        
        let childViewControllers = [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8]
        self.arrViewControllers = childViewControllers
        
        if let firstViewController = arrViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}
