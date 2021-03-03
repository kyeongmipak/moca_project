//
//  PhotoDetailViewController.swift
//  main
//
//  Created by Ria Song on 2021/02/25.
//

import UIKit
import Cosmos
import TinyConstraints

class PhotoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuModelProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    // MARK: 변수 Setting
    var feedItem:NSArray = NSArray()
//    var receiveItem = DBModel() // DBModel 객체 선언
    var receiveItem_collection: [DBModel] = [] // array로 만들어오는거
    var menuNo : String = "" // DB모델....
    var check = 0
    var rate :Double = Double()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableList: UITableView!
    
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableList.delegate = self
        self.tableList.dataSource = self
        
        // cosmos
//        view.addSubview(cosmosView)
////        cosmosView.centerInSuperview()
////        cosmosView.topToSuperview()
//
//        cosmosView.didTouchCosmos = {
//            rating in
//            self.rate = rating
//        }
        
        // instance 선언
//        let jsonModel = JsonModel()
//        jsonModel.delegate = self // jsonModel에서 일 시키고, 그걸 self(여기서 쓸거임)
//        jsonModel.downloadItems() // jsonModel에서 이 메소드 실행해서 일 처리해!
        print("메뉴 넘버 : \(menuNo)")
        
        let menuModel = MenuModel()
        menuModel.delegate = self
        menuModel.downloadItems(menuNo: menuNo)
        
        tableList.rowHeight = 432

//        print(receiveItem.reviewImg!)
        
    } // viewDidLoad End
    
    func itemDownloaded(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        feedItem = NSArray() // feedItem 초기화
        print("feedItem 지남")
        feedItem = items
        print("items \(items)")
        print("feedItem 다운")
        receiveItem_collection = feedItem as! [DBModel]
        print("receiver")
        //        self.collectionView.reloadData()
        check = 1
        print("for")
        for i in 0..<feedItem.count {
            print("receiveItem_collection[\(i)]:\(receiveItem_collection[i].reviewImg)")
            
        }
        collectionView.reloadData()
        tableList.reloadData()
    }
    
    
    // collectionView setting
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = .white
        
        print(">>>>>>>>>>>>>>", receiveItem_collection[indexPath.row].reviewImg!)
        if check == 1{
            if receiveItem_collection[indexPath.row].reviewImg == "null" {
                // 이미지 없을때
                
                
            } else {
                // 이미지 있을때
                let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem_collection[indexPath.row].reviewImg!)")
                print("url : \(url)")
                let data = try! Data(contentsOf: url!)
                cell.photoImgView.image = UIImage(data: data)
            }
            return cell
        }
        
        return cell
        
    }
    
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
        //        let width = collectionView.frame.width. // 1개씩 배치
        print("collectionView width=\(collectionView.frame.width)")
        print("cell하나당 width=\(width)")
        print("root view width = \(self.view.frame.width)")
        
        let size = CGSize(width: width, height: width)
        return size
    }
    

    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // tableView Setting
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ReviewTableViewCell

        
        // cell 정의
        // 현재 배열값으로 들어온 cell 풀어서 정의.
        let item: DBModel = feedItem[indexPath.row] as! DBModel
        
        print("이거 찍어볼거야 이거이거이거이거이거이거이거 ", item.userNickname)
    
        cell.lbl_userNickname?.text = "\(item.userNickname)"
        cell.lbl_reviewInsertDate?.text = "\(item.reviewInsertDate)"
        cell.tv_reviewContent?.text = "\(item.reviewContent)"
        
        let url = URL(string: "http://127.0.0.1:8080/moca/image/\(item.reviewImg!)")
        print("url : \(url)")
        let data = try! Data(contentsOf: url!)
        cell.iv_reviewImg?.image = UIImage(data: data)
        
//
        return cell
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
