//
//  MainViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TipTableViewCellDelegate, BrandRankTableViewCellDelegate, CategoryRankTableViewCellDelegate {
   
    @IBOutlet weak var tableViewList: UITableView!
    
    var brandName = ""
    var categoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: true)
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...3:
            return 1
        
        default:
            return 0
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
       
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as!BannerTableViewCell

            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipTableViewCell", for: indexPath) as!TipTableViewCell
            
            cell.delegate = self
          
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandRankTableViewCell", for: indexPath) as! BrandRankTableViewCell
            
            cell.delegate = self
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryRankTableViewCell", for: indexPath) as! CategoryRankTableViewCell

            cell.delegate = self
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as!BannerTableViewCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
            
        } else {
            return 180
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        tableViewList.reloadData()
    
    }
    
    // 관리자 팁
    func selectedInfoBtn() {
        // segue 실행시키기 위한 명령어 : performSegue
        self.performSegue(withIdentifier: "tipPageMove", sender: self)

    }
    
    // 브랜드별 랭킹
    func selectedInfoBtn(name: String) {
        brandName = name
        
        self.performSegue(withIdentifier: "brandRankPageMove", sender: self)
    }
    
    // 카테고리별 랭킹
    func categorySelectedInfoBtn(category: String) {
        categoryName = category
        self.performSegue(withIdentifier: "categoryRankPageMove", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 브랜드별 랭킹 조회
        if segue.identifier == "brandRankPageMove"{
           let brandView = segue.destination as! BrandRankViewController
            brandView.reveiveItem = brandName

        } else if segue.identifier == "categoryRankPageMove" {
            let categoryView = segue.destination as! CategoryRankViewController
            categoryView.reveiveItem = categoryName
        }

    }
}
