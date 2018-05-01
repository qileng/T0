//
//  ListView.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
	
	// link this var to the label in StoryBoard
	@IBOutlet weak var ViewLabel: UILabel!
	
	var count = 0
	var viewName = "List View"
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		count += 1
		self.ViewLabel!.text = viewName + " appeared \(count) time" + ((count == 1) ? "" : "s")
	}
}
