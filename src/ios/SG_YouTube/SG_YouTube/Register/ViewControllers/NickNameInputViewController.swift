//
//  NickNameInputViewController.swift
//  StoveDevCamp_PersonalProject
//
//  Created by chuiseo-MN on 2021/12/15.
//

import Foundation
import UIKit

class NickNameInputViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameValidCheckLabel: UILabel!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style()
    }
    
    // MARK: Life Cycle
    func style() {
        nextButton.layer.cornerRadius = 5
        nickNameTextField.font = UIFont.Content
    }
    
    
    // MARK: Nickname Input
    @IBAction func nickNameTextFieldEditingChanged(_ sender: Any) {
        guard let nickNameInfo = nickNameTextField.text, nickNameInfo.isEmpty == false else {
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 6글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.youtubeBlue
            nextButton.isEnabled = false
            return
        }
        if nickNameInfo.count > 6 {
            nickNameTextField.deleteBackward()
            nickNameValidCheckLabel.isHidden = false
            nickNameValidCheckLabel.text = "최대 6글자까지 입력하실 수 있습니다"
            nickNameValidCheckLabel.textColor = UIColor.youtubeRed
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
