//
//  ChannelViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit

class ChannelViewController: UIViewController {
    @IBOutlet weak var channelNameTitleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var friendRequestLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoTableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                videoTableViewHeight.constant = newsize.height
            }
        }
    }
    
    func setupUI() {
        profileImageView.layer.cornerRadius = 25
        profileImageView.backgroundColor = UIColor.placeHolder
        channelTitleLabel.font = UIFont.SubTitle
        channelTitleLabel.font = UIFont.Title
        friendRequestLabel.font = UIFont.Content
        friendRequestLabel.textColor = UIColor.youtubeRed
        explainLabel.font = UIFont.caption
        explainLabel.textColor = UIColor.customDarkGray
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
