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
        var tabBarBackgroundColor: UIColor?
        var tabMinimumInteritemSpacing: CGFloat?
        var tabMinimumLineSpacing: CGFloat?
        var tabLeftContentInset: CGFloat = 20
        var tabRightContentInset: CGFloat = 20
        
        var selectedBarBackgroundColor = UIColor.black
        var selectedBarHeight: CGFloat = 2
        var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
        
        var tabItemBackgroundColor: UIColor?
        var tabItemFont = UIFont.systemFont(ofSize: 18)
        var tabItemLeftRightMargin: CGFloat = 8
        var tabItemTitleColor: UIColor?
        var tabItemsShouldFillAvailableWidth = true
        
        var tabItemSelectedLabelColor: UIColor = .black
        var tabItemUnselectedLabelColor: UIColor = .gray
        
        var tabHeight: CGFloat = 38
        
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
    func indicatorInfo(for tabDanceViewController: BasePagerViewController) -> TabIndicatorData
}


enum PagerBarItemSpec<CellType: UICollectionViewCell> {
    case cellClass(width:((TabIndicatorData)-> CGFloat))
    var weight: ((TabIndicatorData) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        }
    }
}

enum PagerTabStripBehaviour {

    case common(skipIntermediateViewControllers: Bool)
    case progressive(skipIntermediateViewControllers: Bool, elasticIndicatorLimit: Bool)

    public var skipIntermediateViewControllers: Bool {
        switch self {
        case .common(let skipIntermediateViewControllers):
            return skipIntermediateViewControllers
        case .progressive(let skipIntermediateViewControllers, _):
            return skipIntermediateViewControllers
        }
    }

    public var isProgressiveIndicator: Bool {
        switch self {
        case .common:
            return false
        case .progressive:
            return true
        }
    }

    public var isElasticIndicatorLimit: Bool {
        switch self {
        case .common:
            return false
        case .progressive(_, let elasticIndicatorLimit):
            return elasticIndicatorLimit
        }
    }
}


enum SwipeDirection {
    case left
    case right
    case none
}

enum PagerTabStripError: Error {

    case viewControllerOutOfBounds

}