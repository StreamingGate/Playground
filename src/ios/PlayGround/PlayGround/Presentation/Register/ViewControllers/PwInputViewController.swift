//
//  PwInputViewController.swift
//  StoveDevCamp_PersonalProject
//
//  Created by chuiseo-MN on 2021/12/15.
//

import Foundation
import UIKit
//import SwiftKeychainWrapper

class PwInputViewController: UIViewController{
    
    // MARK: - Properties
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pwValidLabel: UILabel!
    @IBOutlet weak var pwCheckValidLabel: UILabel!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        step1View.layer.cornerRadius = 10
        step2View.layer.cornerRadius = 10
        step3View.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 5
        pwTextField.font = UIFont.Content
        pwCheckTextField.font = UIFont.Content
    }
    
    // MARK: - Password TextField Input
    // 비밀번호 textField 변경
    @IBAction func pwTextFieldEditingChanged(_ sender: Any) {
        guard let pwInfo = pwTextField.text, pwInfo.isEmpty == false else {
            pwCheckTextField.isEnabled = false
            return
        }
        if isValidated(pwInfo) {
            pwValidLabel.text = "올바른 형식의 비밀번호입니다"
            pwValidLabel.textColor = UIColor.PGBlue
            pwCheckTextField.isEnabled = true
            pwCheckValidLabel.isHidden = false
            pwCheckValidLabel.text = "비밀번호를 확인해주세요"
            pwCheckValidLabel.textColor = UIColor.systemRed
        } else {
            pwValidLabel.text = "영문 소문자와 숫자를 포함한 6~16자"
            pwValidLabel.textColor = UIColor.systemRed
            pwCheckValidLabel.isHidden = true
            pwCheckTextField.isEnabled = false
        }
        if let pwCheckInfo = pwCheckTextField.text, pwCheckInfo.isEmpty == false {
            pwCheckValidLabel.isHidden = true
            pwCheckTextField.text = ""
            registerButton.isEnabled = false
        } else {
            pwCheckValidLabel.isHidden = true
            registerButton.isEnabled = false
        }
    }
    
    // 비밀번호 확인 textField 변경
    @IBAction func pwCheckTextFieldEditingChanged(_ sender: Any) {
        guard let pwInfo = pwTextField.text, pwInfo.isEmpty == false, let pwCheckInfo = pwCheckTextField.text, pwCheckInfo.isEmpty == false else {
            pwCheckValidLabel.text = "비밀번호를 다시 입력해주세요"
            pwCheckValidLabel.textColor = UIColor.systemRed
            registerButton.isEnabled = false
            return
        }
        if pwInfo == pwCheckInfo {
            pwCheckValidLabel.isHidden = false
            pwCheckValidLabel.text = "비밀번호가 일치합니다"
            pwCheckValidLabel.textColor = UIColor.PGBlue
            registerButton.isEnabled = true
        } else {
            pwCheckValidLabel.isHidden = false
            pwCheckValidLabel.text = "비밀번호가 일치하지 않습니다"
            pwCheckValidLabel.textColor = UIColor.systemRed
            registerButton.isEnabled = false
        }
    }
    
    // 비밀번호 형식 확인
    // 영어소문자 + 숫자 조합의 6~16자
    func isValidated(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var digit: Bool = false
        if password.count  >= 6 && password.count <= 16 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
            }
            if (digit && lowerCaseLetter) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    // MARK: - Button Action
    // 가입하기
    @IBAction func registerButtonDidTap(_ sender: Any) {
        guard let pwInfo = pwTextField.text, pwInfo.isEmpty == false, let emailInfo = RegisterHelper.shared.email, let nameInfo = RegisterHelper.shared.name, let nicknameInfo = RegisterHelper.shared.nickName, let profileImage = RegisterHelper.shared.profileImage else { return }
        UserServiceAPI.shared.register(email: emailInfo, name: nameInfo, nickName: nicknameInfo, password: pwInfo, profileImage: "test") { userInfo in
            print("register result = \(userInfo)")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // 뒤로 가기
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
