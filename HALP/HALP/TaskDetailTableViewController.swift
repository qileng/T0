//
//  TaskDetailTableViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/18/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

protocol  TaskDetailTableViewControllerDelegate{
    func changeDetail(text label:String, indexPath:IndexPath)
}

class TaskDetailTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableViewOutlet: UITableView!
    var cellData:[String]?
    var delegate:TaskDetailTableViewControllerDelegate?
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOutlet.tableFooterView = UIView()
        self.tableViewOutlet.backgroundColor = .clear
//        self.setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData?.count ?? 0
        
    }
    
//    override public var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = cellData?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let text = cellData?[indexPath.row] ?? ""
        self.delegate?.changeDetail(text: text, indexPath: self.selectedIndexPath!)
        self.navigationController?.popViewController(animated: true)
    }
}
