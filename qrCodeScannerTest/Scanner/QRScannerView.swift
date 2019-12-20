//
//  QRScannerView.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-10-08.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerViewDelegate: class {
    func qrScannerDidFail()
    func qrScannerSucceededWithCode(_ str: String)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    
    var delegate: QRScannerViewDelegate?
    
    // The capture session which allows us to start and stop scanning.
    var captureSess: AVCaptureSession?
    
    /****************************************************************************************/
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /****************************************************************************************/
    
    // Overriding the layerClass to return 'AVCaptureVideoPreviewLayer'.
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
    
    // SETUP FUNCTION. Initializes the captureSession
    func setup() {
        
        clipsToBounds = true
        captureSess = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print("Error getting the capture device input: \(error)")
            return
        }
        
        if captureSess?.canAddInput(videoInput) ?? false {
            captureSess?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSess?.canAddOutput(metadataOutput) ?? false {
            captureSess?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        }
        
        self.layer.session = captureSess
        self.layer.videoGravity = .resizeAspectFill
        
        captureSess?.startRunning()
        
    }
    
}

// This does the actual QRCode stuff.
extension QRScannerView {
    
    var isRunning: Bool {
        return captureSess?.isRunning ?? false
    }
    
    func startScanning() {
        captureSess?.startRunning()
    }
    
    func stopScanning() {
        captureSess?.stopRunning()
        if let del = delegate {
            del.qrScanningDidStop()
        }
        
    }
    
    func scanningDidFail() {
        
        if let del = delegate {
            del.qrScannerDidFail()
            captureSess = nil
        }
        
    }
    
    func found(code: String) {
        
        if let del = delegate {
            del.qrScannerSucceededWithCode(code)
        }
        
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        stopScanning()
        
        if let metadataObj = metadataObjects.first {
            
            guard let readableObj = metadataObj as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObj.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
            
        }
        
    }
    
}
