//
//  Cell.swift
//  TabTest
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class Cell: UITableViewCell {
    
    static let ID = "Cell"
    
    var userImage: UIImageView!
    var userName: UILabel!
    var userTeam: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setViews()
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWithData(_ data: NSDictionary) {
        if let post = data["post"] as? NSDictionary, let user = post["user"] as? NSDictionary {
            userName.text = user["name"] as? String
            userTeam.text = post["text"] as? String
            
            let imgUrl = URL(string: (user["imageURL"] as? String)!)
            
            userImage.contentMode = .scaleAspectFill
            userImage.layer.masksToBounds = true
            userImage.layer.cornerRadius = 20
            userImage.kf.setImage(with: imgUrl!)
        }
    }

    func setViews()  {

        userImage = UIImageView()
        userName = UILabel()
        userTeam = UILabel()
        
        self.addSubview(userImage)
        self.addSubview(userName)
        self.addSubview(userTeam)

        
        userImage.layer.cornerRadius = 40.0
        
        userImage.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(9)
            m.left.equalToSuperview().offset(16)
            m.bottom.equalToSuperview().offset(-9)
            m.width.height.equalTo(42)
        }
        
        userName.snp.makeConstraints{ m in
            m.top.equalToSuperview().offset(12)
            m.left.equalTo(userImage.snp.right).offset(12)
            m.right.equalToSuperview().offset(91)
            m.height.equalTo(20)
        }
        
        userTeam.snp.makeConstraints{ m in
            m.top.equalTo(userName.snp.bottom).offset(-1)
            m.left.equalTo(userImage.snp.right).offset(12)
            m.right.equalToSuperview().offset(91)
            m.bottom.equalToSuperview().offset(-11)
        }
    }
    
    func setStyle() {
        userImage?.layer.cornerRadius = 30.0
        userTeam.text = nil
        userName.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        userName.textColor = .black
        backgroundColor = UIColor.white
    }
}
