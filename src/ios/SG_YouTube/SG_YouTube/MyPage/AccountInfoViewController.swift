//
//  AccountInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class AccountInfoViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        logOutLabel.font = UIFont.Component
        nicknameLabel.font = UIFont.Content
        editButton.titleLabel?.font = UIFont.caption
        profileImageView.layer.cornerRadius = 35 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonDidTap(_ sender: Any) {
//        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
