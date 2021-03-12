//
//  TestGetCollectionTableCell.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//
import Foundation
import UIKit

protocol CustomCollectionCellDelegate:class {
    func collectionView(collectioncell:CollectionCell?, didTappedInTableview TableCell:GetCollectionTableCell)
    //other delegate methods that you can define to perform action in viewcontroller
}

class GetCollectionTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MenuModelProtocol {

    
    
    
    weak var cellDelegate:CustomCollectionCellDelegate? //define delegate
    
    var feedItem:NSArray = NSArray()
    var receiveItem:[ReviewDBModel] = [] // DBModel 객체 선언
    var ITEMS:[ReviewDBModel] = []
//    var menuNO = ReviewDBModel()
    
    let cellReuseId = "GetCollectionTableCell"

    func itemDownloaded(items: NSArray) {
        print("----ReviewView itemDownload 함수 작동-----")
        feedItem = NSArray() // feedItem 초기화
        print("feedItem 지남")
        feedItem = items
        ITEMS = feedItem as! [ReviewDBModel]
        print("feedItem.count \(feedItem.count)")
        
        for i in 0..<feedItem.count {
            if ITEMS[i].reviewImg != "null"{
                receiveItem.append(ITEMS[i])
                print("for문지나따")
            }
        }
        collectionView.reloadData()
    }
  
    class var customCell : GetCollectionTableCell {
        let cell = Bundle.main.loadNibNamed("GetCollectionTableCell", owner: self, options: nil)?.last
        return cell as! GetCollectionTableCell
    }
    
    @IBOutlet var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            
            self.collectionView.register(UINib(nibName: "GetCollectionTableCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            
            self.collectionView.reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let cellNib = UINib(nibName: "GetCollectionTableCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseId)
        
        // instance 선언
        let menuModel = MenuModel()
        menuModel.delegate = self
        menuModel.downloadItems(menuNo: TestMenuno.menuno)
        print(">>>>>get collection view menuno >>>>> \(TestMenuno.menuno)")

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 15 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
//                let width = collectionView.frame.width // 1개씩 배치
                let layout = collectionView.scrollIndicatorInsets = .horizontal(1)
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .horizontal

        let size = CGSize(width: width, height: width)
        
        return size
    }
    
    
    
    //MARK: Collection view datasource and Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        
        self.cellDelegate?.collectionView(collectioncell: cell, didTappedInTableview: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receiveItem.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        
        cell.backgroundColor = .white
        
        // 이미지 있을때
        let url = URL(string: "http://" + Share.macIP + "/moca/image/\(receiveItem[indexPath.row].reviewImg!)")
        let data = try! Data(contentsOf: url!)
        cell.iv_testImg.image = UIImage(data: data)
        
        cell.iv_testImg.layer.cornerRadius = cell.iv_testImg.frame.height/4
        cell.iv_testImg.layer.cornerRadius = 20
        cell.iv_testImg.layer.borderWidth = 1
        cell.iv_testImg.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        cell.iv_testImg.clipsToBounds = true
        
        return cell
    }
}



//    //MARK: Instance Methods
//    func updateCellWith(category:ImageCategory) {
//        self.aCategory = category
//        self.myCollectionView.reloadData()
//    }
