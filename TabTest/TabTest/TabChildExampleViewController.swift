//
//  TabChildExampleViewController.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import TabDance
import UIKit

class ChildExampleViewController: UIViewController, IndicatorInfoProvider {

    var itemInfo: IndicatorInfo = "View"

    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TabDance"

        view.addSubview(label)
        view.backgroundColor = .white

        
        label.snp.makeConstraints{ m in
            m.centerX.equalToSuperview()
        }
    }

    // IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


class TableChildExampleViewController: UITableViewController, IndicatorInfoProvider {

    let cellIdentifier = "Cell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")

    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.ID)
        
        tableView.estimatedRowHeight = 600.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        if blackTheme {
            tableView.backgroundColor = UIColor.white
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProvider.sharedInstance.postsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell,
            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return Cell() }

        cell.configureWithData(data)
        return cell
    }

    // IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
