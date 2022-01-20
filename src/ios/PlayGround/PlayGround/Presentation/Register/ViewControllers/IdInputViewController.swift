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
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    var timeLeft = 600
    var timer = Timer()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeVerifyUI()
    }
    
    // MARK: UI Setting
    func setupUI() {
        sendVerifyMailButton.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        idTextField.font = UIFont.Content
        verifyNumTitleLabel.font = UIFont.SubTitle
        verifyNumTextField.font = UIFont.Content
        timerLabel.font = UIFont.Content
        timerLabel.textColor = UIColor.placeHolder
        step1View.layer.cornerRadius = 10
        step2View.layer.cornerRadius = 10
        step3View.layer.cornerRadius = 10
        if let idInfo = UserDefaults.standard.string(forKey: "onRegister-Email") {
            idTextField.text = idInfo
            if isValidEmail(input: idInfo) {
                idFormatCheckLabel.isHidden = true
            } else {
                idFormatCheckLabel.isHidden = false
                idFormatCheckLabel.text = "올바른 형식의 이메일을 입력해주세요"
                idFormatCheckLabel.textColor = UIColor.systemRed
                sendVerifyMailButton.isEnabled = false
            }
        }
        if let nameInfo = UserDefaults.standard.string(forKey: "onRegister-Name") {
            nameTextField.text = nameInfo
        }
        self.sendButtonAvailability()
    }
    
    func initializeVerifyUI() {
        timer.invalidate()
        self.sendVerifyMailButton.isHidden = false
        self.sendVerifyMailButton.isEnabled = true
        self.verifyNumTextField.isHidden = true
        self.verifyNumTextField.text = ""
        self.verifyNumUnderLine.isHidden = true
        self.verifyNumTitleLabel.isHidden = true
        self.timerLabel.isHidden = true
        self.nextButton.isHidden = true
    }
    
    // MARK: name input
    @IBAction func nameTextFieldEditingChanged(_ sender: Any) {
        sendButtonAvailability()
        guard let nameInfo = nameTextField.text, nameInfo.isEmpty == false else {
            return
        }
        UserDefaults.standard.set(true, forKey: "onRegister")
        UserDefaults.standard.set(nameInfo, forKey: "onRegister-Name")
    }
    
    // MARK: Email(id) input
    func isValidEmail(input: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: input)
    }
    
    @IBAction func idTextFieldEditingChanged(_ sender: Any) {
        sendButtonAvailability()
        guard let idInfo = idTextField.text, idInfo.isEmpty == false else {
            idFormatCheckLabel.isHidden = false
            idFormatCheckLabel.text = "이메일을 입력해주세요"
            idFormatCheckLabel.textColor = UIColor.PGBlue
            sendVerifyMailButton.isEnabled = false
            return
        }
        if isValidEmail(input: idInfo) {
            idFormatCheckLabel.isHidden = true
        } else {
            idFormatCheckLabel.isHidden = false
            idFormatCheckLabel.text = "올바른 이메일 형식을 입력해주세요"
            idFormatCheckLabel.textColor = UIColor.PGBlue
        }
        UserDefaults.standard.set(true, forKey: "onRegister")
        UserDefaults.standard.set(idInfo, forKey: "onRegister-Email")
    }
    
    // MARK: Verify Num Input
    @IBAction func verifyNumTextFieldEditingChanged(_ sender: Any) {
        guard let verifyInputInfo = verifyNumTextField.text, verifyInputInfo.isEmpty == false else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
    }
    
    func sendButtonAvailability() {
        if let nameInfo = nameTextField.text, nameInfo.isEmpty == false, let emailInfo = idTextField.text, emailInfo.isEmpty == false {
            if isValidEmail(input: emailInfo) {
                sendVerifyMailButton.isEnabled = true
            } else {
                sendVerifyMailButton.isEnabled = false
            }
        } else {
            UserDefaults.standard.set(false, forKey: "onRegister")
            UserDefaults.standard.removeObject(forKey: "onRegister-Email")
            UserDefaults.standard.removeObject(forKey: "onRegister-Name")
            sendVerifyMailButton.isEnabled = false
        }
    }
    
    // MARK: Button Action
    // 인증번호 전송 버튼
    @IBAction func sendVerifyMailButtonDidTap(_ sender: Any) {
        guard let idInfo = idTextField.text, idInfo.isEmpty == false else { return }
        sendVerifyMailButton.isEnabled = false
        UserServiceAPI.shared.sendEmailVerification(email: idInfo) { result in
            print("email send result = \(result)")
            if result == idInfo {
                DispatchQueue.main.async {
                    self.sendVerifyMailButton.isHidden = true
                    self.verifyNumTextField.isHidden = false
                    self.verifyNumUnderLine.isHidden = false
                    self.verifyNumTitleLabel.isHidden = false
                    self.timerLabel.isHidden = false
                    self.nextButton.isHidden = false
                    self.timeLeft = 600
                    self.timer.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                }
            } else {
                // 오류
                DispatchQueue.main.async {
                    let converter = ErrorCodeConverter()
                    let errorType = converter.parse(result)
                    let alert = UIAlertController(title: "", message: errorType.rawValue, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    self.sendVerifyMailButton.isEnabled = true
                }
            }
        }
    }
    
    // 다음
    @IBAction func nextButtonDidTap(_ sender: Any) {
        guard let verifyInput = verifyNumTextField.text, verifyInput.isEmpty == false, let nameInput = nameTextField.text, nameInput.isEmpty == false, let emailInput  = idTextField.text, emailInput.isEmpty == false else { return }
        nextButton.isEnabled = false
        // 인증확인 성공
        UserServiceAPI.shared.checkVerificationCode(code: verifyInput) { result in
            print("code check result = \(result)")
            if result == emailInput {
                RegisterHelper.shared.email = emailInput
                RegisterHelper.shared.name = nameInput
                RegisterHelper.shared.isVerified = true
                UserDefaults.standard.set(false, forKey: "onRegister")
                UserDefaults.standard.removeObject(forKey: "onRegister-Email")
                UserDefaults.standard.removeObject(forKey: "onRegister-Name")
                DispatchQueue.main.async {
                    self.nextButton.isEnabled = true
                    guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "NickNameInputViewController") as? NickNameInputViewController else { return }
                    vc.nameInfo = nameInput
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                // 오류
                DispatchQueue.main.async {
                    let converter = ErrorCodeConverter()
                    let errorType = converter.parse(result)
                    let alert = UIAlertController(title: "", message: errorType.rawValue, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    self.nextButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "onRegister")
        UserDefaults.standard.removeObject(forKey: "onRegister-Email")
        UserDefaults.standard.removeObject(forKey: "onRegister-Name")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func timerAction() {
        if timeLeft == 0 {
            timer.invalidate()
            self.sendVerifyMailButton.isHidden = false
            self.sendVerifyMailButton.isEnabled = true
            self.verifyNumTextField.isHidden = true
            self.verifyNumTextField.text = ""
            self.verifyNumUnderLine.isHidden = true
            self.verifyNumTitleLabel.isHidden = true
            self.timerLabel.isHidden = true
            self.nextButton.isHidden = true
            return
        }
        timeLeft -= 1
        let mins = timeLeft / 60
        let secs = timeLeft % 60
        timerLabel.text = "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
    }
}
