//
//  LoadingView.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/17.
//

import Foundation
import UIKit
import Lottie

extension AnimationView {
    func setLoading(vc: UIViewController, backView: UIView) {
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        vc.view.addSubview(backView)
        vc.view.addSubview(self)
        backView.frame = vc.view.frame
        self.frame = CGRect(x: vc.view.bounds.midX - 50, y: vc.view.bounds.midY - 100, width: 100, height: 100)
        self.contentMode = .scaleAspectFit
        self.animationSpeed = 2
        self.play()
        self.loopMode = .loop
    }
    
    func stopLoading(backView: UIView) {
        self.pause()
        self.removeFromSuperview()
        backView.removeFromSuperview()
    }
    
    func setAutoLoginLoading(vc: UIViewController, backView: UIView) {
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        vc.view.addSubview(backView)
        vc.view.addSubview(self)
        let autoLoginTryingLabel = UILabel()
        backView.addSubview(autoLoginTryingLabel)
        autoLoginTryingLabel.text = "자동로그인 중..."
        autoLoginTryingLabel.textColor = UIColor.PGBlue
        autoLoginTryingLabel.font = UIFont.Tab
        autoLoginTryingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            autoLoginTryingLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
            autoLoginTryingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        backView.frame = vc.view.frame
        self.frame = CGRect(x: vc.view.bounds.midX - 50, y: vc.view.bounds.midY - 100, width: 100, height: 100)
        self.contentMode = .scaleAspectFit
        self.animationSpeed = 2
        self.play()
        self.loopMode = .loop
    }
}
