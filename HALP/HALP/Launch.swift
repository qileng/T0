//
//  Launch.swift
//  HALP
//
//  Created by FlikHu on 5/31/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var appName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xefefef)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.anchor(top: appName.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 50, height: 100, centerX: self.view.centerXAnchor, centerY: nil)
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSavedUser(completion: { (flag) in
            if flag {
                self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
            } else {
                self.present((self.storyboard?.instantiateViewController(withIdentifier: "Startup"))!, animated: true, completion: nil)
            }
        })
    }
    
    
}
