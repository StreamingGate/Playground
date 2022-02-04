//
//  UploadViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

class UploadViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    let videoPicker = UIImagePickerController()
    @IBOutlet weak var videoPickerButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryContentLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var thumbnailImageTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    let player = AVPlayer()
    var navVC: CreateNavigationController?
    var videoInfo: NSURL?
    var imageInfo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? CreateNavigationController else { return }
        navVC = nav
        videoPicker.delegate = self
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        setupUI()
    }
    
    func setupUI() {
        videoPickerButton.setTitle("", for: .normal)
        
        closeButton.setTitle("", for: .normal)
        
        detailTitleLabel.font = UIFont.Content
        detailTitleLabel.textColor = UIColor.background
        
        titleTextView.textColor = UIColor.background
        titleTextView.font = UIFont.caption
        titleTextView.layer.borderColor = UIColor.placeHolder.cgColor
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.cornerRadius = 10
        
        explainTextView.textColor = UIColor.background
        explainTextView.font = UIFont.caption
        explainTextView.layer.borderColor = UIColor.placeHolder.cgColor
        explainTextView.layer.borderWidth = 1
        explainTextView.layer.cornerRadius = 10
        
        categoryButton.layer.borderColor = UIColor.placeHolder.cgColor
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.cornerRadius = 10
        
        thumbnailButton.layer.borderColor = UIColor.placeHolder.cgColor
        thumbnailButton.layer.borderWidth = 1
        thumbnailButton.layer.cornerRadius = 10
        
        categoryTitleLabel.font = UIFont.Content
        categoryTitleLabel.textColor = UIColor.background
        categoryContentLabel.font = UIFont.caption
        categoryContentLabel.textColor = UIColor.background
        
        thumbnailImageTitleLabel.font = UIFont.Content
        thumbnailImageTitleLabel.textColor = UIColor.background
        
        uploadButton.backgroundColor = UIColor.PGOrange
        uploadButton.titleLabel?.font = UIFont.SubTitle
        uploadButton.layer.cornerRadius = 20
        
        playerView.layer.cornerRadius = 10
    }
    
    @IBAction func videoPickerButtonDidTap(_ sender: Any) {
        self.present(videoPicker, animated: true, completion: nil)
    }
    
    @IBAction func thumbnailButtonDidTap(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == videoPicker {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            self.videoInfo = videoURL
            let avAsset = AVURLAsset(url: videoURL! as URL)
            let item = AVPlayerItem(asset: avAsset)
            self.player.replaceCurrentItem(with: item)
            playerView.player = self.player
            playerView.player?.play()
            videoPicker.dismiss(animated: true, completion: nil)
        } else {
            let imageInfo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.imageInfo = imageInfo
            thumbnailImageView.image = imageInfo
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

