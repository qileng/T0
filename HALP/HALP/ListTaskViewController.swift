//
//  ListTaskViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/19/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class ListTaskViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let dateFormatter = DateFormatter()
	var tasks = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigarionbaritems()
        setupDateformat()
		NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "AlertDoneReload"), object: nil)
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Prompt past tasks alerts
		TaskManager.sharedTaskManager.promptNextAlert(self)
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		let navigationBarAppearance = UINavigationBar.appearance()
		navigationBarAppearance.barTintColor = TaskManager.sharedTaskManager.getTheme().background

		TaskManager.sharedTaskManager.refreshTaskManager()
		self.tasks = TaskManager.sharedTaskManager.getTasks()
		self.tableViewOutlet.reloadData()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        setEditing(false, animated: true)
	}
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableViewOutlet.isEditing = editing
    
        if(editing)
        {
            self.editButtonItem.image = #imageLiteral(resourceName: "done")
        }else
        {
            self.editButtonItem.image = #imageLiteral(resourceName: "trash")
        }
    }
    
    func setupDateformat()
    {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm a, EEEE, MMMM dd, yyyy"
    }
	@objc func reloadTableView()
	{
		print("hello")
		DispatchQueueMainSync { ()->(Void) in
			TaskManager.sharedTaskManager.refreshTaskManager()
			self.tasks = TaskManager.sharedTaskManager.getTasks()
			self.tableViewOutlet.reloadData()
			self.tableViewOutlet.setNeedsLayout()
			self.tableViewOutlet.layoutIfNeeded()
			self.tableViewOutlet.setNeedsDisplay()
		}
	}
    
    func setupNavigarionbaritems()
    {
        self.navigationItem.title = "My Tasks"
        self.tableViewOutlet.backgroundColor = TaskManager.sharedTaskManager.getTheme().tableBackground
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = TaskManager.sharedTaskManager.getTheme().background
        
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(#imageLiteral(resourceName: "plus2"), for: .normal)
        rightButton.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(addButtonActionHandler), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "trash")

    }
    @objc func addButtonActionHandler()
    {
        let taskEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskEditPageViewController") as! TaskEditPageViewController
        let taskEditNC: UINavigationController = UINavigationController(rootViewController: taskEditVC)
        self.present(taskEditNC, animated: true, completion: nil)
    }
}

extension ListTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("task count:" ,tasks.count)
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let category = task.getCategory()
        let title = task.getTitle()
        let description = task.getDescription()
        let eventStartTime = task.getScheduleStart()
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! ListTaskTableViewCell
        
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
        cell.taskImageView.image = image
        cell.titleLabel.text = title
        cell.titleLabel.font = cell.titleLabel.font.withSize(19)
		cell.titleLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
		cell.taskImageView.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        
        
		if description.isEmpty
		{
			let startDate = Date(timeIntervalSince1970: TimeInterval(eventStartTime))
			
			let timeStr = "from " + dateFormatter.string(from: startDate)
			
			let attributedStr = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
			
			cell.detailLabel.attributedText = attributedStr
		}else {
			var descriptionStr = "Description: "
			descriptionStr += description
			let attributedStr = NSMutableAttributedString(string: descriptionStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
			cell.detailLabel.attributedText = attributedStr
		}
		
		// Check for scheduling conflict
		if task.getScheduleStart() + task.getDuration() > task.getDeadline() {
			cell.titleLabel.textColor = UIColor.HalpColors.fuzzyWuzzy
		}
		
		return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        detailVC.task = self.tasks[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            tableView.beginUpdates()
            self.tasks.remove(at: indexPath.row)
            let taskId = TaskManager.sharedTaskManager.getTasks()[indexPath.row].getTaskId()
            TaskManager.sharedTaskManager.removeTask(taskID: taskId)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
			self.tasks = TaskManager.sharedTaskManager.getTasks()
        }
		tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
