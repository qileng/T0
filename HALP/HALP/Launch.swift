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
        
        let url = URL(string: Database.database().reference().description())
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print( "Request: ", error == nil )
            if error != nil {
                let alert = UIAlertController(title: "No internet connection!", message: "Please connect to internet and restart the app or procced as guest", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Proceed as guest", style: .cancel, handler: { (action) in
                    
                    let settingDAO = SettingDAO()
                    do {
                        let settingArray = try settingDAO.fetchSettingFromLocalDB(settingId: 0)
                        
                        let settingId = settingArray[0] as! Int64
                        let notification = settingArray[1] as! Int32 == 1 ? true : false
                        let theme = settingArray[2] as! Int32 == 1 ? Theme.dark : Theme.regular
                        let summary = settingArray[3] as! String
                        let sort = settingArray[4] as! Int32 == 1 ? SortingType.priority : SortingType.time
                        let avaliableDays = settingArray[5] as! Int32
                        let start = settingArray[6] as! Int32
                        let end = settingArray[7] as! Int32
                        
                        let userSetting = Setting(setting: settingId, notification: notification, theme: theme,
                                                  summary: summary, defaultSort: sort, availableDays: avaliableDays, startTime: start,
                                                  endTime: end, user: settingId)
                        TaskManager.sharedTaskManager.setUp(new: UserData(username: "GUEST", password: "GUEST", email: "GUEST@GUEST.com", id: 0), setting: userSetting, caller: self as UIViewController)
                        
                    }catch {
                        print("Error")
                    }
                    DispatchQueue.global().async {
                        DispatchQueue.main.sync {
                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
                        }
                    }
                }))
                self.present(alert, animated: true)
                
            } else {
                loadSavedUser(completion: { (flag) in
                    if flag {
                        DispatchQueue.global().async {
                            DispatchQueue.main.sync {
                                self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
                            }
                        }
                    } else {
                        DispatchQueue.global().async {
                            DispatchQueue.main.sync {
                                self.present((self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController"))!, animated: true, completion: nil)
                            }
                        }
                    }
                })
            }
        }
        
        task.resume()
    }
    
    
}
