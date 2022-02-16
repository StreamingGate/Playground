//
//  CategoryCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit

/**
 홈화면에 상단에 노출되는 수평 스크롤 카테고리 셀
 */
class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func setupUI(selected: Bool, category: String) {
        if selected {
            backView.backgroundColor = UIColor.placeHolder
            backView.layer.borderColor = UIColor.placeHolder.cgColor
            categoryLabel.textColor = UIColor.white
        } else {
            backView.backgroundColor = UIColor.background
            backView.layer.borderColor = UIColor.separator.cgColor
            categoryLabel.textColor = UIColor.customDarkGray
        }
        backView.layer.cornerRadius = 15
        backView.layer.borderWidth = 1
        categoryLabel.font = UIFont.Component
        categoryLabel.text = category
    }
}
