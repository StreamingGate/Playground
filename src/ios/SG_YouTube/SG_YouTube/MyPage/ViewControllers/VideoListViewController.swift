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
        setupUI()
    }
    
    func setupUI() {
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
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playVC = self.children.last as? PlayViewController {
            self.tabBarController?.setTabBar(hidden: true, animated: true, along: self.parent?.transitionCoordinator)
            playVC.isMinimized = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                playVC.playViewWidth.constant = UIScreen.main.bounds.width
                playVC.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                playVC.view.center = CGPoint(x: playVC.view.frame.width / 2, y: playVC.view.frame.height / 2)
            }
        } else {
            guard let playVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayViewController" ) as? PlayViewController else { return }
            self.tabBarController?.setTabBar(hidden: true, animated: true, along: self.transitionCoordinator)
            self.addChild(playVC)
            self.view.addSubview((playVC.view)!)
            playVC.view.frame = self.view.bounds
            playVC.didMove(toParent: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 82)
    }
}
