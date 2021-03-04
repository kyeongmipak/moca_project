//
//  EmailPwSearchViewController.swift
//  Moca
//
//  Created by 김대환 on 2021/03/05.
//

import UIKit

class EmailPwSearchViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.isHidden = true
        emailTextField.isHidden = true
    }
    
    @IBAction func idPwSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            emailLabel.isHidden = true
            emailTextField.isHidden = true
            emailTextField.text = ""
            nameTextField.text = ""
            phoneTextField.text = ""
            searchButton.setTitle("아이디 찾기", for: .normal)
        case 1:
            emailLabel.isHidden = false
            emailTextField.isHidden = false
            emailTextField.text = ""
            nameTextField.text = ""
            phoneTextField.text = ""
            searchButton.setTitle("비밀번호 찾기", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func actionSearchButton(_ sender: UIButton) {
    }
    

}
