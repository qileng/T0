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
    var detail: Any?
    var date:Date?
}

// Todo: code cleaning
class TaskEditPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    var datePickerIndexPath: IndexPath?
    var fieldData:[[CellData]] = [[]]
    var dateFormatter = DateFormatter()
    
    // Logic
    @IBAction func AddTask(_ sender: UIButton) {
        let taskTitle = fieldData[0][0].detail!
        
        let startDate = fieldData[1][0].detail as! Date
        let start = Int32(startDate.timeIntervalSince1970)
        
        let deadlineDate = fieldData[1][1].detail! as! Date
        let deadline = Int32(deadlineDate.timeIntervalSince1970)
        
        let categoryString = fieldData[2][0].detail! as! String
        
        var category: Category
        switch categoryString {
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
        
        // Not sure how to store alarm
        // Leave it out for now
        let alarm = fieldData[2][1].detail!
        
        let taskDesc = fieldData[3][0].detail!
        
        /*
        print(taskTitle)
        print(start)
        print(deadline)
        print(category.rawValue)
        print(alarm)
        print(taskDesc)
        print("\n")
         */
        
		let form = TaskForm(Title: taskTitle as! String, Description: taskDesc as! String, Category: category, Deadline: deadline, Schedule_start: start, UserID: TaskManager.sharedTaskManager.getUser().getUserID())
        
        // Todo: validate
        // Todo: exception handling
        TaskManager.sharedTaskManager.addTask(form)
        let taskDAO = TaskDAO(form)
        taskDAO.saveTaskInfoToLocalDB()
        
//        self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
//        self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
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
        let cell:UITableViewCell?
        if datePickerIndexPath != nil && datePickerIndexPath?.section == indexPath.section
                                    && datePickerIndexPath!.row == indexPath.row
        {
            cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.datePicker.rawValue, for: indexPath)
            let datePicker = cell?.viewWithTag(99) as! UIDatePicker

            if let date = fieldData[indexPath.section][indexPath.row-1].date
            {
                datePicker.setDate(date, animated: true)
            }
            return cell!
        }

        let celltype = self.fieldData[indexPath.section][indexPath.row].cellType
        switch (celltype)
        {
        case .textField:
            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
        case .dateDetail:
            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
            cell?.textLabel?.text = fieldData[indexPath.section][indexPath.row].title
            cell?.detailTextLabel?.text = dateFormatter.string(from: fieldData[indexPath.section][indexPath.row].detail as! Date)
            //        case .datePicker:
        //            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
        case .picker:
            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
        case .detail:
            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
            cell?.textLabel?.text = fieldData[indexPath.section][indexPath.row].title
            cell?.detailTextLabel?.text = fieldData[indexPath.section][indexPath.row].detail as? String
            // cell?.detailTextLabel?.text = dateFormatter.string(from: fieldData[indexPath.section][indexPath.row].detail as! Date)
        case .textView:
            cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
        default:
            cell = UITableViewCell()
        }
        return cell!
        
        
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
                selectedCell?.detailTextLabel?.textColor = .red
                datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            }
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.endUpdates()
            
        }else if indexPath.section == 2 // the selected row is in section 2
        {
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
    
//    @objc func handleTextInputChange()
//    {
//        let isFormValid = (textFieldOutlet.text?.count ?? 0) > 0 //&& (passwordTextField.text?.count ?? 0) > 0
//        if isFormValid
//        {
//            addButtonOutlet.isEnabled = true
//            addButtonOutlet.titleLabel?.text = "Add"
////            addButtonOutlet.titleLabel?.textColor = .white
//        } else
//        {
//            addButtonOutlet.isEnabled = false
//            addButtonOutlet.titleLabel?.text = ""
////            addButtonOutlet.tintColor = .black
//        }
//    }
    
 
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let parentIndexPath = IndexPath(row: datePickerIndexPath!.row-1, section: datePickerIndexPath!.section)
        
        let dateCell = tableViewOutlet.cellForRow(at: parentIndexPath)
//        var celldata = fieldData[parentIndexPath.section][parentIndexPath.row]
//        celldata.date = sender.date
//        celldata.detail = dateFormatter.string(from: sender.date)
        fieldData[parentIndexPath.section][parentIndexPath.row].date = sender.date
        fieldData[parentIndexPath.section][parentIndexPath.row].detail = sender.date
        dateCell?.detailTextLabel?.text = dateFormatter.string(from: sender.date)
//      self.tableViewOutlet.reloadData()
    }
    
    @IBAction func titleValueChanged(_ sender: LeftPaddedTextField) {
        fieldData[0][0].detail = sender.text!
    }

    // Initialize page
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addButtonOutlet.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        tableViewOutlet.backgroundColor = .clear
        //        tableViewOutlet.estimatedRowHeight = 45
        //        tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        //        tableViewOutlet.sectionHeaderHeight = UITableViewAutomaticDimension
        //remove empty cells in tableview
        tableViewOutlet.tableFooterView = UIView()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm a"
        
        guard let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else{return}
        
        let section0 = [CellData(cellType: .textField, title: "Title", detail: "", date: nil)]
        let section1 =
            [CellData(cellType: .dateDetail, title: "Starts", detail: Date(), date: Date()),
             CellData(cellType: .dateDetail, title: "Deadline", detail: Date(), date: date)]
        let section2 =
            [CellData(cellType: .detail, title: "Category", detail: "", date: nil),
             CellData(cellType: .detail, title: "Alarm", detail: "", date: nil)]
        let section3 = [CellData(cellType: .textView, title: "Description", detail: "", date: nil)]
        fieldData = [ section0, section1, section2, section3 ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tableViewOutlet.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
    }
}

// Extensions
extension TaskEditPageViewController : UITextViewDelegate, UITextFieldDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description"
        {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }
    
   
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (textField.text?.count)! > 0
//        {
//            addButtonOutlet.isEnabled = true
//            addButtonOutlet.titleLabel?.text = "Add"
//        }
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if (textField.text?.count)! <= 0
//        {
//            addButtonOutlet.isEnabled = false
//            addButtonOutlet.titleLabel?.text = ""
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = "Description"
            textView.textColor = .lightGray
            textView.font = UIFont.systemFont(ofSize: 17)
        }
        else {
            fieldData[3][0].detail = textView.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskEditPageViewController : TaskDetailTableViewControllerDelegate
{
    func changeDetail(text label:String, indexPath:IndexPath)
    {
        self.fieldData[indexPath.section][indexPath.row].detail = label
       // let cell = self.tableViewOutlet.cellForRow(at: indexPath)
       // cell?.detailTextLabel?.text = label
    }
}

