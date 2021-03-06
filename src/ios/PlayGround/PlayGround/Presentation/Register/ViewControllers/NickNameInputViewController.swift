//
//  NickNameInputViewController.swift
//  StoveDevCamp_PersonalProject
//
//  Created by chuiseo-MN on 2021/12/15.
//

import Foundation
import UIKit
import Photos
import Lottie

class NickNameInputViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameValidCheckLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var defaultImageButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    let firstCharacterLabel = UILabel()
    let imagePicker = UIImagePickerController()
    let profileImageView = UIImageView()
    var nameInfo: String = ""
    let backgroundColor = [UIColor(red: 1, green: 0.797, blue: 0.275, alpha: 1), UIColor(red: 0.335, green: 0.563, blue: 0.904, alpha: 1), UIColor(red: 0.838, green: 0.59, blue: 0.925, alpha: 1), UIColor(red: 0.929, green: 0.391, blue: 0.391, alpha: 1), UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1), UIColor(red: 0.578, green: 0.867, blue: 0.693, alpha: 1), UIColor(red: 0.332, green: 0.812, blue: 0.784, alpha: 1), UIColor(red: 0.946, green: 0.43, blue: 0.615, alpha: 1)]
    var randomColor = UIColor.placeHolder
    let animationView: AnimationView = .init(name: "PgLoading")
    let loadingBackView = UIView()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        self.setupUI()
        self.setupProfileImageLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 기본 이미지 상태 이후 아무 변경 사항이 없을 경우,
        // step3로 넘어갈 때, cornerRadius가 들어가지 않은 기본 이미지를 저장
        if profileImageView.isHidden {
            profileView.layer.cornerRadius = 0
            let image = profileView.snapshotView(afterScreenUpdates: true)?.takeScreenshot(color: self.randomColor, character: "\(nameInfo.first ?? "플")")
            RegisterHelper.shared.profileImage = image
        }
    }
    
    // MARK: - UI Setting
    func setupUI() {
        step1View.layer.cornerRadius = 10
        step2View.layer.cornerRadius = 10
        step3View.layer.cornerRadius = 10
        profileView.backgroundColor = backgroundColor.randomElement() ?? UIColor.placeHolder
        profileView.layer.cornerRadius = 50
        nextButton.layer.cornerRadius = 5
        selectButton.layer.cornerRadius = 5
        defaultImageButton.layer.cornerRadius = 5
        defaultImageButton.layer.borderColor = UIColor.separator.cgColor
        defaultImageButton.layer.borderWidth = 1
        nickNameTextField.font = UIFont.Content
        firstCharacterLabel.translatesAutoresizingMaskIntoConstraints = false
        firstCharacterLabel.textColor = UIColor.white
        firstCharacterLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 70) ?? UIFont.systemFont(ofSize: 70)
        firstCharacterLabel.textAlignment = .center
        firstCharacterLabel.text = "\(nameInfo.first ?? "플")"
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.isHidden = true
    }
    
    // 기본 이미지 및 사진 파일을 위한 레이아웃 설정
    func setupProfileImageLayout() {
        self.profileView.addSubview(firstCharacterLabel)
        self.profileView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            firstCharacterLabel.leadingAnchor.constraint(equalTo: self.profileView.leadingAnchor),
            firstCharacterLabel.trailingAnchor.constraint(equalTo: self.profileView.trailingAnchor),
            firstCharacterLabel.centerYAnchor.constraint(equalTo: self.profileView.centerYAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: self.profileView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.profileView.trailingAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.profileView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.profileView.bottomAnchor)
        ])
    }
    
    // MARK: - Nickname Input
    @IBAction func nickNameTextFieldEditingChanged(_ sender: Any) {
        guard let nickNameInfo = nickNameTextField.text, nickNameInfo.isEmpty == false else {
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 8글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.systemRed
            nextButton.isEnabled = false
            return
        }
        if nickNameInfo.count > 8 {
            nickNameTextField.deleteBackward()
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 8글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.systemRed
        } else {
            nickNameValidCheckLabel.isHidden = true
            nextButton.isEnabled = true
        }
    }
    
    // MARK: - Button Action
    // 파일에서 선택 버튼
    @IBAction func selectButtonDidTap(_ sender: Any) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // 기본 이미지로 변경 버튼
    @IBAction func defaultImageButtonDidTap(_ sender: Any) {
        profileImageView.isHidden = true
        profileView.layer.cornerRadius = 0
        randomColor = backgroundColor.randomElement() ?? UIColor.placeHolder
        let image = profileView.snapshotView(afterScreenUpdates: true)?.takeScreenshot(color: self.randomColor, character: "\(nameInfo.first ?? "플")")
        profileView.layer.cornerRadius = 50
        RegisterHelper.shared.profileImage = image
    }

    // 다음 버튼
    @IBAction func nextButtonDidTap(_ sender: Any) {
        guard let nickNameInfo = nickNameTextField.text, nickNameInfo.isEmpty == false else { return }
        nextButton.isEnabled = false
        self.animationView.setLoading(vc: self, backView: self.loadingBackView)
        UserServiceAPI.shared.nicknameDuplicateCheck(nickname: nickNameInfo) { result in
            print("nickname check result = \(result)")
            if let nickname = result["nickName"] as? String, nickname != "failed" {
                RegisterHelper.shared.nickName = nickname
                DispatchQueue.main.async {
                    self.animationView.stopLoading(backView: self.loadingBackView)
                    self.nextButton.isEnabled = true
                    guard let pwVC = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "PwInputViewController") as? PwInputViewController else { return }
                    self.navigationController?.pushViewController(pwVC, animated: true)
                }
            } else {
                // 오류
                DispatchQueue.main.async {
                    self.animationView.stopLoading(backView: self.loadingBackView)
                    self.nickNameValidCheckLabel.isHidden = false
                    self.nickNameValidCheckLabel.text = "새 닉네임을 입력해주세요"
                    self.nickNameValidCheckLabel.textColor = UIColor.systemRed
                    self.simpleAlert(message: "이미 사용 중인 닉네임입니다")
                    self.nextButton.isEnabled = true
                }
            }
        }
    }
    
    // 뒤로 가기
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Profile Image Pick
extension NickNameInputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.profileImageView.isHidden = false
        self.profileImageView.image = newImage
        RegisterHelper.shared.profileImage = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}
