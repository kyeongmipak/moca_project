//
//  ReviewViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

class ReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoReviewProtocol {
    func photoReviewitemDownloaded(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        feedItem = NSArray() // feedItem 초기화
        feedItem = items
        print("feedItem.count >>>> \(feedItem.count)")
        ITEMS = feedItem as! [ReviewDBModel]
        receiveItem = []
        
        for i in 0..<feedItem.count {
//            if ITEMS[i].reviewImg != "null"{
                receiveItem.append(ITEMS[i])
//            }
        }
        collectionView.reloadData()
    }
    

    // MARK: - 변수 Setting
    var feedItem:NSArray = NSArray()
    var receiveItem:[ReviewDBModel] = [] // DBModel 객체 선언
    var ITEMS:[ReviewDBModel] = []
    @IBOutlet var collectionView: UICollectionView!
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    // MARK: - Protocol func Setting
    override func viewWillAppear(_ animated: Bool) {
        // instance 선언
        let photoReviewModel = PhotoReviewModel()
        photoReviewModel.delegate = self
        photoReviewModel.downloadItems()
    }
    
    
    // MARK: - CollectionView Setting
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receiveItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = .white
        
        // 이미지 있을때
        var urlPath = "http://" + Share.macIP + "/moca/image/\(receiveItem[indexPath.row].reviewImg!)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)
        let data = try! Data(contentsOf: url!)
        cell.imgView.image = UIImage(data: data)
        
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

        let size = CGSize(width: width, height: width)
        return size
    }
    
   

     // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoDetail"{
            // 사용자가 클릭한 위치는 sender가 알고있는데, 그 위치인 TableView Cell을 담을 변수 cell.
            let cell = sender as! UICollectionViewCell
            // 그 위치는 이제 indexPath에서 지정.
            let indexPath = self.collectionView.indexPath(for: cell)
            // 보낼 컨트롤러 위치
            let photoDetailView = segue.destination as! PhotoDetailReviewController
            // detailview의 receiveItem에 = feedItem~~~를 보낸다.
//            photoDetailView.menuNO = feedItem[(indexPath! as NSIndexPath).row] as! ReviewDBModel
//            print("메뉴 넘버 잘 보내지?? \(photoDetailView.menuNO)")
            photoDetailView.menuInfoItem = feedItem[(indexPath! as NSIndexPath).row] as! ReviewDBModel
            print("메뉴 넘버 잘 보내지?? \(photoDetailView.menuInfoItem.menuNo!)")
        }
    } // prepare END
    
    
}
