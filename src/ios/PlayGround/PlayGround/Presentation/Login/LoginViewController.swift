//
//  LogInViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/04.
//

import Foundation
import UIKit

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
    
    @IBAction func logInButtonDidTap(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
        guard let idInfo = idField.text, idInfo.isEmpty == false, let pwInfo = pwField.text, pwInfo.isEmpty == false else { return }
        print(TimeZone.current.identifier)
        UserServiceAPI.shared.login(email: idInfo, password: pwInfo, timezone: TimeZone.current.identifier, fcmtoken: "token") { result in
            print("login result = \(result)")
            if result["success"] as? Int == 1, let uuid = result["uuid"] as? String, let token = result["accessToken"] as? String {
                KeychainWrapper.standard.set(uuid, forKey: KeychainWrapper.Key.uuid.rawValue)
                KeychainWrapper.standard.set(token, forKey: KeychainWrapper.Key.accessToken.rawValue)
                DispatchQueue.main.async {
                    self.coordinator?.showTabPage()
                }
            } else {
                // 실패
                DispatchQueue.main.async {                
                    let alert = UIAlertController(title: "", message: "로그인에 실패했습닏다", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
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
