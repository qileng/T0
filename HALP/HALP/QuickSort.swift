//
//  QuickSort.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation


// Quick sort extension for [Task]
extension Array where Element: Task {
	mutating func quickSort(_ head: Int, _ tail: Int) {
		if (head >= tail) {
			return
		}
		
		let pivot = self.partition(head, tail)
		self.quickSort(head, pivot)
		self.quickSort(pivot+1, tail)
	}
	
	mutating func partition(_ head: Int, _ tail: Int) -> (Int) {
		let p: Task = self[head]
		var i = head - 1
		var j = tail + 1
		while true {
			repeat {
				i = i + 1
			} while self[i] > p
			repeat {
				j = j - 1
			} while self[j] < p
			
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
