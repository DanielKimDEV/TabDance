//
//  TabDanceSettings.swift
//  TabDance
//
//  Created by Daniel Kim on 2020/02/24.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit

public protocol IndicatorInfoProvider:UIViewController {
    func indicatorInfo(for tabDanceViewController: TabDanceViewController) -> TabIndicatorInfo
    var tabDanceBarHeight:CGFloat { get set }
}

extension IndicatorInfoProvider {
    public func setTableViewTopInsets(tableView:UITableView) {
        tableView.contentInset = UIEdgeInsets(top: tabDanceBarHeight, left: 0, bottom: 0, right: 0)
    }
}

public enum PagerBarItemSpec<CellType: UICollectionViewCell> {
    case cellClass(width:((TabIndicatorInfo)-> CGFloat))
    public var weight: ((TabIndicatorInfo) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        }
    }
}


public struct TabDanceSettings {
    public struct BarStyle{
        public var tabDanceBarBackgroundColor: UIColor?
        public var tabDanceMinimumInteritemSpacing: CGFloat?
        public var tabDanceMinimumLineSpacing: CGFloat?
        public var tabDanceLeftContentInset: CGFloat = 20
        public var tabDanceRightContentInset: CGFloat = 20
        
        public var selectedBarBackgroundColor = UIColor.black
        public var selectedBarHeight: CGFloat = 2
        public var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
        
        public var tabDanceItemBackgroundColor: UIColor?
        public var tabDanceItemFont = UIFont.systemFont(ofSize: 18)
        public var tabDanceItemLeftRightMargin: CGFloat = 8
        public var tabDanceItemTitleColor: UIColor?
        public var tabDanceItemsShouldFillAvailableWidth = true
        
        public var tabDanceHeight: CGFloat = 38
        
        public var pagerBottomBarUnderLine: Bool = false
        public var pagerBottomBarUnderLineColor: UIColor = .white
        public var pagerBottomBarUnderLineHeight: CGFloat = 1
        
        public var pagerBounce: Bool = false
    }
    
    public struct ContentStyle {
        public var contentViewBackgroundColor:UIColor = .white
        public var currentIndex = 0
    }
    
    var barStyle = BarStyle()
    var contentStyle = ContentStyle()
}
