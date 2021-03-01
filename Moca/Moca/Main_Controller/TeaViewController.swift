//
//  TeaViewController.swift
//  Main_FINIALLY_2.26
//
//  Created by 박경미 on 2021/02/28.
//

import UIKit

class TeaViewController: UIViewController, UITableViewDelegate, CategoryRankJsonModelProtocol, UITableViewDataSource, UISearchBarDelegate {

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
        feedItem = items
        menuArray = items as! [BrandRankDBModel]
        searchBar.placeholder = "브랜드 또는 메뉴를 검색하세요."
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeaTableViewCell") as! TeaTableViewCell

        if searching { // 검색할때
            let item1: BrandRankDBModel = searchedMenu[indexPath.row]

            cell.rankMenu.text = "\(indexPath.row + 1)"
            cell.lblMenuName.text = item1.menuName
            cell.lblBrandName.text = item1.brandName

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: Int(item1.menuPrice!)!))
            cell.lblMenuPrice.text = "\(result!) 원"
            cell.lblReviewAvg.text = "⭐️ \(item1.reviewAvg!)"

            let url1 = URL(string: "http://127.0.0.1:8080/png/\(item1.menuImg!)")
            let data1 = try! Data(contentsOf: url1!)
            cell.imgMenuImage.image = UIImage(data: data1)
            menuTotalNum.text = "\(searchedMenu.count) 개의 제품"


        } else {  // 아닐때
            let item: BrandRankDBModel = feedItem[indexPath.row] as! BrandRankDBModel

            let url = URL(string: "http://127.0.0.1:8080/png/\(item.menuImg!)")
            let data = try! Data(contentsOf: url!)

            cell.imgMenuImage.image = UIImage(data: data)
            cell.rankMenu.text = "\(indexPath.row + 1)"
            cell.lblMenuName.text = item.menuName
            cell.lblBrandName.text = item.brandName

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: Int(item.menuPrice!)!))
            cell.lblMenuPrice.text = "\(result!) 원"
            cell.lblReviewAvg.text = "⭐️ \(item.reviewAvg!)"
            menuTotalNum.text = "\(feedItem.count) 개의 제품"
            
        }
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgTeaDetail" {
            let cell = sender as! UITableViewCell  // 선택된 cell 통째로 가져온다.
                let indexPath = self.tableViewList.indexPath(for: cell) // 선택된 cell 번호 가져온다.
                let detailView = segue.destination as! ProductDetailViewController  // detail controller 연결
            detailView.reveiveItem = feedItem[(indexPath! as NSIndexPath).row] as! BrandRankDBModel
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