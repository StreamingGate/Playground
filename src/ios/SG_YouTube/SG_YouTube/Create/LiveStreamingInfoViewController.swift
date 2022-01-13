//
//  LiveStreamingInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import AVFoundation

class LiveStreamingInfoViewController: UIViewController {
    @IBOutlet weak var currentAccountLabel: UILabel!
    @IBOutlet weak var accountNicknameLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryContentLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var thumbnailImageTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingCancelButton: UIButton!
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var cameraViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var cameraViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var loadingViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var loadingViewBottomMargin: NSLayoutConstraint!
    
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraViewTopMargin.constant = -(self.view.safeAreaInsets.top)
        cameraViewBottomMargin.constant = -(self.view.safeAreaInsets.bottom)
        loadingViewTopMargin.constant = -(self.view.safeAreaInsets.top)
        loadingViewBottomMargin.constant = (self.view.safeAreaInsets.bottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        setupUI()
    }
    
    func setupUI() {
        currentAccountLabel.font = UIFont.bottomTab
        currentAccountLabel.textColor = UIColor.background
        accountNicknameLabel.font = UIFont.Component
        accountNicknameLabel.textColor = UIColor.background
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
        
        startButton.backgroundColor = UIColor.youtubeRed
        startButton.titleLabel?.font = UIFont.SubTitle
        startButton.layer.cornerRadius = 20
        
        profileImageView.backgroundColor = UIColor.separator
        profileImageView.layer.cornerRadius = 33 / 2
        
        loadingLabel.font = UIFont.Tab
        loadingLabel.textColor = UIColor.white
        
        loadingCancelButton.backgroundColor = UIColor.white
        loadingCancelButton.tintColor = UIColor.black
        loadingCancelButton.titleLabel?.font = UIFont.SubTitle
        loadingCancelButton.layer.cornerRadius = 20
    }
    
    @IBAction func startButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.loadingView.alpha = 1
        }
    }
    
    @IBAction func loadingCancleButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tempButtonDidTap(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Broadcast", bundle: nil).instantiateViewController(withIdentifier: "LiveViewController") as? LiveViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}



extension LiveStreamingInfoViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        // Add Video Input
        do {
            var defaultVideoDevice: AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = defaultVideoDevice else {
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch {
            captureSession.commitConfiguration()
            return
        }
        
        
        // Add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
}
