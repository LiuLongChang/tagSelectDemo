//
//  TagSelectSectionHeaderView.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/8.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit
import SnapKit

class TagSelectSectionHeaderView: UICollectionReusableView {

    var titleLabel : UILabel! = nil


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func initialize(){

        self.backgroundColor = UIColor.clear
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.gray
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in

            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(45);

        }


    }

        
}
