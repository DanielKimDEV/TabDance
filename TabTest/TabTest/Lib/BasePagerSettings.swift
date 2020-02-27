//
//  BasePagerSettings.swift
//  BasePager
//
//  Created by Daniel Kim on 2020/02/24.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit

struct BasePagerSettings {
    struct BarStyle{
        var tabDanceBarBackgroundColor: UIColor?
        var tabDanceMinimumInteritemSpacing: CGFloat?
        var tabDanceMinimumLineSpacing: CGFloat?
        var tabDanceLeftContentInset: CGFloat = 20
        var tabDanceRightContentInset: CGFloat = 20
        
        var selectedBarBackgroundColor = UIColor.black
        var selectedBarHeight: CGFloat = 2
        var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
        
        var tabDanceItemBackgroundColor: UIColor?
        var tabDanceItemFont = UIFont.systemFont(ofSize: 18)
        var tabDanceItemLeftRightMargin: CGFloat = 8
        var tabDanceItemTitleColor: UIColor?
        var tabDanceItemsShouldFillAvailableWidth = true
        
        var tabDanceItemSelectedLabelColor: UIColor = .black
        var tabDanceItemUnselectedLabelColor: UIColor = .gray
        
        var tabDanceHeight: CGFloat = 38
        
        var pagerBottomBarUnderLine: Bool = false
        var pagerBottomBarUnderLineColor: UIColor = .white
        var pagerBottomBarUnderLineHeight: CGFloat = 1
        
        var pagerBounce: Bool = false
    }
    
    struct ContentStyle {
        var contentViewBackgroundColor:UIColor = .white
        var currentIndex = 0
        var infinitiScroll = false
    }
    
    var barStyle = BarStyle()
    var contentStyle = ContentStyle()
}


protocol IndicatorInfoProvider: UIViewController {
    func indicatorInfo(for tabDanceViewController: BasePagerViewController) -> TabIndicatorInfo
    var tabDanceBarHeight:CGFloat { get set }
}

extension IndicatorInfoProvider {
    func setTableViewTopInsets(tableView:UITableView) {
        tableView.contentInset = UIEdgeInsets(top: tabDanceBarHeight, left: 0, bottom: 0, right: 0)
    }
}

enum PagerBarItemSpec<CellType: UICollectionViewCell> {
    case cellClass(width:((TabIndicatorInfo)-> CGFloat))
    var weight: ((TabIndicatorInfo) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        }
    }
}
