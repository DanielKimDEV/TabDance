//  IndicatorInfo.swift
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit

struct TabIndicatorInfo {
    
    var title: String?
    var highlightedImage: UIImage?
    var accessibilityLabel: String?
    var userInfo: Any?
    
    init(title: String?) {
        self.title = title
        self.accessibilityLabel = title
    }
    
    init(title: String?, userInfo: Any? = nil) {
        self.title = title
        self.accessibilityLabel = title
        
        self.userInfo = userInfo
    }
    
    init(title: String?, accessibilityLabel:String?, userInfo: Any? = nil) {
        self.title = title
        self.accessibilityLabel = accessibilityLabel
        self.userInfo = userInfo
    }
}

extension TabIndicatorInfo : ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        title = value
        accessibilityLabel = value
    }
    
    init(extendedGraphemeClusterLiteral value: String) {
        title = value
        accessibilityLabel = value
    }
    
    init(unicodeScalarLiteral value: String) {
        title = value
        accessibilityLabel = value
    }
}
