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
    var alarm:String = "" // temporary alarm
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
        self.navigationItem.title = "Event Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewOutlet.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @objc func EditButtonHandler()
    {
        let taskEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskEditPageViewController") as! TaskEditPageViewController
        taskEditVC.isEditMode = true
        taskEditVC.taskToEdit = self.task
        let taskEditNC: UINavigationController = UINavigationController(rootViewController: taskEditVC)
        self.present(taskEditNC, animated: true, completion: nil)
    }

}


//tableview cell identifier: mainDetailCell
extension TaskDetailViewController : UITableViewDelegate, UITableViewDataSource, TaskDetailTableViewControllerDelegate
{
    func changeDetail(text label: String, indexPath: IndexPath) {
        self.alarm = label
    }
    
//    func getCategoryStr(from category:Category) -> String
//    {
//        var categoryStr:String = ""
//        switch category
//        {
//        case Category.Study_Work:
//            categoryStr = "Study"
//        case Category.Entertainment:
//            categoryStr = "Entertainment"
//        case Category.Chore:
//            categoryStr = "Chore"
//        case Category.Relationship:
//            categoryStr = "Social"
//        }
//        return categoryStr
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        var rowHeight = tableView.rowHeight
        var rowHeight = UITableViewAutomaticDimension
        if indexPath.row == 0
        {
            rowHeight = 290
        }else
        {
            rowHeight = 44
        }
        return rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailTableViewController") as! TaskDetailTableViewController
            detailVC.cellData = ["None", "At start time of Event", "5 minutes before",
                                     "10 minutes before", "15 minutes before", "30 minutes before",
                                     "1 Hours before", "2 Hours before"]
            detailVC.selectedIndexPath = indexPath
            detailVC.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
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
            //setting description label
            let descriptionStr:String = task?.getDescription() ?? ""
            if descriptionStr.isEmpty
            {
                mainDetailCell?.taskDescriptionLabel.text = "Description"
                mainDetailCell?.taskDescriptionLabel.textColor = UIColor.placeholderGray
            }else
            {
                mainDetailCell?.taskDescriptionLabel.text = descriptionStr
                mainDetailCell?.taskDescriptionLabel.textColor = .black
            }
            
            //setting event duration
            let startDate = Date(timeIntervalSince1970: TimeInterval((task?.getScheduleStart())!))
			let deadlineDate = Date(timeIntervalSince1970: TimeInterval(((task?.getScheduleStart())! + (task?.getDuration())!)))
          
            let startDateTimeStr = timeDateFormatter.string(from: startDate)
            let deadlineDateTimeStr = timeDateFormatter.string(from: deadlineDate)
            
            mainDetailCell?.eventTimeLabel1.textColor = .black
            mainDetailCell?.eventTimeLabel2.textColor = .black
            mainDetailCell?.eventTimeLabel1.adjustsFontSizeToFitWidth = true
            mainDetailCell?.eventTimeLabel2.adjustsFontSizeToFitWidth = true
			
			// Display "from.. to.." if task is fixed
			print(task!.getSchedule())
			if task!.getSchedule() != 0 {
            	if Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .month) == .orderedSame && Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .day) == .orderedSame
            	{
                	//case1: event takes place on the same day
                
                	let sameDayStr = generalDateFormatter.string(from: startDate)
                	let attributedStr1 = NSMutableAttributedString(string: sameDayStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
                	let timeStr = "from " + startDateTimeStr + " to " + deadlineDateTimeStr
                	let attributedStr2 = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
                
                	mainDetailCell?.eventTimeLabel1.attributedText = attributedStr1
                	mainDetailCell?.eventTimeLabel2.attributedText = attributedStr2
					
					mainDetailCell?.halpSuggestionLabel.text = "Halp suggests: 😜 Follow your schedule."
					mainDetailCell?.halpSuggestionLabel.textColor = UIColor.black
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
					
					mainDetailCell?.halpSuggestionLabel.text = "Halp suggests: 😜 Follow your schedule."
					mainDetailCell?.halpSuggestionLabel.textColor = UIColor.black
            	}
			} else {
				// Display Deadline with Duration.
				let timeStr = "Due on " + deadlineDateTimeStr
				let attributedStr1 = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
				var durationStr = "Duration: "
				durationStr += String(self.task!.getDuration() / 3600) + " Hours "
				durationStr += String(self.task!.getDuration() % 3600 / 60) + " Minutes"
				let attributedStr2 = NSMutableAttributedString(string: durationStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
				mainDetailCell?.eventTimeLabel1.attributedText = attributedStr2
				mainDetailCell?.eventTimeLabel2.attributedText = attributedStr1
				
				mainDetailCell?.halpSuggestionLabel.text = "Halp suggests: Start on "
				mainDetailCell?.halpSuggestionLabel.text! += generalDateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(self.task!.getScheduleStart())))
				mainDetailCell?.halpSuggestionLabel.textColor = UIColor.black
				mainDetailCell?.halpSuggestionLabel.numberOfLines = 0
			}
			
            return self.mainDetailCell!
        }else //Alarm cell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.detail.rawValue, for: indexPath)
            cell.textLabel?.text = "Alarm"
            let attributedStr = NSMutableAttributedString(string: self.alarm, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            cell.detailTextLabel?.attributedText = attributedStr
            return cell
        }
    }
}
