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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return TaskManager.sharedTaskManager.getTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = TaskManager.sharedTaskManager.getTasks()[indexPath.row]
        let category = task.getCategory()
        let title = task.getTitle()
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
        cell.detailLabel.text = String(eventStartTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = TaskManager.sharedTaskManager.getTasks()[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        guard let originFrame = cell?.frame.origin else{return}
        print(task)
        print(task.getTitle())
        print(task.getDescription())
        print(task.getSchedule())
        print(originFrame)

//        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
//        UIView.animate(withDuration: 0.2, animations: {
//            cell?.frame.origin = CGPoint(x: self.tableViewOutlet.frame.origin.x, y: self.tableViewOutlet.frame.origin.y)
//        }) { (true) in
////            self.present(detailVC, animated: false, completion: nil)
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn , animations: {
//                cell?.frame = CGRect(x: self.tableViewOutlet.frame.origin.x, y: self.tableViewOutlet.frame.origin.y, width: (cell?.frame.width)!, height: self.view.frame.height)
//            }, completion: { (true) in
//                cell?.frame = originFrame
//            })
//        }

        
        
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

