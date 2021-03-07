//
//  LikeTableViewController.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import UIKit

class LikeTableViewController: UITableViewController, LikeJsonModelProtocol, LikeCellDelegate {
    
    
    @IBOutlet var likeListTableView: UITableView!
    
    // 최종적으로 tableView에서 사용할 배열 함수
    var LikeItem: NSMutableArray = NSMutableArray() // 배열 (한번 정해지면 바꿀 수 없음.)
    // NSMutableArray → arraylist (추가 가능)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // instance 선언
        let likeJsonModel = LikeJsonModel()
        likeJsonModel.delegate = self // jsonModel에서 일 시키고, 그걸 self(여기서 쓸거임)
        likeJsonModel.downloadItems(userEmail: Share.userEmail) // jsonModel에서 이 메소드 실행해서 일 처리해!
        
        // Custom Cell 정의
        likeListTableView.rowHeight = 80 // Cell 높이 지정
    }
    
    
    //4 > creat function for add your custom code
    func likeDeleteTapped(cell:LikeTableViewCell)
    {
        //Get the indexpath of cell where button was tapped
        let indexPath001 = self.tableView.indexPath(for: cell)//genrate your clicked cell indexPath
        self.LikeItem.remove(indexPath001 as Any)
        self.LikeItem.removeObject(at:(indexPath001?.row)!)

        

        let menuNo = Int(cell.menuNO.text!)
        let likeDeleteModel = LikeDeleteModel() // instance 선언
        _ = likeDeleteModel.likeDeleteItems(menuNO: menuNo!)
        tableView.deleteRows(at:[indexPath001!], with: .left)
        tableView.reloadData()
        print(indexPath001!.row)
    }
    
    func likeItemDownloaded(items: NSArray) {
        // JsonModel의 locations에 담겨져서 넘어옴.
        LikeItem = items as! NSMutableArray
        self.likeListTableView.reloadData()
        
    }
    // 입력, 수정, 삭제 후 DB 재구성 → Table 재구성
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        let likeJsonModel = LikeJsonModel() // protocol연결된 클래스 객체 선언
        likeJsonModel.delegate = self // 일 처리 시킬건데, 이 화면에서 시킬거고
        likeJsonModel.downloadItems(userEmail: Share.userEmail) // jsonModel의 downloadItems를 처리하게 할거야.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.likeListTableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LikeItem.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ↓ custom한 TableViewCell 사용할거니까
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCell", for: indexPath) as! LikeTableViewCell
        
        cell.delegate = self as? MyCellDelegate
        // cell 정의
        // 현재 배열값으로 들어온 cell 풀어서 정의.
        let item: LikeDBModel = LikeItem[indexPath.row] as! LikeDBModel
        cell.likeBrand?.text = "\(item.menuName!)"
        cell.likeName?.text = "\(item.menuName!)"
        cell.menuNO?.text = "\(item.menu_menuNo!)"
        
        cell.menuNO.isHidden = true
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "starDetail"{
           // 사용자가 클릭한 위치는 sender가 알고있는데, 그 위치인 TableView Cell을 담을 변수 cell.
           let cell = sender as! UITableViewCell
           // 그 위치는 이제 indexPath에서 지정.
           let indexPath = self.starListTableView.indexPath(for: cell)
           // 보낼 컨트롤러 위치
           let detailAdrViewController = segue.destination as! DetailAdrViewController
        var addressNo = StarItem[(indexPath! as NSIndexPath).row] as! AddressModel
        
           // detailview의 receiveItem에 =~~~~를 보낸다.
        detailAdrViewController.addressReceiveNo = addressNo.addressNo!
       }
        
     }
     
    
   // *************************************************************************
    
}
