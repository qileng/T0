//
//  TaskDetailTableViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/18/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

protocol TaskDetailTableViewControllerDelegate{
    func changeDetail(text label:String, indexPath:IndexPath)
}
private let categoryIndexPathRow = 0

class TaskDetailTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewOutlet: UITableView!
    var cellData:[String]?
    var delegate:TaskDetailTableViewControllerDelegate?
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOutlet.tableFooterView = UIView()
        self.tableViewOutlet.backgroundColor = .clear
        self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndexPath?.row == categoryIndexPathRow
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.image.rawValue, for: indexPath) as! ImageTableViewCell
            let categoryStr = self.cellData![indexPath.row]
            let image = categoryImg(from: categoryStr)
            cell.imageViewOutlet.image = image
            cell.titleLabelOutlet.text = categoryStr
            cell.imageViewOutlet.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.basic.rawValue, for: indexPath)
        cell.textLabel?.text = cellData?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let text = cellData?[indexPath.row] ?? ""
        self.delegate?.changeDetail(text: text, indexPath: self.selectedIndexPath!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func categoryImg(from string:String) -> UIImage
    {
        let image:UIImage
        switch string {
        case "Study":
            image = #imageLiteral(resourceName: "study")
        case "Entertainment":
            image = #imageLiteral(resourceName: "entertainment")
        case "Chore":
            image = #imageLiteral(resourceName: "chore")
        case "Social":
            image = #imageLiteral(resourceName: "relationship")
        default:
            image = #imageLiteral(resourceName: "study")
        }
        return image
    }
    
}
