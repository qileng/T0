//
//  ModelController.swift
//  HALP
//
//  Created by Qihao Leng on 4/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

/*
A controller object that manages three rotating main pages of the system: a clock view, a list view and a setting page. Each page is an instance of a class of their own so that each page can have separate design of their own.
*/


class ModelController: NSObject, UIPageViewControllerDataSource {

	// declare each page as a constant
	let clockView: ClockViewController
//    let listView: ListTaskViewController
    let listNavVC: UINavigationController
	let settingPage: SettingViewController
	var page: [UIViewController]


	init(storyboard: UIStoryboard) {
		// initialize three main pages
		self.clockView = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as! ClockViewController
//        self.listView = storyboard.instantiateViewController(withIdentifier: "ListViewController") as!ListViewController
        self.settingPage = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        
        let listView = storyboard.instantiateViewController(withIdentifier: "ListTaskViewController") as! ListTaskViewController
//        let listView = storyboard.instantiateViewController(withIdentifier: "ListTaskViewController") as! ListTaskViewController
        listNavVC = UINavigationController(rootViewController: listView)
        listNavVC.isNavigationBarHidden = true
        
        
        
		// initialize page switching array
		self.page = [clockView, listNavVC, settingPage]
	    super.init()
	}

	func indexOfViewController(_ viewController: UIViewController) -> Int {
		// Return the index of the given data view controller.
		// For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
		return page.index(of: viewController) ?? NSNotFound
	}

	// MARK: - Page View Controller Data Source

	// this function automatically controls swiping back
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
	    var index = self.indexOfViewController(viewController)
	    if  (index == NSNotFound) {
	        return nil
	    }
		
		// connects first page to third page
		if index == 0 {
			index = self.page.count
		}
	    
	    index -= 1
	    return self.page[index]
	}

	// this function automatically controls swiping forword
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = self.indexOfViewController(viewController)
	    if index == NSNotFound {
	        return nil
	    }
	    
	    index += 1
		// connects third page to first page
	    if index == self.page.count {
			index = 0
	    }
	    return self.page[index]
	}

}

