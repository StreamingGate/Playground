//
//  NickNameInputViewController.swift
//  StoveDevCamp_PersonalProject
//
//  Created by chuiseo-MN on 2021/12/15.
//

import Foundation
import UIKit
import Photos

class NickNameInputViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameValidCheckLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var defaultImageButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    let firstCharacterLabel = UILabel()
    let imagePicker = UIImagePickerController()
    let profileImageView = UIImageView()
    var nameInfo: String = ""
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        self.style()
        self.layout()
    }
    
    // MARK: Life Cycle
    func style() {
        profileView.backgroundColor = UIColor.placeHolder
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
    }
    
    func layout() {
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
    
    @IBAction func selectButtonDidTap(_ sender: Any) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func defaultImageButtonDidTap(_ sender: Any) {
        profileImageView.isHidden = true
        profileView.layer.cornerRadius = 0
        let image = profileView.snapshotView(afterScreenUpdates: true)?.takeScreenshot()
        profileView.layer.cornerRadius = 50
        savePhotoLibrary(image: image!)
    }
    
    // MARK: Nickname Input
    @IBAction func nickNameTextFieldEditingChanged(_ sender: Any) {
        guard let nickNameInfo = nickNameTextField.text, nickNameInfo.isEmpty == false else {
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 6글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.systemRed
            nextButton.isEnabled = false
            return
        }
        if nickNameInfo.count > 6 {
            nickNameTextField.deleteBackward()
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 6글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.systemRed
        } else {
            nickNameValidCheckLabel.isHidden = true
            nextButton.isEnabled = true
        }
    }
    
    // MARK: Button Action
    // 다음
    @IBAction func nextButtonDidTap(_ sender: Any) {
        guard let nickNameInfo = nickNameTextField.text, nickNameInfo.isEmpty == false else { return }
        nextButton.isEnabled = false
    }
    
    // 뒤로 가기
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NickNameInputViewController {
    func savePhotoLibrary(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (_, error) in
                    DispatchQueue.main.async {
                        let alert1 = UIAlertController(title: "", message: "이미지가 저장되었습니다.", preferredStyle: .alert)
                        let action11 = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert1.addAction(action11)
                        self.present(alert1, animated: true, completion: nil)
                    }
                })
            } else {
                print("Not determined")
                DispatchQueue.main.async {
                    self.alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
                }
            }
        }
    }
    
    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts() {
        let cameraUnavailableAlertController = UIAlertController (title: "사진 접근 권한", message: "캡쳐를 위해서는 사진 권한을 허용해주세요.", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "설정 가기", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        self.present(cameraUnavailableAlertController, animated: true, completion: nil)
    }
}

extension NickNameInputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        self.profileView.isHidden = false
        self.profileImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}
