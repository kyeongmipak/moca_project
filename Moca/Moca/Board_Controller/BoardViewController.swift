//
//  BoardViewController.swift
//  Moca
//
//  Created by RiaSong on 2021/03/01.
//

import UIKit

class BoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BoardModelProtocol, BoardMineModelProtocol  {
    
    // MARK: - 변수 Setting
    @IBOutlet var postTypeSegmentControl: UISegmentedControl!
    @IBOutlet var tableList: UITableView!
    
    var boardItem: NSArray = NSArray()
    var boardMineItem: NSArray = NSArray()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } // viewDidLoad END -----------------
    
    // MARK: - Protocol func Setting
    func itemDownloaded(items: NSArray) {
        print("boarditemDownload ALL LIST 시작 >>>>>>")
        boardItem = NSArray()
        boardItem = items
        print("feedItem.count >>>> \(boardItem.count)")
        for i in 0..<boardItem.count {
            print("boardItem[\(i)]:\(boardItem[i])")
        }
        self.tableList.reloadData()
    }
    
    func boarditemDownloaded(items: NSArray) {
        print("boarditemDownload MY LIST 시작 >>>>>>")
        boardMineItem = NSArray()
        boardMineItem = items

        print("feedItem.count >>>> \(boardMineItem.count)")
        for i in 0..<boardMineItem.count {
            print("boardMineItem[\(i)]:\(boardMineItem[i])")
        }
        self.tableList.reloadData()
    }
    
    // MARK: - TableView Setting
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedIndex = self.postTypeSegmentControl.selectedSegmentIndex
        switch selectedIndex{
        case 0: // 전체 글
            return boardItem.count
        case 1: // 내가 쓴 글
            return boardMineItem.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedIndex = self.postTypeSegmentControl.selectedSegmentIndex
        switch selectedIndex{
        case 0: // 전체 게시글
            print("tv:0")
            tableList.rowHeight = 80
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            // 현재 배열값으로 들어온 cell 풀어서 정의.
            let item: BoardModel = boardItem[indexPath.row] as! BoardModel
            cell.textLabel?.text = "\(item.boardTitle!)"
            cell.detailTextLabel?.text = "\(item.userNickname!)"
            
            return cell
            
        case 1: // 내가 쓴 글
            print("tv:1")
            tableList.rowHeight = 80
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            
            // 현재 배열값으로 들어온 cell 풀어서 정의.
            let item: BoardModel = boardMineItem[indexPath.row] as! BoardModel
            cell.textLabel?.text = "\(item.boardTitle!)"
            cell.detailTextLabel?.text = "\(item.userNickname!)"
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
 
    
    // MARK: Segment Control Setting
    @IBAction func onChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 전체 게시글 보기
            print("si:0")
            let boardModel = BoardSelectModel()
            boardModel.delegate = self // jsonModel에서 일 시키고, 그걸 self(여기서 쓸거임)
            boardModel.downloadItems() // jsonModel에서 이 메소드 실행해서 일 처리해!
            self.postTypeSegmentControl.selectedSegmentIndex = 0
            self.tableList.reloadData()
        }else if sender.selectedSegmentIndex == 1{
            // 내가 쓴 글 모아보기
            print("si:1")
            let boardModel2 = BoardMineModel()
            boardModel2.delegate = self
            boardModel2.downloadItems()
            self.postTypeSegmentControl.selectedSegmentIndex = 1
            self.tableList.reloadData()
        }
    } // segment control END -----------------------------------
    
    @IBAction func btnWriteBoard(_ sender: UIButton) {
        if Share.userEmail != "" {
            //            performSegue(withIdentifier: "sgWriteBoard", sender: sender)
        } else {
            let resultAlert = UIAlertController(title: "Moca 알림", message: "회원만 글 작성이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let boardModel = BoardSelectModel()
        boardModel.delegate = self
        boardModel.downloadItems()
        tableList.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetailBoard"{
            print("눌렸니?")
            let selectedIndex = self.postTypeSegmentControl.selectedSegmentIndex
            // 사용자가 클릭한 위치는 sender가 알고있는데, 그 위치인 TableView Cell을 담을 변수 cell.
            let cell = sender as! UITableViewCell
            switch selectedIndex{
            case 0: // 전체 게시글
                // 그 위치는 이제 indexPath에서 지정.
                let indexPath = self.tableList.indexPath(for: cell)
                print("어디눌렀냐!!!!!!!\(indexPath)")
                // 보낼 컨트롤러 위치
                let detailView = segue.destination as! DetailViewController
                // detailview의 receiveItem에 = feedItem~~~를 보낸다.
                detailView.receiveItem = boardItem[(indexPath! as NSIndexPath).row] as! BoardModel
            case 1:  // 내가 쓴 게시글
                // 그 위치는 이제 indexPath에서 지정.
                let indexPath = self.tableList.indexPath(for: cell)
                // 보낼 컨트롤러 위치
                let detailView = segue.destination as! DetailViewController
                // detailview의 receiveItem에 = feedItem~~~를 보낸다.
                detailView.receiveItem = boardMineItem[(indexPath! as NSIndexPath).row] as! BoardModel
            default:
                break
            }
        }
    }
    
} // MARK: - END
