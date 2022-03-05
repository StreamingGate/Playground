//
//  LogInViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Lottie
import Combine

class LoginViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPwButton: UIButton!
    @IBOutlet weak var autoLogInImageView: UIImageView!
    @IBOutlet weak var autoLogInLabel: UILabel!
    @IBOutlet weak var autoLogInButton: UIButton!
    var coordinator: MainCoordinator?
    let animationView: AnimationView = .init(name: "PgLoading")
    let loadingBackView = UIView()
    
    let viewModel = LoginViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = MainCoordinator(parent: nil, navigation: self.navigationController ?? UINavigationController())
        setupUI()
        bindData()
        // 회원가입 step1에서 비정상적인 종료가 된 경우, 해당 정보를 userDefaults에서 가져와서 회원가입 페이지로 유도
        // 비정상적인 종료 = 뒤로 가기나 닫기 등으로 종료되지 않은 모든 경우
        // step1에서 이메일 인증을 해야 하기 때문에, step2 이후에 비정상 종료는 회원가입 페이지로 유도하지 않음
        if UserDefaults.standard.bool(forKey: "onRegister") == true, (UserDefaults.standard.string(forKey: "onRegister-Email") != nil || UserDefaults.standard.string(forKey: "onRegister-Name") != nil) {
            self.onRegister()
        }
        
        if UserDefaults.standard.bool(forKey: "autoLogin") == true {
            autoLogInLabel.textColor = UIColor.PGBlue
            autoLogInImageView.tintColor = UIColor.PGBlue
            autoLogInImageView.image = UIImage(systemName: "checkmark.square.fill")
            guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue), let token = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let email = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.email.rawValue) else { return }
            self.idField.text = email
            animationView.setAutoLoginLoading(vc: self, backView: loadingBackView)
            viewModel.autoLogin(token: token, email: email, uuid: uuid)
        } else {
            autoLogInLabel.textColor = UIColor.lightGray
            autoLogInImageView.tintColor = UIColor.lightGray
            autoLogInImageView.image = UIImage(systemName: "square")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.idField.text = ""
        self.pwField.text = ""
    }
    
    // MARK: - UI Setting
    func setupUI() {
        forgotPwButton.titleLabel?.font = UIFont.caption
        forgotPwButton.setTitleColor(UIColor.placeHolder, for: .normal)
        autoLogInLabel.font = UIFont.caption
        autoLogInLabel.textColor = UIColor.placeHolder
        idField.font = UIFont.Content
        pwField.font = UIFont.Content
        logInButton.layer.cornerRadius = 5
    }
    
    func bindData() {
        viewModel.$isLoginSucceed.receive(on: RunLoop.main)
            .sink { [weak self] tf in
                guard let self = self, let result = tf else { return }
                if result {
                    self.animationView.stopLoading(backView: self.loadingBackView)
                    self.coordinator?.showTabPage()
                    self.viewModel.isLoginSucceed = nil
                } else {
                    self.simpleAlert(message: self.viewModel.failMessage ?? "로그인에 실패했습니다")
                    self.animationView.stopLoading(backView: self.loadingBackView)
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Move to Register page
    func onRegister() {
        let alert = UIAlertController(title: "", message: "회원가입 중이던 정보가 있습니다. 이어서 회원가입을 진행하시겠습니까?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "취소", style: .default) { _ in
            // 취소를 1회 누른 후부터는 비정상적 종료 회원가입에 대해 물어보지 않음
            UserDefaults.standard.set(false, forKey: "onRegister")
            UserDefaults.standard.removeObject(forKey: "onRegister-Email")
            UserDefaults.standard.removeObject(forKey: "onRegister-Name")
        }
        let action2 = UIAlertAction(title: "이동", style: .default) { _ in
            self.idField.text = ""
            self.pwField.text = ""
            self.coordinator?.showRegisterPage()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Button Action
    @IBAction func logInButtonDidTap(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
        guard let idInfo = idField.text, idInfo.isEmpty == false, let pwInfo = pwField.text, pwInfo.isEmpty == false else { return }
        print(TimeZone.current.identifier)
        animationView.setLoading(vc: self, backView: loadingBackView)
        viewModel.login(idInfo: idInfo, pwInfo: pwInfo)
    }
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
        coordinator?.showRegisterPage()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        idField.resignFirstResponder()
        pwField.resignFirstResponder()
    }
    
    @IBAction func autoLoginButtonDidTap(_ sender: Any) {
        let isAutoLoginActivate = UserDefaults.standard.bool(forKey: "autoLogin")
        UserDefaults.standard.set(!isAutoLoginActivate, forKey: "autoLogin")
        if !isAutoLoginActivate {
            autoLogInLabel.textColor = UIColor.PGBlue
            autoLogInImageView.tintColor = UIColor.PGBlue
            autoLogInImageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            autoLogInLabel.textColor = UIColor.lightGray
            autoLogInImageView.tintColor = UIColor.lightGray
            autoLogInImageView.image = UIImage(systemName: "square")
        }
    }
}
