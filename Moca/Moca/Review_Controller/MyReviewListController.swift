//
//  MyReviewListController.swift
//  main
//
//  Created by Ria Song on 2021/03/02.
//

import UIKit
import Cosmos
import TinyConstraints

class MyReviewListController: UIViewController, UITableViewDataSource, UITableViewDelegate, MyReviewListProtocol {
    
    
    // MARK: - 변수 Setting
    var feedItem: NSArray = NSArray()
    @IBOutlet var myReviewList: UITableView!
    
    // MARK: - TableView Setting
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        myReviewList.rowHeight = 91
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyReviewTableCell
        
        let item: ReviewDBModel = feedItem[indexPath.row] as! ReviewDBModel
        
        cell!.lbl_reviewDate!.text = "\(item.reviewInsertDate!)"
        cell!.lbl_menuName!.text = "\(item.menuName!)"
        cell!.lbl_brandName!.text = "\(item.brandName!)"
        
        
        // 별점 설정
        if let rating = Double("\(item.reviewStar!)") {
            print(rating)
            cell!.ratingStar.rating = rating
            cell!.ratingStar.settings.updateOnTouch = false
        }
        return cell!
    }
    
    // MARK: Protocol Setting
    func itemDownloaded(items: NSArray) {
            print("itemDownload 실행")
            feedItem = NSArray()
            feedItem = items
            
            if feedItem.count == 0 {
                // 리뷰가 아예 없을때
                print("여기 잘 지나갔음")
                
            } else {
                for i in 0..<feedItem.count {
                    print("feedItem[\(i)]:\(feedItem[i])")
                }
            }
            self.myReviewList.reloadData()
    }
    
    
    // MARK: ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myReviewList.rowHeight = 92
        
        self.myReviewList.delegate = self
        self.myReviewList.dataSource = self
        
        print("viewDidLoad")
        
    } // viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        let myreviewModel = MyReviewListModel()
        myreviewModel.delegate = self
        myreviewModel.downloadItems()
        
        print("viewWillAppear")
    }
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgMyReviewDetail"{
            
            print("sender가 눌리긴해?????")
            let cell = sender as! UITableViewCell
            
            // 그 위치는 이제 indexPath에서 지정.
            let indexPath = self.myReviewList.indexPath(for: cell)
            // 보낼 컨트롤러 위치
            let detailView = segue.destination as! MyReviewDetailViewController
            
            // detailview의 receiveItem에 = feedItem~~~를 보낸다.
            detailView.receiveItem = feedItem[(indexPath! as NSIndexPath).row] as! ReviewDBModel
            print("보내긴해 ??? \(detailView.receiveItem.reviewImg)")
        }
    }
    
    
} // END
