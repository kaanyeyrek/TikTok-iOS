//
//  CameraViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {


    var captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var captureOutput = AVCaptureMovieFileOutput()
    
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
   
    private let recordButton = RecordButton()
    
    private var previewLayer: AVPlayerLayer?
    
    var recordedVideoURL: URL?
    
    private let cameraView: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setupCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
        
    }
    
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size, width: size, height: size)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func didTapRecord() {
        
        if captureOutput.isRecording {
            captureOutput.stopRecording()
            recordButton.toggle(with: .notRecording)
            
        } else {
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
                
            }
            url.appendPathComponent("video.mov")
            
            recordButton.toggle(with: .recording)
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url, recordingDelegate: self)
            
        }
    }
    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
             
        }
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    
  
    func setupCamera() {
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            if let audioInput = try? AVCaptureDeviceInput(device: audioDevice) {
                
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                    
                }
                
                
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video)  {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
            
        }
        captureSession.sessionPreset = .hd1920x1080
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
 
   

}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Woops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        recordedVideoURL = outputFileURL
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        let previewlayer = AVPlayerLayer(player: player)
        previewlayer.videoGravity = .resizeAspectFill
        previewlayer.frame = cameraView.bounds
        
        guard previewLayer != nil else {
            return
        }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewlayer)
        previewlayer.player?.play()
    }
    
    @objc func didTapNext() {
        
        guard let url = recordedVideoURL else {
            return
        }
        
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    
    
    
    
}
