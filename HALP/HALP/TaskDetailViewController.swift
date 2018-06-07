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
    var alarmStr:String = "" // temporary alarm
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
    
    func alarmStr(from alarmInt32:Int32) -> String
    {
        let alarmStr:String
        if alarmInt32 == -1
        {
            alarmStr = "None"
        }else if alarmInt32 == 0
        {
            alarmStr = "At start time of Event"
        }else
        {
            if(alarmInt32/3600 >= 1)
            {
                let hour = alarmInt32/3600
                if hour == 1 {
                    alarmStr = "1 Hours before"
                }
                else {
                    alarmStr = "2 Hours before"
                }
            }else
            {
                let minutes = alarmInt32/60
                switch(minutes)
                {
                case 5:
                    alarmStr = "5 minutes before"
                case 10:
                    alarmStr = "10 minutes before"
                case 15:
                    alarmStr = "15 minutes before"
                case 30:
                    alarmStr = "30 minutes before"
                default:
                    alarmStr = ""
                }
            }
        }
        return alarmStr
    }
    func alarmInt32(from alarmStr:String) -> Int32
    {
        let result = alarmStr.split(separator: " ")
        var alarm: Int32
        if result.isEmpty {
            alarm = -1
        } else {
            if result[0] == "None" {
                alarm = -1
            } else if result[0] == "At" {
                alarm = 0
            } else {
                alarm = Int32(result[0])!
                if alarm < 5 {
                    alarm = alarm * 60 * 60
                } else {
                    alarm = alarm * 60
                }
            }
        }
        return alarm
    }

}


//tableview cell identifier: mainDetailCell
extension TaskDetailViewController : UITableViewDelegate, UITableViewDataSource, TaskDetailTableViewControllerDelegate
{
    func changeDetail(text label: String, indexPath: IndexPath) {
        self.task?.setAlarm(alarmInt32(from: label))
        let updateForm = TaskForm(Title: (self.task?.getTitle())!, Description: (self.task?.getDescription())!, Category: (self.task?.getCategory())!,
                                  Alarm: (self.task?.getAlarm())!, Deadline: (self.task?.getDeadline())!,
                                  SoftDeadline: (self.task?.getSoftDeadline())!,
                                  Schedule: (self.task?.getSchedule())!, Duration: (self.task?.getDuration())!,
                                  Priority: (self.task?.getPriority())!, Schedule_start: (self.task?.getScheduleStart())!,
                                  Notification: (self.task?.getNotification())!, TaskID: (self.task?.getTaskId())!,
                                  UserID: TaskManager.sharedTaskManager.getUser().getUserID())
        TaskManager.sharedTaskManager.updateTask(form: updateForm)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
                mainDetailCell?.taskImageView.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
            }
            
            //setting task title
            mainDetailCell?.taskTitle.text = self.task?.getTitle()
			mainDetailCell?.taskTitle.textColor = TaskManager.sharedTaskManager.getTheme().background
            //setting description label
            let descriptionStr:String = task?.getDescription() ?? ""
            if descriptionStr.isEmpty
            {
                mainDetailCell?.taskDescriptionLabel.text = "Description"
                mainDetailCell?.taskDescriptionLabel.textColor = UIColor.placeholderGray
            }else
            {
                mainDetailCell?.taskDescriptionLabel.text = descriptionStr
                mainDetailCell?.taskDescriptionLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
            }
            
            //setting event duration
            let startDate = Date(timeIntervalSince1970: TimeInterval((task?.getScheduleStart())!))
			let deadlineDate = Date(timeIntervalSince1970: TimeInterval((task?.getDeadline())!))
          
            let startDateTimeStr = timeDateFormatter.string(from: startDate)
            let deadlineDateTimeStr = timeDateFormatter.string(from: deadlineDate)
            
            mainDetailCell?.eventTimeLabel1.textColor = TaskManager.sharedTaskManager.getTheme().background
            mainDetailCell?.eventTimeLabel2.textColor = TaskManager.sharedTaskManager.getTheme().background
            mainDetailCell?.eventTimeLabel1.adjustsFontSizeToFitWidth = true
            mainDetailCell?.eventTimeLabel2.adjustsFontSizeToFitWidth = true
			
			// Display "from.. to.." if task is fixed
			print(task!.getSchedule())
			if task!.getSchedule() != 0 {
            	if Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .month) == .orderedSame && Calendar.current.compare(startDate, to: deadlineDate, toGranularity: .day) == .orderedSame
            	{
                	//case1: event takes place on the same day
                
                	let sameDayStr = generalDateFormatter.string(from: startDate)
                	let attributedStr1 = NSMutableAttributedString(string: sameDayStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : TaskManager.sharedTaskManager.getTheme().background ])
                	let timeStr = "from " + startDateTimeStr + " to " + deadlineDateTimeStr
                	let attributedStr2 = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : TaskManager.sharedTaskManager.getTheme().background ])
                
                	mainDetailCell?.eventTimeLabel1.attributedText = attributedStr1
                	mainDetailCell?.eventTimeLabel2.attributedText = attributedStr2
					
					mainDetailCell?.halpSuggestionLabel.text = "⏳ suggests:  Follow your schedule."
					mainDetailCell?.halpSuggestionLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
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
					mainDetailCell?.halpSuggestionLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
            	}
			} else {
				// Display Deadline with Duration.
				let timeStr = "Due on " + deadlineDateTimeStr
				let attributedStr1 = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : TaskManager.sharedTaskManager.getTheme().background ])
				var durationStr = "Duration: "
				durationStr += String(self.task!.getDuration() / 3600) + " Hours "
				durationStr += String(self.task!.getDuration() % 3600 / 60) + " Minutes"
				let attributedStr2 = NSMutableAttributedString(string: durationStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : TaskManager.sharedTaskManager.getTheme().background ])
				mainDetailCell?.eventTimeLabel1.attributedText = attributedStr2
				mainDetailCell?.eventTimeLabel2.attributedText = attributedStr1
				
				mainDetailCell?.halpSuggestionLabel.text = "Halp suggests: Start on "
				// Date formatter
				mainDetailCell?.halpSuggestionLabel.text! += generalDateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(self.task!.getScheduleStart()))) + " " + timeDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.task!.getScheduleStart())))
				mainDetailCell?.halpSuggestionLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
				mainDetailCell?.halpSuggestionLabel.numberOfLines = 0
			}
			
			// Check scheduling conflict
			if task!.getScheduleStart() + task!.getDuration() > task!.getDeadline() {
				mainDetailCell?.eventTimeLabel1.textColor = UIColor.HalpColors.fuzzyWuzzy
				mainDetailCell?.eventTimeLabel2.textColor = UIColor.HalpColors.fuzzyWuzzy
			}
			
            return self.mainDetailCell!
        }else //Alarm cell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.detail.rawValue, for: indexPath)
            cell.textLabel?.text = "Alarm"
            
            guard let alarmInt32 = task?.getAlarm() else {return cell}
            self.alarmStr = self.alarmStr(from: alarmInt32)
            let attributedStr = NSMutableAttributedString(string: alarmStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : TaskManager.sharedTaskManager.getTheme().background ])
            cell.detailTextLabel?.attributedText = attributedStr
            return cell
        }
    }
}
