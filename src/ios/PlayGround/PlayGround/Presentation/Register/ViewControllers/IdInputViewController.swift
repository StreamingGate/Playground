//
//  IdInputViewController.swift
//  StoveDevCamp_PersonalProject
//
//  Created by chuiseo-MN on 2021/12/15.
//

import Foundation
import UIKit

class IdInputViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idFormatCheckLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var sendVerifyMailButton: UIButton!
    
    @IBOutlet weak var verifyNumTitleLabel: UILabel!
    @IBOutlet weak var verifyNumTextField: UITextField!
    @IBOutlet weak var verifyNumUnderLine: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: UI Setting
    func setupUI() {
        sendVerifyMailButton.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        idTextField.font = UIFont.Content
        verifyNumTitleLabel.font = UIFont.SubTitle
        verifyNumTextField.font = UIFont.Content
//        if let idInfo = UserDefaults.standard.string(forKey: "onRegister-Email") {
//            idTextField.text = idInfo
//            if isValidEmail(input: idInfo) {
//                idFormatCheckLabel.isHidden = true
//                sendVerifyMailButton.isEnabled = true
//            } else {
//                idFormatCheckLabel.isHidden = false
//                idFormatCheckLabel.text = "올바른 형식의 이메일을 입력해주세요"
//                idFormatCheckLabel.textColor = UIColor.youtubeRed
//                sendVerifyMailButton.isEnabled = false
//            }
//        }
    }
    
    // MARK: Email(id) input
    func isValidEmail(input: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: input)
    }
    
    @IBAction func idTextFieldDidBegin(_ sender: Any) {
        idFormatCheckLabel.isHidden = false
        idFormatCheckLabel.text = "이메일을 입력해주세요"
        idFormatCheckLabel.textColor = UIColor.PGBlue
        sendVerifyMailButton.isEnabled = false
    }
    
    @IBAction func idTextFieldEditingChanged(_ sender: Any) {
        guard let idInfo = idTextField.text, idInfo.isEmpty == false else {
            idFormatCheckLabel.isHidden = false
            idFormatCheckLabel.text = "이메일을 입력해주세요"
            idFormatCheckLabel.textColor = UIColor.PGBlue
            sendVerifyMailButton.isEnabled = false
//            UserDefaults.standard.set(false, forKey: "onRegister")
            return
        }
        sendVerifyMailButton.isEnabled = isValidEmail(input: idInfo)
//        UserDefaults.standard.set(true, forKey: "onRegister")
//        UserDefaults.standard.set(idInfo, forKey: "onRegister-Email")
    }
    
    
    // MARK: Verify Num Input
    @IBAction func verifyNumTextFieldEditingChanged(_ sender: Any) {
        guard let verifyInputInfo = verifyNumTextField.text, verifyInputInfo.isEmpty == false else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
    }
    
    // MARK: Button Action
    // 인증번호 전송 버튼
    @IBAction func sendVerifyMailButtonDidTap(_ sender: Any) {
        guard let idInfo = idTextField.text, idInfo.isEmpty == false else { return }
        sendVerifyMailButton.isEnabled = false
        sendVerifyMailButton.isHidden = true
        verifyNumTextField.isHidden = false
        verifyNumUnderLine.isHidden = false
        verifyNumTitleLabel.isHidden = false
        nextButton.isHidden = false
    }
    
    // 다음
    @IBAction func nextButtonDidTap(_ sender: Any) {
        guard let verifyInput = verifyNumTextField.text, verifyInput.isEmpty == false, let inputNum = Int(verifyInput) else { return }
        nextButton.isEnabled = false
        guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "NickNameInputViewController") as? NickNameInputViewController else { return }
        vc.nameInfo = nameTextField.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 백그라운드 탭
    @IBAction func backButtonDidTap(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "onRegister")
        UserDefaults.standard.removeObject(forKey: "onRegister-Email")
        dismiss(animated: true, completion: nil)
    }
}
