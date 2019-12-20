//
//  PaySuccessVC.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-19.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit

class PaySuccessVC: UIViewController {
    
    let responseLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    /****************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        
    }
        
    /****************************************************************************************/
    
    func setupViews() {
        
        view.addSubview(responseLabel)
        
        _ = responseLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        responseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        responseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}
