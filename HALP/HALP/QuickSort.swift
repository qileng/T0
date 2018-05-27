//
//  QuickSort.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

enum SortingType: Int {
	case time = 0
	case priority = 1
}

// Quick sort extension for [Task]
extension Array where Element: Task {
	mutating func quickSort(_ head: Int, _ tail: Int, by t: SortingType) {
		if (head >= tail) {
			return
		}
		
		let pivot = self.partition(head, tail, by: t)
		self.quickSort(head, pivot, by: t)
		self.quickSort(pivot+1, tail, by: t)
	}
	
	mutating func partition(_ head: Int, _ tail: Int, by t: SortingType) -> (Int) {
		let p: Task = self[head]
		var i = head - 1
		var j = tail + 1
		while true {
			repeat {
				i = i + 1
			} while ((t == .priority) ? self[i] > p : self[i] << p)
			repeat {
				j = j - 1
			} while ((t == .priority) ? self[j] < p : self[j] >> p)
			
			if i < j {
				let temp = self[i]
				self[i] = self[j]
				self[j] = temp
			} else {
				return j
			}
		}
	}
}
