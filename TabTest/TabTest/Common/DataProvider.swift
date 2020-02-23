//
//  DataProvider.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/21.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit

class DataProvider {
    static let sharedInstance = DataProvider()

    lazy var postsData: NSArray = {
        let jsonStr = """
[{"post":{"created_at":"2020-04-17T00:45:40.556Z","id":113,"text":"팀원 / EP iOS 개발자","user":{"id":9,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSy5DntZmLYZGYGHBuUvK0TFw99X0IxHe6FAOfQh5leuJ-WP0hF","name":"김석용 daniel.dev"}}},{"post":{"created_at":"2020-04-09T21:29:59.982Z","id":66,"text":"팀원 / EP Software Developer","user":{"id":7,"imageURL":"https://images.unsplash.com/photo-1509460913899-515f1df34fea?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"이준호 jun.ho"}}},{"post":{"created_at":"2020-04-09T17:58:41.704Z","id":42,"text":"팀원 / EP Software Developer","user":{"id":5,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTzJBvfzxOslUpSiumF_HOoKa230kXttcxMOaclKvTuoscF4Ip6","name":"장하권 nuguri.top"}}},{"post":{"created_at":"2020-04-03T20:21:32.119Z","id":84,"text":"팀원 / EP Software Developer","user":{"id":8,"imageURL":"https://images.unsplash.com/photo-1522609925277-66fea332c575?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"허수 showmaker.mid"}}},{"post":{"created_at":"2020-04-03T02:04:43.053Z","id":75,"text":"팀원 / EP Software Developer","user":{"id":8,"imageURL":"https://images.unsplash.com/photo-1522609925277-66fea332c575?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"허수 showmaker.mid"}}},{"post":{"created_at":"2020-04-02T03:48:56.381Z","id":26,"text":"팀원 / EP Software Developer","user":{"id":3,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSDXcAiPKC6wU_tli4NDGh3-wWJ_Yi5HI1hZkgGkhVPzP7IE9as","name":"전석재 shuka.world"}}},{"post":{"created_at":"2020-03-22T14:24:22.408Z","id":28,"text":"Homer, don't say that. The way I see it, if you raised three children who can knock out and hog tie a perfect stranger you must be doing something right.","user":{"id":3,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSDXcAiPKC6wU_tli4NDGh3-wWJ_Yi5HI1hZkgGkhVPzP7IE9as","name":"전석재 shuka.world"}}},{"post":{"created_at":"2020-03-21T08:39:20.764Z","id":48,"text":"팀원 / EP Software Developer","user":{"id":5,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTzJBvfzxOslUpSiumF_HOoKa230kXttcxMOaclKvTuoscF4Ip6","name":"장하권 nuguri.top"}}},{"post":{"created_at":"2020-03-20T02:44:28.075Z","id":78,"text":"Maybe, just once, someone will call me 'Sir' without adding, 'You're making a scene.'","user":{"id":8,"imageURL":"https://images.unsplash.com/photo-1522609925277-66fea332c575?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"허수 showmaker.mid"}}},{"post":{"created_at":"2020-03-03T19:02:56.032Z","id":72,"text":"팀원 / EP Software Developer","user":{"id":8,"imageURL":"https://images.unsplash.com/photo-1522609925277-66fea332c575?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"허수 showmaker.mid"}}},{"post":{"created_at":"2020-02-24T14:09:00.912Z","id":1,"text":"팀원 / EP Software Developer","user":{"id":1,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT3RKL-VDpFauMLaNAJtOr-Xs97BmpbEqgtrUF008C1gnyMNUY9","name":"Apu Nahasapeemapetilon"}}},{"post":{"created_at":"2020-02-16T19:09:55.062Z","id":76,"text":"팀원 / EP Software Developer","user":{"id":8,"imageURL":"https://images.unsplash.com/photo-1522609925277-66fea332c575?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60","name":"허수 showmaker.mid"}}},{"post":{"created_at":"2020-02-16T13:50:25.313Z","id":22,"text":"팀원 / EP Software Developer","user":{"id":3,"imageURL":"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSDXcAiPKC6wU_tli4NDGh3-wWJ_Yi5HI1hZkgGkhVPzP7IE9as","name":"전석재 shuka.world"}}}]
"""

        let jsonData = jsonStr.data(using: String.Encoding.utf8)
        let res = try! JSONSerialization.jsonObject(with: jsonData!, options: []) // swiftlint:disable:this force_try
        return res as! NSArray // swiftlint:disable:this force_cast
    }()
}

class NavController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

class TabBarController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}