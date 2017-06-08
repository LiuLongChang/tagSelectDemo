//
//  TagModel.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/8.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit

class TagModel: NSObject {

    var id : Int!
    var title : NSString!
    var isSelect : Bool!

    init(id:Int,title:NSString,isSelect:Bool) {

        self.id = id;
        self.title = title;
        self.isSelect = isSelect;

    }


}
