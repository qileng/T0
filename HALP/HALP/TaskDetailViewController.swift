//
//  TaskDetailViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/20/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var mainDetailCell:MainDetailTableViewCell?
    var task:Task?
    let generalDateFormatter = DateFormatter()
    let timeDateFormatter = DateFormatter()
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.tableFooterView = UIView()
        
        generalDateFormatter.dateStyle = .medium
        generalDateFormatter.timeStyle = .short
        
        timeDateFormatter.dateStyle = .medium
        timeDateFormatter.timeStyle = .short
        
        generalDateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        timeDateFormatter.dateFormat = "HH:mm a"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditButtonHandler))
        //rgb(255,90,95)
        self.navigationItem.title = "Event Details"        
//        print("title: ", mainDetailCell?.taskTitle.text)
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func EditButtonHandler()
    {
        print("Edit button touched")
    }

}


//tableview cell identifier: mainDetailCell
extension TaskDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.mainDetailCell = tableView.dequeueReusableCell(withIdentifier: "mainDetailCell", for: indexPath) as? MainDetailTableViewCell

            mainDetailCell?.selectionStyle = .none
        //setting task category image
        if let category = task?.getCategory()
        {
            let image:UIImage
            switch category {
            case Category.Study_Work:
                image = #imageLiteral(resourceName: "study")
            case .Entertainment:
                image = #imageLiteral(resourceName: "entertainment")
            case .Chore:
                image = #imageLiteral(resourceName: "chore")
            case .Relationship:
                image = #imageLiteral(resourceName: "relationship")
            }
            mainDetailCell?.taskImageView.image = image
            mainDetailCell?.taskImageView.contentMode = .scaleAspectFit
            mainDetailCell?.taskImageView.tintColor = taskColorTheme
        }
        
        //setting task title
        mainDetailCell?.taskTitle.text = self.task?.getTitle()
        if !((task?.getDescription().isEmpty)!)
        {
            mainDetailCell?.taskDescriptionLabel.text = task?.getDescription()
            mainDetailCell?.taskDescriptionLabel.textColor = .black
        }
        
        //setting event duration
        let startDate = Date(timeIntervalSince1970: TimeInterval((task?.getScheduleStart())!))
        let deadlineDate = Date(timeIntervalSince1970: TimeInterval((task?.getDeadline())!))
        let startDateTimeStr = timeDateFormatter.string(from: startDate)
        let deadlineDateTimeStr = timeDateFormatter.string(from: deadlineDate)
        
        mainDetailCell?.eventTimeLabel1.textColor = .black
        mainDetailCell?.eventTimeLabel2.textColor = .black
        mainDetailCell?.eventTimeLabel1.adjustsFontSizeToFitWidth = true
        mainDetailCell?.eventTimeLabel2.adjustsFontSizeToFitWidth = true
        
        if Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .month) == .orderedSame && Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .day) == .orderedSame
        {
            //case1: event takes place on the same day
            
            let sameDayStr = generalDateFormatter.string(from: startDate)
            let attributedStr1 = NSMutableAttributedString(string: sameDayStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            let timeStr = "from " + startDateTimeStr + " to " + deadlineDateTimeStr
            let attributedStr2 = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            
            mainDetailCell?.eventTimeLabel1.attributedText = attributedStr1
            mainDetailCell?.eventTimeLabel2.attributedText = attributedStr2
        }else{
            //case2: event takes places on the different day
            let startDayStr = generalDateFormatter.string(from: startDate)
            let deadlineDayStr = generalDateFormatter.string(from: deadlineDate)
            
            let timeStr1 = "from " + startDateTimeStr + ", " + startDayStr
            let timeStr2 = "to " + deadlineDateTimeStr + ", " + deadlineDayStr
            let attributedStr1 = NSMutableAttributedString(string: timeStr1, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            let attributedStr2 = NSMutableAttributedString(string: timeStr2, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            
            mainDetailCell?.eventTimeLabel1.attributedText = attributedStr1
            mainDetailCell?.eventTimeLabel2.attributedText = attributedStr2
            
//            mainDetailCell?.eventTimeLabel1.textColor = .gray
//            mainDetailCell?.eventTimeLabel2.textColor = .gray
        }
        
//        mainDetailCell?.halpSuggestionLabel.text = "Halp suggests that you just do it"
        return self.mainDetailCell!
    }
}
