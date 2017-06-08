//
//  ViewController.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/7.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.purple
        btn.frame = CGRect.init(x: 100, y: 100, width: 200, height: 40)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(ViewController.clickBtn), for: .touchUpInside)


    }


    func clickBtn(){

        TagSelectController.modalInVC(vc: self, completion: nil)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

