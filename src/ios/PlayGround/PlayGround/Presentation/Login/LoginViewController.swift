//
//  LogInViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPwButton: UIButton!
    @IBOutlet weak var autoLogInImageView: UIImageView!
    @IBOutlet weak var autoLogInLabel: UILabel!
    @IBOutlet weak var autoLogInButton: UIButton!
    
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = MainCoordinator(parent: nil, navigation: self.navigationController ?? UINavigationController())
        coordinator?.start()
        setupUI()
        if UserDefaults.standard.bool(forKey: "onRegister") == true, (UserDefaults.standard.string(forKey: "onRegister-Email") != nil || UserDefaults.standard.string(forKey: "onRegister-Name") != nil) {
            self.onRegister()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    func setupUI() {
        forgotPwButton.titleLabel?.font = UIFont.caption
        forgotPwButton.setTitleColor(UIColor.placeHolder, for: .normal)
        autoLogInLabel.font = UIFont.caption
        autoLogInLabel.textColor = UIColor.placeHolder
        idField.font = UIFont.Content
        pwField.font = UIFont.Content
        logInButton.layer.cornerRadius = 5
    }
    
    func onRegister() {
        let alert = UIAlertController(title: "", message: "회원가입 중이던 정보가 있습니다. 이어서 회원가입을 진행하시겠습니까?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "취소", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: "onRegister")
            UserDefaults.standard.removeObject(forKey: "onRegister-Email")
            UserDefaults.standard.removeObject(forKey: "onRegister-Name")
        }
        let action2 = UIAlertAction(title: "이동", style: .default) { _ in
            guard let registerPage = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "RegisterNavigationController") as? RegisterNavigationController else { return }
            registerPage.modalPresentationStyle = .fullScreen
            self.present(registerPage, animated: true, completion: {
                self.idField.text = ""
                self.pwField.text = ""
            })
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logInButtonDidTap(_ sender: Any) {
//        KeychainWrapper.standard.set("33333333-1234-1234-123456789012", forKey: KeychainWrapper.Key.uuid.rawValue)
//        self.coordinator?.showTabPage()
//        
        
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
        guard let idInfo = idField.text, idInfo.isEmpty == false, let pwInfo = pwField.text, pwInfo.isEmpty == false else { return }
        print(TimeZone.current.identifier)
        UserServiceAPI.shared.login(email: idInfo, password: pwInfo, timezone: TimeZone.current.identifier, fcmtoken: "token") { result in
            print("login result = \(result)")
            if result["success"] as? Int == 1, let uuid = result["uuid"] as? String, let token = result["accessToken"] as? String, let userInfo = result["data"] as? UserInfo {
                KeychainWrapper.standard.set(uuid, forKey: KeychainWrapper.Key.uuid.rawValue)
                KeychainWrapper.standard.set(token, forKey: KeychainWrapper.Key.accessToken.rawValue)
                DispatchQueue.main.async {
                    self.coordinator?.showTabPage()
                }
            } else {
                // 실패
                DispatchQueue.main.async {
                    self.simpleAlert(message: "로그인에 실패했습니다")
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.idField.text = ""
        self.pwField.text = ""
    }
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
        guard let registerVC = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "RegisterNavigationController") as? RegisterNavigationController else { return }
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
    }
}
