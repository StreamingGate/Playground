//
//  CreatePopOverViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class CreatePopOverViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var createTitleLabel: UILabel!
    @IBOutlet weak var shortsCreateLabel: UILabel!
    @IBOutlet weak var liveCreateLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.roundCorners([.topLeft , .topRight], radius: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        prepareAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
    }
    
    // MARK: - UI Setting
    func setUI() {
        createTitleLabel.font = UIFont.SubTitle
        shortsCreateLabel.font = UIFont.Component
        liveCreateLabel.font = UIFont.Component
    }
    
    // MARK: - Animation
    func prepareAnimation(){
        backView.transform = CGAffineTransform.init(translationX: 0, y: 100)
        backView.alpha = 0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.backView.transform = CGAffineTransform.identity
            self.backView.alpha = 1
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }, completion: nil)
    }
    
    func disappearAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.backView.transform = CGAffineTransform.init(translationX: 0, y: 100)
            self.backView.alpha = 0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: {_ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Button Action
    @IBAction func closeButtonDidTap(_ sender: Any) {
        disappearAnimation()
    }
    
    @IBAction func liveStreamingButtonDidTap(_ sender: Any) {
        guard let liveInfoVC = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "LiveStreamingInfoViewController") as? LiveStreamingInfoViewController else { return }
        liveInfoVC.modalPresentationStyle = .fullScreen
        self.present(liveInfoVC, animated: true) {
            self.view.removeFromSuperview()
        }
    }
}
