//  PagerTabStripOptions.swift
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation

public enum PagerTabStripBehaviour {

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
