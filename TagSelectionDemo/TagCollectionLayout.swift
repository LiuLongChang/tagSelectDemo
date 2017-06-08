//
//  TagCollectionLayout.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/7.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit


/*屏幕的高度*/
let Height = UIScreen.main.bounds.size.height
/*屏幕的宽度*/
let Width = UIScreen.main.bounds.size.width




class TagCollectionLayout: UICollectionViewFlowLayout {


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attributes : [UICollectionViewLayoutAttributes] = NSMutableArray.init(array: super.layoutAttributesForElements(in: rect)!) as! [UICollectionViewLayoutAttributes]

        var frame : CGRect! = nil
        var currentY : CGFloat = 0.0;
        var currentWith : CGFloat = 0.0;
        let currentAttributes = NSMutableArray.init()

        for attribute in attributes {

            if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                continue;
            }
            frame = attribute.frame;
            if currentY == 0 {currentY = frame.origin.y;}

            if currentY == frame.origin.y {
                currentAttributes.add(attribute)
                currentWith += frame.size.width
            }

            if frame.origin.y > currentY {//当前行结束
                self.refreshCurrentAttributes(attris: currentAttributes as! [UICollectionViewLayoutAttributes], currentWidth: currentWith);
                currentAttributes.removeAllObjects();
                currentAttributes.add(attribute)
                currentWith = frame.size.width
                currentY = frame.origin.y;

                if attribute .isEqual(attributes[attributes.count - 3]) {
                    //最后一个直接算当前行
                    self.refreshCurrentAttributes(attris: currentAttributes as! [UICollectionViewLayoutAttributes], currentWidth: currentWith)
                }

            }else{
                if attribute.isEqual(attributes[attributes.count-3]) {
                    //最后一个直接算当前行
                    self.refreshCurrentAttributes(attris: currentAttributes as! [UICollectionViewLayoutAttributes], currentWidth: currentWith)
                }
            }
        }

        //为什么要减去三  因为attributes里面竟然包含两个header的布局信息

        return attributes;
    }





    func refreshCurrentAttributes(attris:[UICollectionViewLayoutAttributes],currentWidth:CGFloat){

        let num1 = self.minimumInteritemSpacing*CGFloat(attris.count-1);
        var curLineMinX : CGFloat = (Width-30-currentWidth-num1)*0.5;
        for obj  in attris {
            var f = obj.frame;
            f.origin.x = curLineMinX;
            obj.frame = f;
            curLineMinX = curLineMinX+obj.frame.size.width+self.minimumInteritemSpacing;
        }

    }

}
