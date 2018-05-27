//
//  TaskEditPageViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/16/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

enum CellTypes:String {
    case dateDetail = "dateDetailCell"
    case textField = "textFieldCell"
    case picker = "pickerCell"
    case datePicker = "datePickerCell"
    case detail = "detailCell"
    case textView = "textViewCell"
    case basic = "basicCell"
}
struct CellData {
    var cellType:CellTypes
    var title:String
    var detail: String?
    var date:Date?
}

// Todo: code cleaning
class TaskEditPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    //    @IBOutlet weak var textViewOutlet: UITextView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    var datePickerIndexPath: IndexPath?
    var fieldData:[[CellData]] = [[]]
    var dateFormatter = DateFormatter()
    var titleTextFieldCell:TextFieldTableViewCell?
    var descriptionTextViewCell: TextViewTableViewCell?
    
    // Logic
    @IBAction func AddTask(_ sender: UIButton) {

        guard let title = self.titleTextFieldCell?.textFieldOutlet.text, !title.isEmpty else {
            self.shakeTitleInput()
            return
        }
//        let task:Task?
        let description:String
        if self.descriptionTextViewCell?.textViewOutlet.text != "Description" {
            description = (self.descriptionTextViewCell?.textViewOutlet.text)!
        }else{
            description = ""
        }
        let startDate = Int32((fieldData[1][0].date?.timeIntervalSince1970)!)
        let deadlineDate = Int32((fieldData[1][1].date?.timeIntervalSince1970)!)
        
        let categoryStr = fieldData[2][0].detail // why is detail type Any?
//        let alarm = fieldData[2][1].detail
        var category: Category
        switch categoryStr {
        case "Study":
            category = Category.Study_Work
        case "Work":
            category = Category.Study_Work
        case "Entertainment":
            category = Category.Entertainment
        case "Chore":
            category = Category.Chore
        case "Social":
            category = Category.Relationship
        default:
            category = Category.Study_Work
        }
        
        let form = TaskForm(Title: title, Description: description ?? "", Category: category, Deadline: deadlineDate, Schedule_start: startDate, UserID: TaskManager.sharedTaskManager.getUser().getUserID())
        
//         Todo: validate
//         Todo: exception handling
        TaskManager.sharedTaskManager.addTask(form)
        let taskDAO = TaskDAO(form)
        taskDAO.saveTaskInfoToLocalDB()
//
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // UI
    func numberOfSections(in tableView: UITableView) -> Int {
        return fieldData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = fieldData[section].count
        if datePickerIndexPath != nil && fieldData[section][0].cellType == CellTypes.dateDetail
        {
            numberOfRows += 1
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:UITableViewCell?
        if datePickerIndexPath != nil && datePickerIndexPath?.section == indexPath.section
                                    && datePickerIndexPath!.row == indexPath.row
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.datePicker.rawValue, for: indexPath)
            let datePicker = cell.viewWithTag(99) as! UIDatePicker

            if let date = fieldData[indexPath.section][indexPath.row-1].date
            {
                datePicker.setDate(date, animated: true)
            }
            return cell
        }

        let celltype = self.fieldData[indexPath.section][indexPath.row].cellType
        switch (celltype)
        {
        case .textField:
            titleTextFieldCell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath) as? TextFieldTableViewCell
            titleTextFieldCell?.textFieldOutlet.becomeFirstResponder()
            return titleTextFieldCell!
        case .dateDetail:
            let cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
            cell.textLabel?.text = fieldData[indexPath.section][indexPath.row].title
            let detailStr = fieldData[indexPath.section][indexPath.row].detail
            let attributedStr = NSMutableAttributedString(string: detailStr!, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            cell.detailTextLabel?.attributedText = attributedStr
            
            return cell
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
            cell.textLabel?.text = fieldData[indexPath.section][indexPath.row].title
            let detailStr = fieldData[indexPath.section][indexPath.row].detail
            let attributedStr = NSMutableAttributedString(string: detailStr!, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            cell.detailTextLabel?.attributedText = attributedStr
            
            return cell
        case .textView:
            let cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath) as! TextViewTableViewCell
            self.descriptionTextViewCell = cell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var rowHeight = tableView.rowHeight
        var rowHeight = UITableViewAutomaticDimension
        if indexPath.section == 1
        {
            if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row
            {
                rowHeight = tableView.dequeueReusableCell(withIdentifier: CellTypes.datePicker.rawValue)?.frame.height ?? rowHeight
                return rowHeight
            }
        }else if (indexPath.section == 0) || (indexPath.section == 2)
        {
            rowHeight = 44
        }else if indexPath.section == 3
        {
            rowHeight = 128
        }
        return rowHeight
    }

    /*
     When we tap a row, tableView:didSelectRowAtIndexPath: is called. There are three cases:
   1.  There is no date picker shown, we tap a row, then a date picker is shown just under it.
   2.  A date picker is shown, we tap the row just above it, then the date picker is hidden.
   3.  A date picker is shown, we tap a row that is not just above it, then the date picker is hidden and another date picker under the tapped row is shown. And there are two subcases:
        1) the tapped is above the shown date picker
        2) the tapped is under the shown date picker
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 // the selected row is in section 1
        {
            let selectedCell = tableViewOutlet.cellForRow(at: indexPath)
            tableView.beginUpdates()

            if datePickerIndexPath != nil && datePickerIndexPath!.row - 1 == indexPath.row
            { // case 2
                tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
                datePickerIndexPath = nil
                selectedCell?.detailTextLabel?.textColor = .black
            }else
            { // case 1, 3
                if datePickerIndexPath != nil
                { // case 3
                    let cell = tableViewOutlet.cellForRow(at: IndexPath(row: (datePickerIndexPath?.row)!-1, section: indexPath.section))
                    cell?.detailTextLabel?.textColor = .black
                    tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
                }
                selectedCell?.detailTextLabel?.textColor = UIColor.HalpColors.pastelRed
                datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            }
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.endUpdates()
            
        }else if indexPath.section == 2 // the selected row is in section 2
        {
            if datePickerIndexPath != nil
            {
                tableView.beginUpdates()
                let cell = tableViewOutlet.cellForRow(at: IndexPath(row: (datePickerIndexPath?.row)!-1, section: (datePickerIndexPath?.section)!))
                cell?.detailTextLabel?.textColor = .black
                tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
                datePickerIndexPath = nil
                tableView.endUpdates()
            }
            
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailTableViewController") as! TaskDetailTableViewController
            if fieldData[indexPath.section][indexPath.row].title == "Category"
            {
                detailVC.cellData = ["Study", "Work", "Entertainment", "Chore", "Social"]
            }else
                // Might need change
            { // "Alarm"
                detailVC.cellData = ["None", "At start time of Event", "5 minutes before",
                "10 minutes before", "15 minutes before", "30 minutes before",
                "1 Hours before", "2 Hours before"]
            }
            detailVC.selectedIndexPath = indexPath
            detailVC.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
//        tableViewOutlet.reloadData()
//        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func calculateDatePickerIndexPath(indexPathSelected: IndexPath) -> IndexPath
    {
        if datePickerIndexPath != nil && datePickerIndexPath!.row  <= indexPathSelected.row
        { // case 3.2
            return IndexPath(row: indexPathSelected.row, section: indexPathSelected.section)
        }else
        {
            // case 1, 3.1
            return IndexPath(row: indexPathSelected.row+1, section: indexPathSelected.section)
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let parentIndexPath = IndexPath(row: datePickerIndexPath!.row-1, section: datePickerIndexPath!.section)
        
        let dateCell = tableViewOutlet.cellForRow(at: parentIndexPath)
//        var celldata = fieldData[parentIndexPath.section][parentIndexPath.row]
//        celldata.date = sender.date
//        celldata.detail = dateFormatter.string(from: sender.date)
        fieldData[parentIndexPath.section][parentIndexPath.row].date = sender.date
        fieldData[parentIndexPath.section][parentIndexPath.row].detail = dateFormatter.string(from: sender.date)//sender.date
        dateCell?.detailTextLabel?.text = dateFormatter.string(from: sender.date)
//      self.tableViewOutlet.reloadData()
    }
    func shakeTitleInput()
    {
        UIView.animate(withDuration: 0.05, animations: { self.titleTextFieldCell?.textFieldOutlet.frame.origin.x -= 5 }, completion: { _ in
            UIView.animate(withDuration: 0.05, animations: { self.titleTextFieldCell?.textFieldOutlet.frame.origin.x += 10 }, completion: { _ in
                UIView.animate(withDuration: 0.05, animations: { self.titleTextFieldCell?.textFieldOutlet.frame.origin.x -= 10 }, completion: { _ in
                    UIView.animate(withDuration: 0.05, animations: {
                        self.titleTextFieldCell?.textFieldOutlet.frame.origin.x += 10 }, completion: { _ in
                        UIView.animate(withDuration: 0.05, animations: {
                            self.titleTextFieldCell?.textFieldOutlet.frame.origin.x -= 5 })
                    })
                })
            })
        })
    }

    // Initialize page
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Task"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.cancelButtonOutlet.backgroundColor = UIColor.HalpColors.pastelRed
        self.addButtonOutlet.backgroundColor = UIColor.HalpColors.pastelRed
        
        self.cancelButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.addButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        tableViewOutlet.backgroundColor = .clear
        //        tableViewOutlet.estimatedRowHeight = 45
        //        tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        //        tableViewOutlet.sectionHeaderHeight = UITableViewAutomaticDimension
        //remove empty cells in tableview
        tableViewOutlet.tableFooterView = UIView()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm a"
        
        
        guard let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else{return}
        let section0 = [CellData(cellType: .textField, title: "Title", detail: "", date: nil)]
        let section1 =
            [CellData(cellType: .dateDetail, title: "Starts", detail: dateFormatter.string(from: Date()), date: Date()),
             CellData(cellType: .dateDetail, title: "Deadline", detail: dateFormatter.string(from: date), date: date)]
        let section2 =
            [CellData(cellType: .detail, title: "Category", detail: "", date: nil),
             CellData(cellType: .detail, title: "Alarm", detail: "", date: nil)]
        let section3 = [CellData(cellType: .textView, title: "Description", detail: "", date: nil)]
        fieldData = [ section0, section1, section2, section3 ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
        self.tableViewOutlet.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = .black
//        self.navigationController?.navigationBar.backgroundColor = .clear
//        self.navigationController?.navigationBar.tintColor = .white
    }
}

extension TaskEditPageViewController : TaskDetailTableViewControllerDelegate
{
    func changeDetail(text label:String, indexPath:IndexPath)
    {
        self.fieldData[indexPath.section][indexPath.row].detail = label
    }
}
