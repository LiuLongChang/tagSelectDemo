//
//  TagSelectController.swift
//  TagSelectionDemo
//
//  Created by zzzsw on 2017/6/7.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit


typealias CallBack = (_ array:NSArray)->Void

let kLabelSelectionCellIdentifier = "kLabelSelectionCellIdentifier"
let kLabelSelectionHeaderIdentifier = "kLabelSelectionHeaderIdentifier"


extension TagSelectController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let s : SectionModel = dataArray[section] as! SectionModel;
        return s.mutableCells.count;
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s : SectionModel = dataArray[indexPath.section] as! SectionModel;
        let array = s.mutableCells;
        let tagModel : TagModel = array![indexPath.row] as! TagModel;
        if tagModel.title == nil {
            return CGSize.init(width: 1, height: 1)
        }
        var width = tagModel.title.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)]).width;
        if width > collectionView.frame.width/2 {
            width = collectionView.frame.width/2;
        }
        return CGSize.init(width: width+36, height: 28)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize.init(width: Width, height: 85)
        return size;
    }



    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let view : TagSelectSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kLabelSelectionHeaderIdentifier, for: indexPath) as! TagSelectSectionHeaderView

        let s : SectionModel = dataArray[indexPath.section] as! SectionModel

        let titleLabel = view.titleLabel;
        titleLabel?.textAlignment = .center
        titleLabel?.text = s.title as String?;

        return view;
    }




    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLabelSelectionCellIdentifier, for: indexPath);
        var backgroundView = cell.backgroundView;
        if (backgroundView == nil) {
            let labelView = UILabel.init(frame: cell.bounds)
            labelView.layer.masksToBounds = true
            labelView.layer.borderWidth = 0.5
            backgroundView = labelView
            cell.backgroundView = backgroundView;
        }

        let s : SectionModel = dataArray[indexPath.section] as! SectionModel
        let array : NSMutableArray = s.mutableCells;

        let tagModel : TagModel = array[indexPath.row] as! TagModel;

        let titleView : UILabel = backgroundView as! UILabel;
        titleView.frame = cell.bounds
        titleView.font = UIFont.systemFont(ofSize: 15)
        titleView.text = tagModel.title! as String
        titleView.layer.cornerRadius = 3
        titleView.textAlignment = NSTextAlignment.center

        titleView.textColor = UIColor.black
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.backgroundColor = UIColor.clear

        if tagModel.id == 1 {
            titleView.textColor = UIColor.white
            titleView.layer.borderColor = UIColor.clear.cgColor
            titleView.backgroundColor = UIColor.black
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let sectionModel : SectionModel = dataArray[indexPath.section] as! SectionModel;
        let array : NSMutableArray = sectionModel.mutableCells;
        let tagModel : TagModel = array[indexPath.row] as! TagModel;
        
        if tagModel.id == 1 {return;}

        if sectionModel.userInfo === NSNumber.init(value: 0) {

            if (tagModel.id != nil) && (tagModel.title != nil) {
                var s : SectionModel! = nil
                var targetIndexPath : IndexPath! = nil
                s = dataArray[1] as! SectionModel
                targetIndexPath = IndexPath.init(row: s.mutableCells.count, section: 1)
                s.mutableCells.add(tagModel)
                array.removeObject(at: indexPath.row)
                collectionView.moveItem(at: indexPath, to: targetIndexPath);
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                    collectionView.reloadData()
                })
            }

        }else{
            let s0 : SectionModel = self.dataArray[0] as! SectionModel;
            s0.mutableCells.insert(tagModel, at: s0.mutableCells.count);
            array.removeObject(at: indexPath.row);
            let targetIndexPath = IndexPath.init(row: s0.mutableCells.count-1, section: 0)
            collectionView.moveItem(at: indexPath, to: targetIndexPath);
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                collectionView.reloadData()
            });
        }


    }



}




class TagSelectController: UIViewController {


    var callBack : CallBack! = nil
    var effectView : UIVisualEffectView! = nil
    var dataArray : NSMutableArray! = NSMutableArray()
    var collectionView : UICollectionView! = nil
    var isExist : Bool! = false


    override func viewDidLoad() {
        super.viewDidLoad();
        self.initializeComponent();

    }


    func initializeComponent(){
        self.title = "编辑频道";
        let blurEffect = UIBlurEffect.init(style: .extraLight)
        self.effectView = UIVisualEffectView.init(effect: blurEffect)
        self.effectView.frame = self.view.bounds
        self.effectView.isUserInteractionEnabled = true
        self.view.addSubview(self.effectView)

        self.loaderData()

        let layout = TagCollectionLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8;
        layout.minimumLineSpacing = 10;


        let btn = UIButton.init(type: .custom)
        btn.addTarget(self, action: #selector(TagSelectController.cancelEditTagAction(btn:)), for: .touchUpInside)
        btn.setImage(UIImage.init(named: "main_closeTag"), for: .normal)
        self.view.addSubview(btn)
        btn.setTitle("取消", for: .normal)


        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kLabelSelectionCellIdentifier)
        collectionView.register(TagSelectSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kLabelSelectionHeaderIdentifier)
        self.view.addSubview(collectionView)


        let okBtn = UIButton()
        okBtn.backgroundColor = UIColor.clear
        okBtn.addTarget(self, action: #selector(TagSelectController.publishAction), for: .touchUpInside)
        okBtn.setTitle("完成", for: .normal)
        okBtn.setTitleColor(UIColor.black, for: .normal)
        okBtn.setBackgroundImage(UIImage.init(named: "main_overTagEdit"), for: .normal)
        okBtn.sizeToFit()
        self.view.addSubview(okBtn)


        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top).offset(30)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }

        collectionView.snp.makeConstraints { (make) in

            make.left.equalTo(self.view.snp.left).offset(15);
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.top.equalTo(view.snp.top).offset(130)
            make.bottom.equalTo(view.snp.bottom)
        }

        okBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.bottom).offset(-85)
        }

    }

    func publishAction(){
        let tagArray : NSArray! = NSArray()
        if callBack != nil {
            callBack(tagArray)
        }
        self.cancelEditTag()
    }


    func cancelEditTag(){
        self.dismiss(animated: true, completion: nil)
    }


    func cancelEditTagAction(btn:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    func loaderData(){
        //创建空的组模型 选中的标签
        let section0 = SectionModel()
        section0.userInfo = NSNumber.init(value: 0)
        //选中的标签
        section0.title = "我的频道"
        section0.mutableCells = NSMutableArray()
        //全部标签
        let section1 = SectionModel()
        section1.userInfo = NSNumber.init(value: 1)
        section1.title = "推荐频道"
        section1.mutableCells = NSMutableArray()
        //========
        self.dataArray.add(section0);
        self.dataArray.add(section1);

        //Tags =================
        let tagsArray : Array<Dictionary<String,Any>> = [["id":"1","title":"头条","isSelect":true]
            ,["id":"2","title":"专题","isSelect":true]
            ,["id":"3","title":"汽车","isSelect":true]
            ,["id":"4","title":"国学","isSelect":true]
            ,["id":"5","title":"社会","isSelect":true]
            ,["id":"6","title":"人间","isSelect":true]
            ,["id":"7","title":"天下","isSelect":true]
            ,["id":"8","title":"推荐","isSelect":true]
            ,["id":"9","title":"姿态","isSelect":true]
            ,["id":"10","title":"新闻","isSelect":true]
            ,["id":"11","title":"时政","isSelect":true]
            ,["id":"12","title":"法律新评论","isSelect":true]]

        var tagModels = [TagModel]();
        for dic in tagsArray {
            let tagModel = TagModel.init(id: Int(dic["id"] as! String)!, title: dic["title"] as! NSString, isSelect: dic["isSelect"] as! Bool);
            tagModels.append(tagModel);
        }

        for model in tagModels {
            if model.isSelect {
                section0.mutableCells.add(model)
            }else{
                section1.mutableCells.add(model)
            }
        }

        if self.collectionView != nil {
            self.collectionView.reloadData()
        }

    }



    class func modalInVC(vc:UIViewController,completion:CallBack?){

        let labelVC = TagSelectController();
        labelVC.callBack = completion;
        labelVC.view.backgroundColor = UIColor.init(patternImage: labelVC.capture(view: vc.view));
        vc.present(labelVC, animated: false, completion: nil);

    }

    class func modalInVC(vc:UIViewController){
        TagSelectController.modalInVC(vc: vc, completion: nil)
    }



    func capture(view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!;
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
