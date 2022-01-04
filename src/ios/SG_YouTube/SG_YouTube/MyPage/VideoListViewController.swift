//
//  VideoListViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class VideoListViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        titleLabel.font = UIFont.SubTitle
        switch type {
        case 0:
            titleLabel.text = "시청한 동영상"
        case 1:
            titleLabel.text = "좋아요 표시한 동영상"
        default:
            titleLabel.text = "내 동영상"
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalVideoListCell", for: indexPath) as? HorizontalVideoListCell else {
            return UICollectionViewCell()
        }
        cell.setUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let playVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayViewController") as? PlayViewController else { return }
        playVC.modalPresentationStyle = .fullScreen
        self.present(playVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 82)
    }
}

class HorizontalVideoListCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explainLabel1: UILabel!
    @IBOutlet weak var explainLabel2: UILabel!
    @IBOutlet weak var lastPositionWidth: NSLayoutConstraint!
    
    func setUI() {
        thumbnailImageView.backgroundColor = UIColor.placeHolder
        titleLabel.font = UIFont.caption
        explainLabel1.font = UIFont.caption
        explainLabel1.textColor = UIColor.customDarkGray
        explainLabel2.font = UIFont.caption
        explainLabel2.textColor = UIColor.customDarkGray
    }
}
