//
//  ViewController.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-10-08.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController {

    let scannerView: QRScannerView = {
        let sv = QRScannerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        return sv
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(resetHandler), for: .touchUpInside)
        
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(Colors.warningRed, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(logoutHandler), for: .touchUpInside)
        
        return button
    }()
    
    let scannerErrorLabel: ErrorLabel = {
        let frame = CGRect(x: 0, y: 0, width: 500, height: 50)
        let label = ErrorLabel(frame: frame)
        
        label.textAlignment = .center
        
        // label.text = "This is some test error text for scannerErrorLabel."
        
        return label
    }()
    
    let loadingSpinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    @objc func resetHandler() {
        scannerStartup()
        scannerErrorLabel.text = nil
    }
    
    @objc func logoutHandler() {
        
        deleteToken()
        navigationController?.popViewController(animated: true)
        
    }
    
    /****************************************************************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scannerStartup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if scannerView.isRunning {
            scannerView.stopScanning()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        scannerView.delegate = self
        
        setupViews()
        
    }
        
    /****************************************************************************************/
    
    func scannerStartup() {
        
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
        
    }

    func setupViews() {
        
        view.addSubview(scannerView)
        view.addSubview(resetButton)
        
        view.addSubview(logoutButton)
        
        view.addSubview(scannerErrorLabel)
        
        _ = scannerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, topConstant: 70, leftConstant: 20, bottomConstant: 0, rightConstant: -20, widthConstant: 0, heightConstant: 0)
        
        _ = resetButton.anchor(top: scannerView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 40)
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = logoutButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: -20, widthConstant: 60, heightConstant: 40)
        
        _ = scannerErrorLabel.anchor(top: resetButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(loadingSpinner)
        _ = loadingSpinner.anchor(top: view.centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //loadingSpinner.center = view.center
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

}

extension ScannerVC: QRScannerViewDelegate {
    
    func qrScannerDidFail() {
        print("FAILED")
    }
    
    func qrScannerSucceededWithCode(_ str: String) {
        loadingSpinner.startAnimating()
        
        apiPay(url: str) { (result, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            // Every result has a "message" field. If message is nil, then it also has an error field, which is a string.
            guard let result = result as? Dictionary<String, Any> else { return }
            
            print(result)
            
            if let message = result["message"] as? String {
                DispatchQueue.main.async {
                    let successVC = PaySuccessVC()
                    successVC.responseLabel.text = message
                    
                    self.loadingSpinner.stopAnimating()
                    self.navigationController?.present(successVC, animated: true, completion: nil)
                }
            } else {
                let resultError = result["error"] as! String
                
                DispatchQueue.main.async {
                    self.scannerErrorLabel.text = resultError
                    self.loadingSpinner.stopAnimating()
                }
                
            }
            
        }
        
    }
    
    func qrScanningDidStop() {
        print("Scanning stopped.")
    }
    
}
