//
//  SearchViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, SearchJsonModelProtocol  {

    @IBOutlet weak var tableViewList: UITableView!
    
    var feedItem: NSArray = NSArray()
    var menuArray = [SearchDBModel]()
    var searching = false
    var searchedMenu = [SearchDBModel]()
    
    // 검색창
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewList.dataSource = self
        tableViewList.delegate = self
        
        let searchJsonModel = SearchJsonModel()
        searchJsonModel.delegate = self
        searchJsonModel.downloadItems()
        
        // 검색창 셋팅
        configureSearchController()
        
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        menuArray = items as! [SearchDBModel]
        self.tableViewList.reloadData()
    }
    
    // 검색 시 업데이트
    func updateSearchResults(for searchController: UISearchController) {
        searchedMenu.removeAll()
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            searching = true
            searchedMenu.removeAll()

            for menu in menuArray {
                if menu.menuName!.contains(searchText) || menu.brandName!.contains(searchText) {
                    print("검색된 메뉴 : ", menu.menuName!)
                    searchedMenu.append(menu)

                }
            }

        } else {
            searching = false
            searchedMenu.removeAll()
            searchedMenu = feedItem as! [SearchDBModel]

        }
        tableViewList.reloadData()
    }
    
    // 검색 취소
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedMenu.removeAll()
        tableViewList.reloadData()
    }
    
    // 검색일때 아닐때 구분하여 리스트 구성
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedMenu.count
            
        } else {
            return menuArray.count
            
        }
    }
    
    // cell 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        if searching { // 검색할때
            let item1: SearchDBModel = searchedMenu[indexPath.row]

            cell.menuNameLbl.text = item1.menuName
            cell.brandNameLbl.text = item1.brandName
            var urlPath = "http://" + Share.macIP + "/moca/image/\(item1.menuImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url1 = URL(string: urlPath)
            let data1 = try! Data(contentsOf: url1!)
            cell.searchImgView.image = UIImage(data: data1)
        
            
        } else {  // 아닐때
            let item: SearchDBModel = feedItem[indexPath.row] as! SearchDBModel
            var urlPath = "http://" + Share.macIP + "/moca/image/\(item.menuImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlPath)
            let data = try! Data(contentsOf: url!)
            
            cell.menuNameLbl.text = item.menuName
            cell.brandNameLbl.text = item.brandName
            cell.searchImgView.image = UIImage(data: data)
        
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgProductDetail" {
            let cell = sender as! UITableViewCell  // 선택된 cell 통째로 가져온다.
                let indexPath = self.tableViewList.indexPath(for: cell) // 선택된 cell 번호 가져온다.
                let detailView = segue.destination as! PhotoDetailReviewController  // detail controller 연결
            
            // search에 따른 검색 결과
            if searchedMenu.count == 0 {
                detailView.menuItem = feedItem[(indexPath! as NSIndexPath).row] as! SearchDBModel
            } else {
                detailView.menuItem = searchedMenu[(indexPath! as NSIndexPath).row]
            }
        }
    }
    
    // 검색바 셋팅
    private func configureSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "메뉴나 브랜드를 검색하세요."
        
    }
}
