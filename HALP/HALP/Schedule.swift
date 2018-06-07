//
//  Schedule.swift
//  HALP
//
//  Created by Qihao Leng on 5/29/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

extension TaskManager {
	func schedule() {
		// Get first available timespan
		self.clearTimeSpan()
		self.calculateTimeSpan()
		
		// Keep a collection of scheduled tasks
		var scheduled = [Task]()
		// Also keep a collection of not scheduled tasks
		// Pre-condition: sorted by priority.
		var toSchedule = self.getTasks()
		// First move all fixed tasks to scheduled
		for task in toSchedule {
			if task.getPriority() >= 2 || (task.getScheduleStart() != 0 && task.getScheduleStart() < Int(Date().timeIntervalSince1970)) {
				// It's guaranteed that fixed tasks are on top of the array, so always pop the first one from toSchedule.
				scheduled.append(task)
				toSchedule.remove(at: 0)
			}
		}
		// Sort Scheduled tasks by start time.
		scheduled.quickSort(0, scheduled.count-1, by: .time)
		
		// Repeat until toSchedule is empty
		while !toSchedule.isEmpty {
			// Looping on a timestamp pointing to first available start time
			var firstAvailable = self.getTimespan().0
			// The current task being scheduled
			let current = toSchedule[0]
			// Mark the current position inside the scheduled Task collection.
			var taskIndex = 0
			// Determine the first fixed block after firstAvailable time.
			while taskIndex != scheduled.count && scheduled[taskIndex].getScheduleStart() + scheduled[taskIndex].getDuration() <= firstAvailable {
				taskIndex += 1
			}
			// If current fixed block contains firstAvailable, we need to go to the end.
			if taskIndex != scheduled.count && scheduled[taskIndex].getScheduleStart() <= firstAvailable {
				firstAvailable = scheduled[taskIndex].getScheduleStart() + scheduled[taskIndex].getDuration()
				taskIndex += 1
			}
			// Looping
			// IMPORTANT LOOP INVARIANT: scheduled[taskIndex].scheduleStart > firstAvailable
			while true {
				// Exit condition: current must ends before the end of day, if not, we need to go to next available day.
				if firstAvailable + current.getDuration() > self.getTimespan().1 {
					// Go to next day. Break this while loop to next iteration of outer while loop.
					self.calculateTimeSpan()
					break
				}
				// Exit condition: If no fixed block is before firstAvailable, just insert there.
				if taskIndex == scheduled.count {
					current.setScheduleStart(firstAvailable)
					let DAO = TaskDAO()
					_ = DAO.updateTaskInfoInLocalDB(taskId: current.getTaskId(), scheduleStart: Int(current.getScheduleStart()))
					scheduled.append(current)
					toSchedule.remove(at: 0)
					break
				}
				// Try to insert the first task at firstAvailable
				if firstAvailable + current.getDuration() <= scheduled[taskIndex].getScheduleStart() {
					// If current fits inbetween firstAvailable and current scheduled task.
					current.setScheduleStart(firstAvailable)
					let DAO = TaskDAO()
					_ = DAO.updateTaskInfoInLocalDB(taskId: current.getTaskId(), scheduleStart: Int(current.getScheduleStart()))
					// Insert current into scheduled before the fixed block to maintain order.
					scheduled.insert(current, at: taskIndex)
					taskIndex += 1
					toSchedule.remove(at: 0)
					break
				} else {
					// Current does not fit in, so move to next available
					firstAvailable = scheduled[taskIndex].getScheduleStart() + scheduled[taskIndex].getDuration()
					taskIndex += 1
				}
			}
		}
	}
}
