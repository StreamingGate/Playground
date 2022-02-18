//
//  AccountEditViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class AccountEditViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    var coordinator: AccountEditCoordinator?
    let imagePicker = UIImagePickerController()
    let firstCharacterLabel = UILabel()
    let plainProfileImageView = UIImageView()
    var lastProfileSelectType: Int = 2
    var imageInfo: UIImage?
    private var cancellable: Set<AnyCancellable> = []
    let backgroundColor = [UIColor(red: 1, green: 0.797, blue: 0.275, alpha: 1), UIColor(red: 0.335, green: 0.563, blue: 0.904, alpha: 1), UIColor(red: 0.838, green: 0.59, blue: 0.925, alpha: 1), UIColor(red: 0.929, green: 0.391, blue: 0.391, alpha: 1), UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1), UIColor(red: 0.578, green: 0.867, blue: 0.693, alpha: 1), UIColor(red: 0.332, green: 0.812, blue: 0.784, alpha: 1), UIColor(red: 0.946, green: 0.43, blue: 0.615, alpha: 1)]
    var randomColor = UIColor.placeHolder

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setting
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
    
    // MARK: - Data Binding
    func bindData() {
        UserManager.shared.$userInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] user in
                guard let self = self, let userInfo = user else { return }
                self.profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
                self.nicknameTextField.text = userInfo.nickName
                self.nickNameCountingLabel.text = "\(userInfo.nickName?.count ?? 0)/8"
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
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
            self.randomColor = self.backgroundColor.randomElement() ?? UIColor.placeHolder
            self.plainProfileImageView.backgroundColor = self.randomColor
            self.plainProfileImageView.layer.cornerRadius = 0
            self.imageInfo = self.profileView.snapshotView(afterScreenUpdates: true)?.takeScreenshot(color: self.randomColor, character: "\(UserManager.shared.userInfo?.name?.first ?? "플")")
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
            // 프로필 사진이 바뀐 케이스기 때문에 imageInfo가 있어야 함
            guard let selectedImage = self.imageInfo, var imageData = selectedImage.pngData() else { return }
            // 서버에서 받을 수 있는 크기로 imageData 압축
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
                UserManager.shared.userInfo = UserInfo(email: userInfo.email, profileImage: userInfo.profileImage, name: userInfo.name, nickName: userInfo.nickName ?? UserManager.shared.userInfo?.nickName, refreshToken: nil)
                DispatchQueue.main.async {
                    self.updateButton.isEnabled = true
                    self.coordinator?.dismiss()
                }
            }
        }
    }
    
    // MARK: - input Text
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
