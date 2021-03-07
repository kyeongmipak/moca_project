//
//  TestViewController.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit
import Cosmos
import TinyConstraints

// LikeCountJsonModelProtocol
class PhotoDetailReviewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuModelProtocol, StarAvgProtocol, PhotoTableViewCellDelegate, TextOnlyTableViewCellDelegate, DetailButtonTableViewCellDelegate, LikeCountJsonModelProtocol {
    
    var brandName = ""
    
    // MARK: - TableView Setting
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //--------------------
        // 기존
        // return 1
        //--------------------
        // 3.6 kyeongmi 수정 부분
        return 3
        //--------------------

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("feedItem Count >>>> ", feedItem.count)
//        return feedItem.count + 2
        
        //--------------------
        // 3.6 kyeongmi 수정 부분
        switch section {
            // 메뉴 설명
            case 0...1:
                return 1
                
            // 예진 파트
            case 2:
                return feedItem.count + 2
            default:
                return 0
        }
        //--------------------
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //--------------------
        // 3.6 kyeongmi 수정 부분
        switch indexPath.section {
            case 0:
                tableList.rowHeight = 250
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDetailTableViewCell", for: indexPath) as! MenuDetailTableViewCell
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if menuItem.menuNo != nil {
                    let result = numberFormatter.string(from: NSNumber(value: Int(menuItem.menuPrice!)!))
                    brandName = menuItem.brandName!
                    cell.menuBrandName.text = "\(menuItem.brandName!)"
                    cell.menuContent.text = "\(menuItem.menuInformation!)"
                    let url = URL(string: "http://127.0.0.1:8080/moca/image/\(menuItem.menuImg!)")

                    let data = try! Data(contentsOf: url!)
                    cell.menuImage.image = UIImage(data: data)
                    cell.menuName.text = "\(menuItem.menuName!)"
                    cell.menuPriceCal.text = "\(result!) 원 / \(menuItem.menuCalorie!) kcal"
                    
                } else if rankItem.menuNo != nil{
                    let result = numberFormatter.string(from: NSNumber(value: Int(rankItem.menuPrice!)!))
                
                    cell.menuBrandName.text = "\(rankItem.brandName!)"
                    cell.menuContent.text = "\(rankItem.menuInformation!)"
                    let url = URL(string: "http://127.0.0.1:8080/moca/image/\(rankItem.menuImg!)")

                    let data = try! Data(contentsOf: url!)
                    cell.menuImage.image = UIImage(data: data)
                    cell.menuName.text = "\(rankItem.menuName!)"
                    cell.menuPriceCal.text = "\(result!) 원 / \(rankItem.menuCalorie!) kcal"
                }else {
                    // 지은
                    let result = numberFormatter.string(from: NSNumber(value: Int(LikeItem.menuPrice!)!))
                
                    cell.menuBrandName.text = "\(LikeItem.brandName!)"
                    cell.menuContent.text = "\(LikeItem.menuInformation!)"
                    let url = URL(string: "http://127.0.0.1:8080/moca/image/\(LikeItem.menuImg!)")

                    let data = try! Data(contentsOf: url!)
                    cell.menuImage.image = UIImage(data: data)
                    cell.menuName.text = "\(LikeItem.menuName!)"
                    cell.menuPriceCal.text = "\(result!) 원 / \(LikeItem.menuCalorie!) kcal"
                }
                return cell
            
            // 찜, 공유, 지도 버튼 셀
            case 1:
                tableList.rowHeight = 50
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailButtonTableViewCell", for: indexPath) as! DetailButtonTableViewCell
                
                cell.delegate = self
                print("menuNoReveive \(menuNoReveive)")
                
                cell.menuNo = Int(menuNoReveive)!
                
                //
                if result == 0{
                    // 즐겨찾기 등록이 되어있지 않을 때
                    cell.LikeImg.image = UIImage(named: "no_like.png")
                }else if result == 1{
                    // 즐겨찾기 등록이 되어있을 때
                    cell.LikeImg.image = UIImage(named: "yes_like.png")
                }
                
                return cell
            
            case 2:
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
                    
                } else if indexPath.row == 1 {
                    tableList.rowHeight = 150
//                    TestMenuno.menuno = menuNO.menuNo!
                    // kyeongmi
                    TestMenuno.menuno = menuNoReveive

                    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? GetCollectionTableCell
                    
                    
                    
                    return cell!
                } else {
                    
                    let item: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
                    
                    if item.reviewImg! == "null" {
                        //                // 이미지 없을 때
                        tableList.rowHeight = 150
                        //                //print("이미지 없을때\(item.reviewImg)")
                        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell4", for: indexPath) as? TextOnlyTableViewCell
                        
                        let TextITEM: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
                        
                        cell?.lbl_userNickname?.text = "\(TextITEM.userNickname!)"
                        cell?.lbl_reviewInsertDate?.text = "\(TextITEM.reviewInsertDate!)"
                        cell?.tv_reviewContent?.text = "\(TextITEM.reviewContent!)"
                        
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
                        
                        cell!.delegate = self
                        
                        let receiveItem: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
                        
                        // lable & textView 설정
                        cell!.lbl_name?.text = "\(receiveItem.userNickname!)"
                        cell!.lbl_date?.text = "\(receiveItem.reviewInsertDate!)"
                        cell!.tv_content?.text = "\(String(describing: receiveItem.reviewContent!))"
                        
                        // 별점 설정
                        if let rating = Double("\(receiveItem.reviewStar!)") {
                            print("☆☆☆☆☆",receiveItem.reviewStar!)
                            print(rating)
                            cell!.ratingStar.rating = rating
                            cell!.ratingStar.settings.updateOnTouch = false
                        }
                        
                        // 이미지뷰
                        let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.reviewImg!)")
                        print("url : \(String(describing: url))")
                        let data = try! Data(contentsOf: url!)
                        
                        cell!.iv_img!.image = UIImage(data: data)
                        
                        //                cell!.iv_img!.layer.cornerRadius = cell!.iv_img!.frame.height * 2 - 1
                        cell!.iv_img!.layer.cornerRadius = 10
                        cell!.iv_img!.layer.borderWidth = 1
                        cell!.iv_img!.layer.borderColor = UIColor.clear.cgColor
                        // 뷰의 경계에 맞춰준다
                        cell!.iv_img!.clipsToBounds = true
                        cell!.iv_img!.layer.masksToBounds = true
                        cell!.iv_img!.layer.cornerRadius = cell!.iv_img!.bounds.width / 6
                        
                        
                        print("이미지 있을때 endline")
                        return cell!
                    }
                    
                    
                    //
                    
                    //            return cell!
                    //            tableList.reloadData()
                }
                //        tableList.reloadData()
                
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDetailTableViewCell", for: indexPath) as!MenuDetailTableViewCell
                
            return cell
        }
        
//        if indexPath.row == 0{
//            tableList.rowHeight = 60
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell3", for: indexPath) as? StarAvgTableViewCell
//
//            // 별점 설정
//            if let rating = Double(starAvg) {
//                print("☆☆☆☆☆\(starAvg)")
//                print(rating)
//                cell!.cosmos_ratingStarAvg.rating = rating
//                cell!.cosmos_ratingStarAvg.settings.updateOnTouch = false
//                cell!.lbl_starAvg.text = String(rating)
//            }
//            return cell!
//
//        } else if indexPath.row == 1 {
//            tableList.rowHeight = 150
//            TestMenuno.menuno = menuNO.menuNo!
//            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? GetCollectionTableCell
//
//
//
//            return cell!
//        } else {
//
//            let item: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
//
//            if item.reviewImg! == "null" {
//                //                // 이미지 없을 때
//                tableList.rowHeight = 150
//                //                //print("이미지 없을때\(item.reviewImg)")
//                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell4", for: indexPath) as? TextOnlyTableViewCell
//
//                let TextITEM: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
//
//                cell?.lbl_userNickname?.text = "\(TextITEM.userNickname!)"
//                cell?.lbl_reviewInsertDate?.text = "\(TextITEM.reviewInsertDate!)"
//                cell?.tv_reviewContent?.text = "\(TextITEM.reviewContent!)"
//
//                // 별점 설정
//                if let rating = Double("\(TextITEM.reviewStar!)") {
//                    print("☆☆☆☆☆",item.reviewStar!)
//                    print(rating)
//                    cell!.ratingStar.rating = rating
//                    cell!.ratingStar.settings.updateOnTouch = false
//                }
//                print("이미지 없을때 endline")
//                return cell!
//
//            } else {
//                // 이미지 있을 때
//                //print("이미지 있을때\(item.reviewImg)")
//                tableList.rowHeight = UITableView.automaticDimension + 400
//                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as? PhotoTableViewCell
//
//                cell!.delegate = self
//
//                let receiveItem: ReviewDBModel = feedItem[indexPath.row - 2] as! ReviewDBModel
//
//                // lable & textView 설정
//                cell!.lbl_name?.text = "\(receiveItem.userNickname!)"
//                cell!.lbl_date?.text = "\(receiveItem.reviewInsertDate!)"
//                cell!.tv_content?.text = "\(String(describing: receiveItem.reviewContent!))"
//
//                // 별점 설정
//                if let rating = Double("\(receiveItem.reviewStar!)") {
//                    print("☆☆☆☆☆",receiveItem.reviewStar!)
//                    print(rating)
//                    cell!.ratingStar.rating = rating
//                    cell!.ratingStar.settings.updateOnTouch = false
//                }
//
//                // 이미지뷰
//                let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.reviewImg!)")
//                print("url : \(String(describing: url))")
//                let data = try! Data(contentsOf: url!)
//
//                cell!.iv_img!.image = UIImage(data: data)
//
//                //                cell!.iv_img!.layer.cornerRadius = cell!.iv_img!.frame.height * 2 - 1
//                cell!.iv_img!.layer.cornerRadius = 10
//                cell!.iv_img!.layer.borderWidth = 1
//                cell!.iv_img!.layer.borderColor = UIColor.clear.cgColor
//                // 뷰의 경계에 맞춰준다
//                cell!.iv_img!.clipsToBounds = true
//                cell!.iv_img!.layer.masksToBounds = true
//                cell!.iv_img!.layer.cornerRadius = cell!.iv_img!.bounds.width / 6
//
//
//                print("이미지 있을때 endline")
//                return cell!
//            }
//
//
//            //
//
//            //            return cell!
//            //            tableList.reloadData()
//        }
//        //        tableList.reloadData()
    }
    
    
    
    // MARK: Protocol func Setting
    func itemDownloaded(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        feedItem = NSArray() // feedItem 초기화
        print("feedItem 지남")
        feedItem = items
        print("items \(items)")
        
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
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let menuModel = MenuModel()
        menuModel.delegate = self
//        menuModel.downloadItems(menuNo: menuNO.menuNo!)
        menuModel.downloadItems(menuNo: menuNoReveive)

        
        let starAvgModel = StarAvgModel()
        starAvgModel.delegate = self
//        starAvgModel.downloadItemsStar(menuNo: menuNO.menuNo!)
        starAvgModel.downloadItemsStar(menuNo: menuNoReveive)

    }
    
    
    // MARK: 변수 Setting
    @IBOutlet var tableList: UITableView!
    
  
    
    var feedItem:NSArray = NSArray()
    //    var receiveItem = DBModel() // DBModel 객체 선언
    var starAvg : String = "" // DB모델
    var menuNo : String = "" // DB모델....
    var check = 0
    var rate :Double = Double()
    var ITEMS:[ReviewDBModel] = []
    var TextITEM:[ReviewDBModel] = []
    var receiveItem:[ReviewDBModel] = []
    var menuNoReveive = ""
    
    @IBOutlet var rightBarButton: UIBarButtonItem!
    var menuNO = ReviewDBModel()
    
    // 3.6 kyeongmi 추가
    var menuItem: SearchDBModel = SearchDBModel()
    var rankItem: BrandRankDBModel = BrandRankDBModel()
    var btnName = ""
    
    // 지은 추가
    var result = 3
    var LikeItem: LikeDBModel = LikeDBModel()
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("메 뉴 넘 버 모 야 !!!!!!>>>>>>\(menuItem.menuNo)")
        if menuItem.menuNo != nil {
            menuNoReveive = menuNO.menuNo!
        } else if rankItem.menuNo != nil {
            menuNoReveive = rankItem.menuNo!
        } else if LikeItem.menu_menuNo != nil{
            menuNoReveive = String(LikeItem.menu_menuNo!)
        }
        else {
            menuNoReveive = menuItem.menuNo!
        }
        
        let menuModel = MenuModel()
        menuModel.delegate = self
        menuModel.downloadItems(menuNo: menuNoReveive)
        
        let starAvgModel = StarAvgModel()
        starAvgModel.delegate = self
        starAvgModel.downloadItemsStar(menuNo: menuNoReveive)
//        print("메 뉴 넘 버 모 야 !!!!!!>>>>>>\(menuNoReveive)")
        
        self.tableList.delegate = self
        self.tableList.dataSource = self
        TestMenuno.menuno = menuNoReveive
   //- -------- 주석 풀어야한다.
//        let menuModel = MenuModel()
//        menuModel.delegate = self
//        menuModel.downloadItems(menuNo: menuNO.menuNo!)
//
//        let starAvgModel = StarAvgModel()
//        starAvgModel.delegate = self
//        starAvgModel.downloadItemsStar(menuNo: menuNO.menuNo!)
//        print("메 뉴 넘 버 모 야 !!!!!!>>>>>>\(menuNO.menuNo!)")
//
//        self.tableList.delegate = self
//        self.tableList.dataSource = self
//        TestMenuno.menuno = menuNO.menuNo!
 //-------------
        // Hide Setting (잘됨... 흠)
//        if Share.userEmail != "" {
//            navigationItem.rightBarButtonItem = rightBarButton // show
//        } else {
//            navigationItem.rightBarButtonItem = nil // hide
//        }
        
        
        
        //menuNoReveive
        let likejsonModel = LikeCountJsonModel()
        likejsonModel.delegate = self
        likejsonModel.downloadItems(userInfo_userEmail: Share.userEmail, menu_menuNO: Int(menuNoReveive)!)
    }// view didload 끝
    
    func likeItemDownloaded(items: Int) {
        result = items
        print(result)
    }
    
    
    
    // MARK: - func & delegate func Setting
    
    
    
    @IBAction func btnWriteReview(_ sender: UIBarButtonItem) {
        if Share.userEmail != "" {
//            performSegue(withIdentifier: "sgWriteReview", sender: sender)
        } else {
            let resultAlert = UIAlertController(title: "Moca 알림", message: "회원만 리뷰 작성이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil)
        }
    }
    
    
    func customCell(_ customCell: PhotoTableViewCell, btn_ReportAction button: UIButton) {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let resultAlert = UIAlertController(title: "게시글 신고", message: "해당 게시글을 부적절한 게시글로 신고하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "신고", style: UIAlertAction.Style.default, handler: {ACTION in
            
            let resultAlert = UIAlertController(title: "", message: "신고되었습니다.\n관리자 확인 후 조치하겠습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler:nil)
        resultAlert.addAction(onAction)
        resultAlert.addAction(cancelAction)
        self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
    }
    
    func customCell(_ customCell: TextOnlyTableViewCell, btn_ReportAction2 button: UIButton) {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let resultAlert = UIAlertController(title: "게시글 신고", message: "해당 게시글을 부적절한 게시글로 신고하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "신고", style: UIAlertAction.Style.default, handler: {ACTION in
            
            let resultAlert = UIAlertController(title: "", message: "신고되었습니다.\n관리자 확인 후 조치하겠습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler:nil)
        resultAlert.addAction(onAction)
        resultAlert.addAction(cancelAction)
        self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
    }

    
    // btn 클릭 시 이벤트
    func selectedInfoBtn(action: String) {
        btnName = action
        
        //btnName은 찜 : like, 공유 : share, 지도 : map 으로 받아온다.
        // 지도 버튼
        if btnName == "map"{
            // MAP controller 연결 segue
            
            
        }
    }
    

    
    
    // MARK: - Navigation -> 브랜드명, 음료명, 메뉴 넘버 넘겨줘야 함!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 2021.03.07 맵으로 넘어가는 작업 - 대환
        if segue.identifier == "sgMap"{
            let mapViewController = segue.destination as! MapViewController
            mapViewController.brandName = brandName
        }
    }
    
    
} // MARK: - END
