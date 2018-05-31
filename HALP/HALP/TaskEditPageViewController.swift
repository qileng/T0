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
    case toggle = "switchCell"
}
struct CellData {
    var cellType:CellTypes
    var title:String
    var detail: String?
    var date:Date?
    var countDownDuration:TimeInterval?
}

let StartTimeModeKey = "StartTimeMode"
private let datepickerTag = 99
private let deadlineDatePickerRow = 3
private let countDownTimerMinuteInterval = 5
private let textViewCellHeight:CGFloat = 128
private let regularCellHeight:CGFloat = 44
private let textFieldCellSection = 0
private let datePickerCellSection = 1
private let categoryAndAlarmSection = 2
private let textViewCellSection = 3

class TaskEditPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    var datePickerIndexPath: IndexPath?
    var fieldData:[[CellData]] = [[]]
    var dateFormatter = DateFormatter()
    var titleTextFieldCell:TextFieldTableViewCell?
    var descriptionTextViewCell: TextViewTableViewCell?
    var isStartTimeMode:Bool = UserDefaults.standard.bool(forKey: StartTimeModeKey)
//   UserDefaults.standard.set(true, forKey: StartTimeModeKey))
    //UserDefaults.standard.bool(forKey: StartTimeModeKey)

    var isEditMode:Bool = false
    var taskToEdit:Task?
    var indexForTaskToEdit:Int?
    
    
    // Logic
    @IBAction func AddTask(_ sender: UIButton) {
        print("executed \n")
        guard let title = self.titleTextFieldCell?.textFieldOutlet.text, !title.isEmpty else {
            self.shakeTitleInput()
            return
        }
        let description:String
        if self.descriptionTextViewCell?.textViewOutlet.text != "Description" {
            description = (self.descriptionTextViewCell?.textViewOutlet.text)!
        }else{
            description = ""
        }
        
        let categoryStr = fieldData[2][0].detail
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
        let startDate = Int32((fieldData[1][1].date?.timeIntervalSince1970 ?? 0))
        let deadlineDate = Int32((fieldData[1][2].date?.timeIntervalSince1970)!)
        let duration = Int32(fieldData[1][1].countDownDuration ?? 0)
        
        if isEditMode
        {
            self.taskToEdit?.setTitle(title)
            isStartTimeMode ? self.taskToEdit?.setScheduleStart(startDate) : self.taskToEdit?.setDuration(duration)
            self.taskToEdit?.setDeadline(deadlineDate)
            self.taskToEdit?.setCategory(category)
            self.taskToEdit?.setDescription(description)
			// Potential problem: Duration cannot be changed.
            let updateForm = TaskForm(Title: title, Description: description, Category: category,
                                      Alarm: (taskToEdit?.getAlarm())!, Deadline: deadlineDate,
                                      SoftDeadline: (taskToEdit?.getSoftDeadline())!,
                                      Schedule: startDate, Duration: (taskToEdit?.getDuration())!,
                                      Priority: (taskToEdit?.getPriority())!, Schedule_start: (taskToEdit?.getScheduleStart())!,
                                      Notification: (taskToEdit?.getNotification())!, TaskID: (taskToEdit?.getTaskId())!,
                                      UserID: TaskManager.sharedTaskManager.getUser().getUserID())
            TaskManager.sharedTaskManager.updateTask(form: updateForm)
        }else {
            let form = TaskForm(Title: title, Description: description, Category: category, Deadline: deadlineDate, Schedule: startDate, Duration: duration, UserID: TaskManager.sharedTaskManager.getUser().getUserID())
			
            //         Todo: validate
            //         Todo: exception handling
            TaskManager.sharedTaskManager.addTask(form)
//            let taskDAO = TaskDAO(form)
//            taskDAO.saveTaskInfoToLocalDB()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
//        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // UI
    func numberOfSections(in tableView: UITableView) -> Int {
        return fieldData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = fieldData[section].count
        if datePickerIndexPath != nil && section == 1//&& fieldData[section][0].cellType == CellTypes.dateDetail
        {
            numberOfRows += 1
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //datePicker is shown
        if datePickerIndexPath != nil && datePickerIndexPath?.section == indexPath.section
                                    && datePickerIndexPath!.row == indexPath.row
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.datePicker.rawValue, for: indexPath)
            let datePicker = cell.viewWithTag(datepickerTag) as! UIDatePicker
            if self.isStartTimeMode
            {
                if indexPath.row == deadlineDatePickerRow // deadline picker
                {
                    let atLeastdeadlineDate = Calendar.current.date(byAdding: .minute, value: 10, to: fieldData[indexPath.section][1].date!) //?? fieldData[indexPath.section][1].date
                    datePicker.minimumDate = atLeastdeadlineDate
                }
                if let date = fieldData[indexPath.section][indexPath.row-1].date
                {
                    datePicker.setDate(date, animated: true)
                }
                return cell
            }
            //durationMode
            if indexPath.row == 2 && datePickerIndexPath?.row == indexPath.row
            {
                DispatchQueue.main.async {
                    datePicker.datePickerMode = .countDownTimer
                    datePicker.minuteInterval = countDownTimerMinuteInterval
                    datePicker.countDownDuration = self.fieldData[indexPath.section][indexPath.row-1].countDownDuration ?? 0
                }
            }else //duration mode && deadline datepicker cell
            {
                print("durationMode indexpath.row: ",indexPath.row )
                if let date = fieldData[indexPath.section][indexPath.row-1].date
                {
                    datePicker.setDate(date, animated: true)
                }
            }
            return cell
        }
        print("indexPath: ",indexPath)
        let celltype = self.fieldData[indexPath.section][indexPath.row].cellType
        switch (celltype)
        {
        case .textField:
            titleTextFieldCell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath) as? TextFieldTableViewCell
            if isEditMode
            {
                self.titleTextFieldCell?.textFieldOutlet.text = taskToEdit?.getTitle()
                self.titleTextFieldCell?.valueChanged = {
                    self.taskToEdit?.setTitle((self.titleTextFieldCell?.textFieldOutlet.text)!)
                }
                return titleTextFieldCell!
            }
            if (titleTextFieldCell?.textFieldOutlet.text?.isEmpty)!
            {
                titleTextFieldCell?.textFieldOutlet.becomeFirstResponder()
            }
            return titleTextFieldCell!
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath) as! SwitchTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = fieldData[indexPath.section][indexPath.row].title
            cell.valueChanged = {
                self.isStartTimeMode = UserDefaults.standard.bool(forKey: StartTimeModeKey)
                self.fieldData[1][1] = self.startOrDurationToggle()
                DispatchQueue.main.async {
                    if self.datePickerIndexPath != nil
                    {
                        self.datePickerIndexPath = nil
                    }
                    self.tableViewOutlet.reloadData()
                }
            }
            return cell
        case .dateDetail:
            let cell = tableView.dequeueReusableCell(withIdentifier: celltype.rawValue, for: indexPath)
//            let cell = UITableViewCell(style: .value1, reuseIdentifier: celltype.rawValue)
            cell.textLabel?.text = fieldData[indexPath.section][indexPath.row].title
            let detailStr = fieldData[indexPath.section][indexPath.row].detail
            let attributedStr = NSMutableAttributedString(string: detailStr!, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            cell.detailTextLabel?.attributedText = attributedStr
//            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
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
            if isEditMode
            {
                var descriptionStr = taskToEdit?.getDescription()
                if descriptionStr == ""
                {
                    descriptionStr = "Description"
                }else
                {
                    descriptionTextViewCell?.textViewOutlet.textColor = .black
                }
                descriptionTextViewCell?.textViewOutlet.text = descriptionStr
                descriptionTextViewCell?.valueChanged = {
                    self.taskToEdit?.setDescription((self.descriptionTextViewCell?.textViewOutlet.text)!)
                }
            }
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
        var rowHeight = UITableViewAutomaticDimension
        if indexPath.section == datePickerCellSection
        {
            if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row
            {
                rowHeight = tableView.dequeueReusableCell(withIdentifier: CellTypes.datePicker.rawValue)?.frame.height ?? rowHeight
                return rowHeight
            }
        }else if (indexPath.section == textFieldCellSection) || (indexPath.section == categoryAndAlarmSection)
        {
            rowHeight = regularCellHeight
        }else if indexPath.section == textViewCellSection
        {
            rowHeight = textViewCellHeight
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

        if indexPath.section == datePickerCellSection && indexPath.row != 0// the selected row is in section 1, but not first row in that section
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

            
        }else if indexPath.section == categoryAndAlarmSection // the selected row is in section 2
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
        if !isStartTimeMode && datePickerIndexPath!.row-1 == 1 // datepicker countdown mode
        {
            let durationCell = tableViewOutlet.cellForRow(at: parentIndexPath)
            fieldData[parentIndexPath.section][parentIndexPath.row].countDownDuration = sender.countDownDuration
            fieldData[parentIndexPath.section][parentIndexPath.row].detail = getTimeStr(from: sender.countDownDuration)
            
            print("sender.countDownDuration: ", sender.countDownDuration)
            let detailStr = fieldData[parentIndexPath.section][parentIndexPath.row].detail ?? getTimeStr(from: sender.countDownDuration)
            let attributedStr = NSMutableAttributedString(string: detailStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.HalpColors.pastelRed ])
            self.tableViewOutlet.beginUpdates()
            durationCell?.detailTextLabel?.attributedText = attributedStr
            self.tableViewOutlet.endUpdates()
        }else
        { //datepicker date mode
            //check if date picker is
            let dateCell = tableViewOutlet.cellForRow(at: parentIndexPath)
            fieldData[parentIndexPath.section][parentIndexPath.row].date = sender.date
            fieldData[parentIndexPath.section][parentIndexPath.row].detail = dateFormatter.string(from: sender.date)
            
            let detailStr = dateFormatter.string(from: sender.date)
            let attributedStr = NSMutableAttributedString(string: detailStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light), NSAttributedStringKey.foregroundColor : UIColor.black ])
            dateCell?.detailTextLabel?.attributedText = attributedStr
            dateCell?.detailTextLabel?.textColor = UIColor.HalpColors.pastelRed
            dateCell?.detailTextLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    func getTimeStr(from countDownInterval:TimeInterval) -> String
    {
        let hours = Int(countDownInterval) / 3600
        let minutes = Int(countDownInterval) / 60 % 60
        if hours > 0
        {
            return String(format:"%2i hours %02i minutes", hours, minutes)
        }else{
            return String(format:"%02i minutes", minutes)
        }
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
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y = self.view.frame.height - self.buttonStackView.frame.height
            self.buttonStackView.frame = CGRect(x: 0, y: y, width: self.buttonStackView.frame.width, height: self.buttonStackView.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                let keyboardHeight:CGFloat = CGFloat(keyboardSize.height)
                let y: CGFloat = self.view.frame.height - keyboardHeight - self.buttonStackView.frame.height
                    self.buttonStackView.frame = CGRect(x: 0, y: y, width: self.buttonStackView.frame.width, height: self.buttonStackView.frame.height)
            }
        }, completion: nil)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
  
    func setTableViewDateSource()
    {
        guard let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else{return}
      
        if isEditMode //when it is EditMode
        {
            
            //            let startDate = Date(timeIntervalSince1970: TimeInterval((taskToEdit?.getScheduleStart())!))
            let deadlineDate = Date(timeIntervalSince1970: TimeInterval((taskToEdit?.getDeadline())!))
            
            //            let startDateStr = dateFormatter.string(from: startDate)
            let deadlineDateStr = dateFormatter.string(from: deadlineDate)
            
            var categoryStr:String = ""
            if let category = taskToEdit?.getCategory()
            {
                switch category {
                case Category.Study_Work:
                    categoryStr = "Study"
                case Category.Entertainment:
                    categoryStr = "Entertainment"
                case Category.Chore:
                    categoryStr = "Chore"
                case Category.Relationship:
                    categoryStr = "Social"
                }
            }
            //            let alarmStr =
            
            self.navigationItem.title = "Edit Task"
            self.addButtonOutlet.setTitle("Done", for: .normal)
            
            let section0 = [CellData(cellType: .textField, title: "Title", detail: "", date: nil, countDownDuration: nil)]
            let section1 =
                [CellData(cellType: .toggle, title: "Start Time", detail: "", date: nil, countDownDuration: nil),
                 //                 CellData(cellType: .dateDetail, title: "Starts", detail: startDateStr, date: startDate),
                    startOrDurationToggle(),
                    CellData(cellType: .dateDetail, title: "Deadline", detail: deadlineDateStr, date: deadlineDate, countDownDuration: nil)]
            let section2 =
                [CellData(cellType: .detail, title: "Category", detail: categoryStr, date: nil, countDownDuration: nil),
                 CellData(cellType: .detail, title: "Alarm", detail: "", date: nil, countDownDuration: nil)]
            let section3 = [CellData(cellType: .textView, title: "Description", detail: "", date: nil, countDownDuration: nil)]
            fieldData = [ section0, section1, section2, section3 ]
            
        }else // New Task page
        {
            self.navigationItem.title = "New Task"
            self.addButtonOutlet.setTitle("Add", for: .normal)
            
            let section0 = [CellData(cellType: .textField, title: "Title", detail: "", date: nil, countDownDuration: nil)]
            ////////////////////////////////////////////////////////////////////////////////////////////////
            let section1 =
                [CellData(cellType: .toggle, title: "Start Time", detail: "", date: nil, countDownDuration: nil),
                 //                CellData(cellType: .dateDetail, title: "Starts", detail: dateFormatter.string(from: Date()), date: Date()),
                    startOrDurationToggle(),
                    CellData(cellType: .dateDetail, title: "Deadline", detail: dateFormatter.string(from: date), date: date, countDownDuration: nil)]
            ////////////////////////////////////////////////////////////////////////////////////////////////
            let section2 =
                [CellData(cellType: .detail, title: "Category", detail: "", date: nil, countDownDuration: nil),
                 CellData(cellType: .detail, title: "Alarm", detail: "", date: nil, countDownDuration: nil)]
            let section3 = [CellData(cellType: .textView, title: "Description", detail: "", date: nil, countDownDuration: nil)]
            fieldData = [ section0, section1, section2, section3 ]
        }
    }
    
    func startOrDurationToggle() -> CellData
    {
        if self.isStartTimeMode
        {
            if self.isEditMode{
                let startDate = Date(timeIntervalSince1970: TimeInterval((taskToEdit?.getScheduleStart())!))
                let startDateStr = dateFormatter.string(from: startDate)
                return CellData(cellType: .dateDetail, title: "Starts", detail: startDateStr, date: startDate, countDownDuration: nil)
            }
            return CellData(cellType: .dateDetail, title: "Starts", detail: dateFormatter.string(from: Date()), date: Date(), countDownDuration: nil)
        }
        // Duration mode
        if isEditMode
        {
            let countDownDuration = TimeInterval((taskToEdit?.getDuration())!)
            let durationStr = getTimeStr(from: countDownDuration)//String(countDownDuration)
            return CellData(cellType: .dateDetail, title: "Duration", detail: durationStr, date: nil, countDownDuration: countDownDuration)
        }//Duration mode && Add new task page
        return CellData(cellType: .dateDetail, title: "Duration", detail: "", date: nil, countDownDuration: 0)
    }
    
    // Initialize page
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.cancelButtonOutlet.backgroundColor = taskColorTheme
        self.addButtonOutlet.backgroundColor = taskColorTheme
        
        self.cancelButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.addButtonOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        //remove empty cells in tableview
        tableViewOutlet.tableFooterView = UIView()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm a"
        
        setTableViewDateSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.tableViewOutlet.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

extension TaskEditPageViewController : TaskDetailTableViewControllerDelegate
{
    func changeDetail(text label:String, indexPath:IndexPath)
    {
        self.fieldData[indexPath.section][indexPath.row].detail = label
    }
}
