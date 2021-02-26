//
//  MyPageViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var alertImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapAlert = UITapGestureRecognizer(target: self, action: #selector(touchToAlert))
        alertImg.addGestureRecognizer(tapAlert)
        alertImg.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
    }
    
    @objc func touchToAlert(sender: UITapGestureRecognizer) {
        
        if (sender.state == .ended) {
            // 켜져있을 때
            if alertImg.image == UIImage(named: "on.png") {
                print("끄기")
                alertImg.image = UIImage(named: "off.png")
            }else{
                // 꺼져있을 때
                print("켜기")
                alertImg.image = UIImage(named: "on.png")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
