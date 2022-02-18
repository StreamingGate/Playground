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
}
