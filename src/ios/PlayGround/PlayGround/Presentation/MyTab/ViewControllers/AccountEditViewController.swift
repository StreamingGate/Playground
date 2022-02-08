//
//  AccountEditViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import Combine

class AccountEditViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nickNameCountingLabel: UILabel!
    var coordinator: AccountEditCoordinator?
    let imagePicker = UIImagePickerController()
    let firstCharacterLabel = UILabel()
    let plainProfileImageView = UIImageView()
    var lastProfileSelectType: Int = 2
    var imageInfo: UIImage?
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        setupUI()
        bindData()
        setupProfileImageLayout()
    }
    
    func setupUI() {
        titleLabel.font = UIFont.SubTitle
        nicknameLabel.textColor = UIColor.placeHolder
        nicknameLabel.font = UIFont.caption
        nicknameTextField.font = UIFont.Content
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderColor = UIColor.placeHolder.cgColor
        profileImageView.layer.borderWidth = 1
        nickNameCountingLabel.font = UIFont.caption
        nickNameCountingLabel.textColor = UIColor.placeHolder
        
        guard let userInfo = UserManager.shared.userInfo else { return }
        profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
        nicknameTextField.text = userInfo.nickName
        
        firstCharacterLabel.translatesAutoresizingMaskIntoConstraints = false
        firstCharacterLabel.textColor = UIColor.white
        firstCharacterLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 70) ?? UIFont.systemFont(ofSize: 70)
        firstCharacterLabel.textAlignment = .center
        firstCharacterLabel.text = "\(userInfo.name?.first ?? "플")"
        plainProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        plainProfileImageView.backgroundColor = UIColor.lightGray
        plainProfileImageView.layer.cornerRadius = 50
        plainProfileImageView.layer.masksToBounds = true
    }
    
    func bindData() {
        UserManager.shared.$userInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] user in
                guard let self = self, let userInfo = user else { return }
                self.profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
                self.nicknameTextField.text = userInfo.nickName
                self.nickNameCountingLabel.text = "\(userInfo.nickName?.count ?? 0)/8"
            }.store(in: &cancellable)
    }
    
    // 기본 이미지 및 사진 파일을 위한 레이아웃 설정
    func setupProfileImageLayout() {
        self.profileView.addSubview(plainProfileImageView)
        self.profileView.addSubview(firstCharacterLabel)
        NSLayoutConstraint.activate([
            firstCharacterLabel.leadingAnchor.constraint(equalTo: self.profileView.leadingAnchor),
            firstCharacterLabel.trailingAnchor.constraint(equalTo: self.profileView.trailingAnchor),
            firstCharacterLabel.centerYAnchor.constraint(equalTo: self.profileView.centerYAnchor, constant: 5),
            plainProfileImageView.leadingAnchor.constraint(equalTo: self.profileView.leadingAnchor),
            plainProfileImageView.trailingAnchor.constraint(equalTo: self.profileView.trailingAnchor),
            plainProfileImageView.topAnchor.constraint(equalTo: self.profileView.topAnchor),
            plainProfileImageView.bottomAnchor.constraint(equalTo: self.profileView.bottomAnchor)
        ])
    }
    @IBAction func profileEditDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "프로필 수정", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "갤러리에서 선택", style: .default, handler: { _ in
            self.lastProfileSelectType = 0
            self.profileView.isHidden = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "기본이미지로 변경", style: .default, handler: { _ in
            self.lastProfileSelectType = 1
            self.profileView.isHidden = false
            self.plainProfileImageView.layer.cornerRadius = 0
            self.imageInfo = self.profileView.snapshotView(afterScreenUpdates: true)?.takeScreenshot()
            print("기본 이미지")
            self.plainProfileImageView.layer.cornerRadius = 50
        }))
        alert.addAction(UIAlertAction(title: "원래대로", style: .default, handler: { _ in
            guard let userInfo = UserManager.shared.userInfo else { return }
            self.lastProfileSelectType = 2
            self.profileView.isHidden = true
            self.profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nickNameTextFieldEditingChanged(_ sender: Any) {
        if let textInfo = nicknameTextField.text {
            if textInfo.count <= 8 {
                nickNameCountingLabel.text = "\(textInfo.count)/8"
                nickNameCountingLabel.textColor = UIColor.placeHolder
            } else {
                nicknameTextField.deleteBackward()
                nickNameCountingLabel.text = "8/8"
                nickNameCountingLabel.textColor = UIColor.systemRed
            }
        } else {
            nickNameCountingLabel.text = "0/8"
            nickNameCountingLabel.textColor = UIColor.placeHolder
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        coordinator?.dismiss()
    }
    
    @IBAction func withdrawButtonDidTap(_ sender: Any) {
        coordinator?.dismissToRoot()
    }
    
    @IBAction func updateButtonDidTap(_ sender: Any) {
        guard let nicknameInfo = nicknameTextField.text, nicknameInfo != "" else { return }
        updateButton.isEnabled = false
        if lastProfileSelectType == 2 {
            if nicknameInfo == UserManager.shared.userInfo?.nickName {
                // 변경 사항 없음
                self.simpleAlert(message: "변경 사항이 없습니다")
                self.updateButton.isEnabled = true
                return
            }
            UserServiceAPI.shared.updateUserInfo(nickName: nicknameInfo, profileImage: nil) { result in
                print("==> \(result)")
                guard let userInfo = NetworkResultManager.shared.analyze(result: result, vc: self, coordinator: self.coordinator) as? UserInfo else { return }
                UserManager.shared.userInfo = userInfo
                DispatchQueue.main.async {
                    self.updateButton.isEnabled = true
                    self.coordinator?.dismiss()
                }
            }
        } else {
            guard let selectedImage = self.imageInfo, var imageData = selectedImage.pngData() else { return }
            var quality: CGFloat = 1
            
            while imageData.count >= 1572864 {
                quality -= 0.1
                if let newData = selectedImage.jpegData(compressionQuality: quality) {
                    imageData = newData
                }
            }
            let binaryImage = imageData.base64EncodedString()
            UserServiceAPI.shared.updateUserInfo(nickName: (nicknameInfo == UserManager.shared.userInfo?.nickName ? nil : nicknameInfo), profileImage: binaryImage) { result in
                print("==> \(result)")
                guard let userInfo = NetworkResultManager.shared.analyze(result: result, vc: self, coordinator: self.coordinator) as? UserInfo else { return }
                UserManager.shared.userInfo = userInfo
                DispatchQueue.main.async {
                    self.updateButton.isEnabled = true
                    self.coordinator?.dismiss()
                }
            }
        }
        
    }
}

extension AccountEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.profileImageView.isHidden = false
        self.profileImageView.image = newImage
        self.imageInfo = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}
