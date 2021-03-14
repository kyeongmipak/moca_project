//
//  CoffeeViewController.swift
//  Main_FINIALLY_2.26
//
//  Created by 박경미 on 2021/02/27.
//

import UIKit

class CoffeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CategoryRankJsonModelProtocol {
    
    var feedItem: NSArray = NSArray()
    var categoryName: String = ""
    var pageIndex: Int!
    
    var searching = false
    var searchedMenu = [BrandRankDBModel]()
    var menuArray = [BrandRankDBModel]()
    
    @IBOutlet weak var menuTotalNum: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        let categoryRankJsonModel = CategoryRankJsonModel()
        categoryRankJsonModel.delegate = self
        categoryRankJsonModel.downloadItems(categoryName: categoryName)


        searchBar.delegate = self
        searchBar.showsCancelButton = false
        
    }
    
    func itemDownloaded(items: NSArray) {
        if items.count == 0 {
            menuTotalNum.text = "0 개의 제품"
            searchBar.isHidden = true
            
        } else {
            feedItem = items
            menuArray = items as! [BrandRankDBModel]
            searchBar.placeholder = "브랜드 또는 메뉴를 검색하세요."
        }
        tableViewList.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedMenu.count
            
        } else {
            return menuArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTableViewCell") as! CoffeeTableViewCell

        if searching { // 검색할때
            let item1: BrandRankDBModel = searchedMenu[indexPath.row]

            cell.rankMenu.text = "\(indexPath.row + 1)"
            cell.lblMenuName.text = item1.menuName
            cell.lblBrandName.text = item1.brandName

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: Int(item1.menuPrice!)!))
            cell.lblMenuPrice.text = "\(result!) 원"
            if item1.reviewAvg == "null"{
                cell.lblReviewAvg.text = "⭐️ 0.0"
            } else {
                cell.lblReviewAvg.text = "⭐️ \(item1.reviewAvg!)"
            }
//            let url1 = URL(string: "http://127.0.0.1:8080/moca/image/\(item1.menuImg!)")
//            let data1 = try! Data(contentsOf: url1!)
            
            var urlPath = "http://" + Share.macIP + "/moca/image/\(item1.menuImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlPath)
            let data1 = try! Data(contentsOf: url!)
            
            
            cell.imgMenuImage.image = UIImage(data: data1)
            menuTotalNum.text = "\(searchedMenu.count) 개의 제품"


        } else {  // 아닐때
            let item: BrandRankDBModel = feedItem[indexPath.row] as! BrandRankDBModel
//            let url = URL(string: "http://127.0.0.1:8080/moca/image/\(item.menuImg!)")
//            let data = try! Data(contentsOf: url!)

            
            var urlPath = "http://" + Share.macIP + "/moca/image/\(item.menuImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlPath)
            let data = try! Data(contentsOf: url!)
            
            
            cell.imgMenuImage.image = UIImage(data: data)
            cell.rankMenu.text = "\(indexPath.row + 1)"
            cell.lblMenuName.text = item.menuName
            cell.lblBrandName.text = item.brandName

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: Int(item.menuPrice!)!))
            cell.lblMenuPrice.text = "\(result!) 원"
            if item.reviewAvg == "null"{
                cell.lblReviewAvg.text = "⭐️ 0.0"
            } else {
                cell.lblReviewAvg.text = "⭐️ \(item.reviewAvg!)"
            }
            menuTotalNum.text = "\(feedItem.count) 개의 제품"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgCoffeeDetail" {
            let cell = sender as! UITableViewCell  // 선택된 cell 통째로 가져온다.
                let indexPath = self.tableViewList.indexPath(for: cell) // 선택된 cell 번호 가져온다.
                let detailView = segue.destination as! PhotoDetailReviewController  // detail controller 연결
            
            // search에 따른 검색 결과
            if searchedMenu.count == 0 {
                detailView.rankItem = feedItem[(indexPath! as NSIndexPath).row] as! BrandRankDBModel
            } else {
                detailView.rankItem = searchedMenu[(indexPath! as NSIndexPath).row]
            }
        }
    }
    
    // searchbar 선택되었을 때
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        let searchText : String = searchBar.text!

        if !searchText.isEmpty {
            searching = true
            searchedMenu.removeAll()

            for menu in menuArray {
                if menu.menuName!.contains(searchText) || menu.brandName!.contains(searchText){
                    print("검색된 메뉴 : ", menu.menuName!)
                    searchedMenu.append(menu)

                }
            }

        } else {
            searching = false
            searchedMenu.removeAll()
            searchedMenu = feedItem as! [BrandRankDBModel]

        }
        menuTotalNum.text = "\(searchedMenu.count) 개의 제품"

        tableViewList.reloadData()

    }
    
    // 검색 취소
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searching = false
        searchBar.text = ""
        searchedMenu.removeAll()
        tableViewList.reloadData()

        }
}
