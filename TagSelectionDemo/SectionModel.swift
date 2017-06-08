//
//  SectionModel.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/7.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit

class SectionModel: NSObject {

    var title : NSString!
    var cells : NSArray!
    var mutableCells : NSMutableArray!
    var userInfo : NSObject!

    class func section(title:NSString,cells:NSArray)->SectionModel{
        let section = SectionModel()
        section.title = title;
        section.cells = cells;
        return section
    }



}
