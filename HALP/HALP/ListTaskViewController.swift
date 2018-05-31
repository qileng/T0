//
//  ListTaskViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/19/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

let taskColorTheme = TaskManager.sharedTaskManager.getTheme().background
//let taskColorTheme = UIColor.HalpColors.fuzzyWuzzy
class ListTaskViewController: UIViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tasks"
    
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "plus2"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addButtonActionHandler), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus2"), style: .plain, target: self, action: #selector(addButtonActionHandler))
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.dateFormat = "HH:mm a, EEEE, MMMM dd, yyyy"
        
//        self.tableViewOutlet.tableFooterView = UIView()

//        UIApplication.shared.statusBarStyle = .lightContent
//        89, 38, 47
    }
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Prompt past tasks alerts
		TaskManager.sharedTaskManager.promptNextAlert(self)
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		TaskManager.sharedTaskManager.refreshTaskManager()
        tableViewOutlet.reloadData()
    }
    
//    @IBAction func addButtonTouched(_ sender: UIButton) {
//        let taskEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskEditPageViewController") as! TaskEditPageViewController
//        let taskEditNC: UINavigationController = UINavigationController(rootViewController: taskEditVC)
//        self.present(taskEditNC, animated: true, completion: nil)
//    }
    @objc func addButtonActionHandler()
    {
        let taskEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskEditPageViewController") as! TaskEditPageViewController
        let taskEditNC: UINavigationController = UINavigationController(rootViewController: taskEditVC)
        self.present(taskEditNC, animated: true, completion: nil)
    }
    
}

extension ListTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("task count:" ,TaskManager.sharedTaskManager.getTasks().count)
        return TaskManager.sharedTaskManager.getTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = TaskManager.sharedTaskManager.getTasks()[indexPath.row]
        let category = task.getCategory()
        let title = task.getTitle()
        let description = task.getDescription()
        let eventStartTime = task.getSchedule()
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
        
        if description.isEmpty
        {
            let startDate = Date(timeIntervalSinceNow: TimeInterval(eventStartTime))
            
            let timeStr = "from " + dateFormatter.string(from: startDate)
            
            let attributedStr = NSMutableAttributedString(string: timeStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
            
            cell.detailLabel.attributedText = attributedStr
        }else {
           let attributedStr = NSMutableAttributedString(string: description, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .thin), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
            cell.detailLabel.attributedText = attributedStr
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        detailVC.task = TaskManager.sharedTaskManager.getTasks()[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let taskId = TaskManager.sharedTaskManager.getTasks()[indexPath.row].getTaskId()
            TaskManager.sharedTaskManager.removeTask(taskID: taskId)
            tableView.reloadData()
            print("Task Deleted")
        }
//
//        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
//            // share item at indexPath
////            print("I want to share: \(self.tableArray[indexPath.row])")
//        }
//
//        edit.backgroundColor = .lightGray
        return [delete]
    }
}

