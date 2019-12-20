//
//  MainNavController.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-19.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {
    
    /*
    * Checks if the user is authenticated or not and displays appropriate VC.
    */
    
    let loadingSpinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    /****************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationBar.isHidden = true
        
        loadingSpinner.startAnimating()
        view.addSubview(loadingSpinner)
        loadingSpinner.center = view.center
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = getToken() {
            // token is set. Send 'em to the scanner.
            pushViewController(LoginVC(), animated: false)
            pushViewController(ScannerVC(), animated: false)
            loadingSpinner.stopAnimating()
        } else {
            // token is not set. Send 'em to login.
            pushViewController(LoginVC(), animated: false)
            loadingSpinner.stopAnimating()
        }

        
    }
    
    /****************************************************************************************/
    
}
