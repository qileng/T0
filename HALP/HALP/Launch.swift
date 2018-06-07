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
        self.view.backgroundColor = UIColor.HalpColors.lessLightGray
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.anchor(top: appName.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 50, height: 100, centerX: self.view.centerXAnchor, centerY: nil)
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: Database.database().reference().description())
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print( "Request: ", error == nil )
            if error != nil {
                let alert = UIAlertController(title: "No internet connection!", message: "Please connect to internet and restart the app or procced as guest", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Proceed as guest", style: .cancel, handler: { (action) in
                    loadSetting(user: UserData(username: "GUEST", password: "GUEST", email: "GUEST@GUEST.com", id: 0))
					DispatchQueueMainSync ({()->(Void) in
						self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
					})
                }))
                self.present(alert, animated: true)
                
            } else {
                loadSavedUser(completion: { (flag) in
                    if flag {
						DispatchQueueMainSync({()->(Void) in
							self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: false, completion: nil)
						})
                    } else {
                        DispatchQueueMainSync({()->(Void) in
                                self.present((self.storyboard?.instantiateViewController(withIdentifier: "Startup"))!, animated: false, completion: nil)
                        })
                    }
                })
            }
        }
        
        task.resume()
    }
    
    
}
