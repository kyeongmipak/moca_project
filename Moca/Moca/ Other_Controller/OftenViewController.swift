//
//  OftenViewController.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import UIKit

class OftenViewController: UITableViewController {
    var allSections: [QnaData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "지은 자주 묻는 질문 알앤디"
        
        let sectionA = QnaData(title: "고객센터 안내", items: ["서비스 이용의 변경 및 오류는 자사 고객센터로 문의 부탁드립니다.","Email : qkrwldms011@naver.com","Call : 010-0000-0000", "이용시간 : 10:00 ~ 17:00 (토,일, 공휴일 휴무)"])
        let sectionB = QnaData(title: "모카 회원가입은 필수인가요?", items: ["저희 모카의 어플은 회원가입을 하지 않아도 순위나 위치 이용이 ", "가능합니다. 하지만 리뷰 작성이나 찜등을 이용하시기 위해선 ", "회원가입이 필요합니다."])
        let sectionC = QnaData(title: "모카 회원가입은 어떻게 하나요?", items: ["회원가입은 [마이페이지]-[로그인 및 회원가입]을 통해 진행", "하실 수 있습니다.","이메일 계정으로 가입이 가능합니다.","가입시 리뷰작성, 찜 등록이 가능합니다."])
        let sectionD = QnaData(title: "모카 계정 탈퇴를 하고 싶어요.", items: ["회원탈퇴를 원하시는군요😭","회원탈퇴는, [마이페이지]-[버튼(회원탈퇴)]를 통해 진행가능합니다.","탈퇴시엔 저장하셨던 찜한 데이터 기록은 모두 삭제되어 복구가 ", "어렵습니다. 이점 이용에 참고 부탁드립니다."])
        
        allSections = [sectionA, sectionB, sectionC, sectionD]
    }
    
    //MARK: UITableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int{
        return allSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let sectionData = allSections[section]
        if sectionData.isExpand {
            return sectionData.items.count
        } else {
            return 0
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QnaCell", for: indexPath)
        let sectionData = allSections[indexPath.section]
        
        if sectionData.isExpand {
            let text = sectionData.items[indexPath.row]
            cell.textLabel?.text = text
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = UIColor.init(red: 232/255, green: 218/255, blue: 179/255, alpha: 1)
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-20, height: 30)) as UILabel
        headerString.textColor = UIColor.black
        headerString.font = UIFont.systemFont(ofSize: 18)
        let title = allSections[section].title
        headerString.text = title
        headerView.addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:#selector(OftenViewController.sectionHeaderTapped(_:)))
        headerView .addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    // Handle Tap on section
    @objc func sectionHeaderTapped(_ tapped: UITapGestureRecognizer){
        guard let section = tapped.view?.tag else {
//            print("Cannot found tapped view tag")
            return
        }
        
        if allSections.indices.contains(section) {
            let currentState = allSections[section].isExpand
            allSections[section].isExpand = !currentState
        }
        
        // Relaod tableview with animation
        tableView.reloadSections(IndexSet(integer: section), with: UITableView.RowAnimation.fade)
    }
    
    // Handle collaspable flag
    func changeFlagForSection(_ section: Int) {

    }

    
}

// String to int conversion
extension String{

    func toInt()->Int{
        return Int(self)!
    }
    
}
