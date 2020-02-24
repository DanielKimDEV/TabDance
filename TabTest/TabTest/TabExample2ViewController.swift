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
import TabDance

class TabExample2ViewController : TabDanceViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
    }

}

extension TabExample2ViewController {
    
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
