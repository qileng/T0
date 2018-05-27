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
        
        guard let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else{return}
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditButtonHandler))
        print(task?.getTitle())
        
//        print("title: ", mainDetailCell?.taskTitle.text)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        self.mainDetailCell = tableView.dequeueReusableCell(withIdentifier: "mainDetailCell", for: indexPath) as! MainDetailTableViewCell
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
            
            //Thursday, May
            let sameDayStr = generalDateFormatter.string(from: startDate)
            mainDetailCell?.eventTimeLabel1.text = sameDayStr
            mainDetailCell?.eventTimeLabel2.text = "from " + startDateTimeStr + " to " + deadlineDateTimeStr
        }else{
            //case2: event takes places on the different day
            let startDayStr = generalDateFormatter.string(from: startDate)
            let deadlineDayStr = generalDateFormatter.string(from: deadlineDate)
            mainDetailCell?.eventTimeLabel1.text = "from " + startDateTimeStr + ", " + startDayStr
            mainDetailCell?.eventTimeLabel2.text = "to " + deadlineDateTimeStr + ", " + deadlineDayStr
            
//            mainDetailCell?.eventTimeLabel1.textColor = .gray
//            mainDetailCell?.eventTimeLabel2.textColor = .gray
        }
        
//        mainDetailCell?.halpSuggestionLabel.text = "Halp suggests that you just do it"
        return self.mainDetailCell!
    }
    
}
