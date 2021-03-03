//
//  TestViewController.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit
import Cosmos
import TinyConstraints


class PhotoDetailReviewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuModelProtocol, StarAvgProtocol {
    
    var ITEMS:[ReviewDBModel] = []
    var TextITEM:[ReviewDBModel] = []
    var receiveItem:[ReviewDBModel] = []
    
    // MARK: - TableView Setting
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("feedItem Count >>>> ", feedItem.count)
        return feedItem.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            tableList.rowHeight = 60
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell3", for: indexPath) as? StarAvgTableViewCell
            
            // 별점 설정
            if let rating = Double(starAvg) {
                print("☆☆☆☆☆\(starAvg)")
                print(rating)
                cell!.cosmos_ratingStarAvg.rating = rating
                cell!.cosmos_ratingStarAvg.settings.updateOnTouch = false
                cell!.lbl_starAvg.text = String(rating)
            }
            return cell!
            cell?.lbl_starAvg.text = starAvg
            
        } else if indexPath.row == 1 {
            tableList.rowHeight = 128
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? GetCollectionTableCell
            
            return cell!
        } else {
//            tableList.rowHeight = 409
            //tableList.estimatedRowHeight = 409
//            tableList.rowHeight = UITableView.automaticDimension
//            tableList.rowHeight = UITableView.automaticDimension + 400
//
//            if ((tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? TestTableViewCell) != nil) {
////                 이미지 있을 때
//                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? TestTableViewCell
//
//            let item: DBModel = feedItem[indexPath.row - 2] as! DBModel
//                cell!.lbl_name?.text = "\(item.userNickname!)"
//                cell!.lbl_date?.text = "\(item.reviewInsertDate!)"
//                cell!.tv_content?.text = "\(item.reviewContent!)"
//
//                // 별점 설정
//                if let rating = Double("\(item.reviewStar!)") {
//                    print("☆☆☆☆☆",item.reviewStar!)
//                    print(rating)
//                    cell!.ratingStar.rating = rating
//                    cell!.ratingStar.settings.updateOnTouch = false
//
//            } else if ((tableView.dequeueReusableCell(withIdentifier: "myCell4", for: indexPath) as? TestTextOnlyTableViewCell) != nil) {
//                // 이미지 없을 때
//
//            }
//            
//            if mycell2
//            
//            else if my~
            
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? TestTableViewCell
            
//            tableList.estimatedRowHeight = 409
//            tableList.rowHeight = UITableView.automaticDimension

            
//            let item: DBModel = feedItem[indexPath.row - 2] as! DBModel
            
            
//            print("이거 찍어볼거야 이거이거이거이거이거이거이거 ", item.userNickname)
            
            // lable & textView 설정
//            cell!.lbl_name?.text = "\(item.userNickname!)"
//            cell!.lbl_date?.text = "\(item.reviewInsertDate!)"
//            cell!.tv_content?.text = "\(item.reviewContent!)"
//
//
//            // 별점 설정
//            if let rating = Double("\(item.reviewStar!)") {
//                print("☆☆☆☆☆",item.reviewStar!)
//                print(rating)
//                cell!.ratingStar.rating = rating
//                cell!.ratingStar.settings.updateOnTouch = false
//            }
            let item: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
  
            if item.reviewImg! == "null" {
//                // 이미지 없을 때
                tableList.rowHeight = 150
//                //print("이미지 없을때\(item.reviewImg)")
                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell4", for: indexPath) as? TextOnlyTableViewCell

                let TextITEM: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel

                cell?.lbl_userNickname?.text = "\(TextITEM.userNickname!)"
                cell?.lbl_reviewInsertDate?.text = "\(TextITEM.reviewInsertDate!)"
                cell?.tv_reviewContent?.text = "\(TextITEM.reviewContent)"

                // 별점 설정
                if let rating = Double("\(TextITEM.reviewStar!)") {
                    print("☆☆☆☆☆",item.reviewStar!)
                    print(rating)
                    cell!.ratingStar.rating = rating
                    cell!.ratingStar.settings.updateOnTouch = false
                }
                print("이미지 없을때 endline")
                return cell!
                
            } else {
                // 이미지 있을 때
                //print("이미지 있을때\(item.reviewImg)")
                tableList.rowHeight = UITableView.automaticDimension + 400
                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? PhotoTableViewCell
                
                let receiveItem: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
                
                // lable & textView 설정
                
                cell!.lbl_name?.text = "\(receiveItem.userNickname!)"
                cell!.lbl_date?.text = "\(receiveItem.reviewInsertDate!)"
                
//                cell!.tv_content.layer.borderColor = UIColor.black.cgColor
//                cell!.tv_content.layer.cornerRadius = 10
//                cell!.tv_content.layer.borderWidth = 0.5
//                cell!.tv_content.layer.masksToBounds = true
                cell!.tv_content?.text = "\(String(describing: receiveItem.reviewContent))"

                // 별점 설정
                if let rating = Double("\(receiveItem.reviewStar!)") {
                    print("☆☆☆☆☆",receiveItem.reviewStar!)
                    print(rating)
                    cell!.ratingStar.rating = rating
                    cell!.ratingStar.settings.updateOnTouch = false
                }
                
                let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.reviewImg!)")
                print("url : \(String(describing: url))")
                let data = try! Data(contentsOf: url!)
                cell!.iv_img!.image = UIImage(data: data)
                
                print("이미지 있을때 endline")
                return cell!
            }
           
            
            //
            
//            return cell!
//            tableList.reloadData()
        }
//        tableList.reloadData()
    }
    
    

    // MARK: Protocol func Setting
    func itemDownloaded(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        feedItem = NSArray() // feedItem 초기화
        print("feedItem 지남")
        feedItem = items
        print("items \(items)")
        
//        print("feedItem 다운")
//        receiveItem_collection = feedItem as! [DBModel]
//        print("receiver")
        
        ITEMS = feedItem as! [ReviewDBModel]
        print(feedItem[0] as! ReviewDBModel)
        let item = feedItem[0] as! ReviewDBModel

        for i in 0..<feedItem.count {
            if ITEMS[i].reviewImg != "null"{
                receiveItem.append(ITEMS[i])
            } else {
                TextITEM.append(ITEMS[i])
            }
        }
        
        check = 1
        
        tableList.reloadData()
    }
    
    func itemDownloadedStar(items: String) {
        print("----☆☆☆☆☆ itemDownload 함수 작동-----")
        starAvg = ""
        print("feedItem 지남")
        starAvg = items
        print("items \(items)")
        print("feedItem 다운")
        starAvg = items as String
        print("전체 별점 평균 \(starAvg)")
        
        tableList.reloadData()
    }
    
    
    @IBOutlet var tableList: UITableView!
    
    
    // MARK: 변수 Setting
    var feedItem:NSArray = NSArray()
    //    var receiveItem = DBModel() // DBModel 객체 선언
    var starAvg : String = "" // DB모델
    var menuNo : String = "" // DB모델....
    var check = 0
    var rate :Double = Double()
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("메뉴 넘버 : \(menuNo)")
        
        let menuModel = MenuModel()
        menuModel.delegate = self
        menuModel.downloadItems(menuNo: "3")
        
        let starAvgModel = StarAvgModel()
        starAvgModel.delegate = self
        starAvgModel.downloadItemsStar(menuNo: "3")
        
        self.tableList.delegate = self
        self.tableList.dataSource = self
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // MARK: - END
