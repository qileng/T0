//
//  ListTaskViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/19/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class ListTaskViewController: UIViewController {

    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var topView: UIView!
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.dateFormat = "HH:mm a, EEEE, MMMM dd, yyyy"
        
        self.tableViewOutlet.tableFooterView = UIView()

        UIApplication.shared.statusBarStyle = .lightContent
//        89, 38, 47
        topView.backgroundColor = UIColor.rgbColor(89, 38, 47).withAlphaComponent(0.5)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewOutlet.reloadData()
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
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
        
        if description.isEmpty
        {
            let startDate = Date(timeIntervalSince1970: TimeInterval((task.getScheduleStart())))
            cell.detailLabel.text = "from " + dateFormatter.string(from: startDate)
        }else {
            cell.detailLabel.text = description//String(eventStartTime)
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
            
//           .remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            TaskManager.sharedTaskManager.
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

