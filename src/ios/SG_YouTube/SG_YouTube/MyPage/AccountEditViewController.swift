//
//  AccountEditViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class AccountEditViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        titleLabel.font = UIFont.SubTitle
        nicknameLabel.textColor = UIColor.placeHolder
        nicknameLabel.font = UIFont.caption
        nicknameTextField.font = UIFont.Content
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 30
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
