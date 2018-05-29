//
//  Schedule.swift
//  HALP
//
//  Created by Qihao Leng on 5/28/18.
//  Written by David & Qinlong
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

extension TaskManager {
	
	func scheduleHelper(taskFixed:[DateInterval],startTime:Date?,changeStartTime:Bool) -> Array<DateInterval> {
		var taskFloat = [DateInterval]()
		let calendar = Calendar.current
		var startComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: taskFixed[0].start)
		if (changeStartTime == true) {
			startComponents.hour = Calendar.current.component(Calendar.Component.hour, from: startTime!)
			startComponents.minute = Calendar.current.component(Calendar.Component.minute, from: startTime!);
			startComponents.second = Calendar.current.component(Calendar.Component.second, from: startTime!);
		}
		if (changeStartTime == false){
			startComponents.hour = (Int)(self.getSetting().getStartTime())
			startComponents.minute = 0
			startComponents.second = 0
		}
		var endComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: taskFixed[0].start)
		if self.getSetting().getEndTime() == 24 {
			endComponents.hour = 23
			endComponents.minute = 59
			endComponents.second = 59
		}
		else {
			endComponents.hour = (Int)(self.getSetting().getEndTime())
			endComponents.minute = 0
			endComponents.second = 0
		}
		var i = 0
		var freeTime = DateInterval()
		//make a copy of the array to sort
		var sortedArray = taskFixed
		//sort the array by DateInterval start time.
		sortedArray = sortedArray.sorted(by: { (d1: DateInterval, d2: DateInterval) -> Bool in
			return d1.start < d2.start
		})
		//if you have free time from 8am to your first task
		if sortedArray[0].start > calendar.date(from: startComponents)! {
			freeTime = DateInterval(start: calendar.date(from: startComponents)!, end: sortedArray[0].start)
			taskFloat.append(freeTime)
		}
			//else your first task is at 8am
		else {
			for entry in sortedArray {
				//check if this is your last task
				if i == sortedArray.count - 1 {
					//if it is, then after it ends, you are free until 11:59PM of today
					freeTime = DateInterval(start: sortedArray[i].end, end: calendar.date(from: endComponents)!)
					taskFloat.append(freeTime)
					break
				}
				//Your free time is defined by the time in between the tasks
				freeTime = DateInterval(start: sortedArray[i].end, end: sortedArray[i+1].start)
				taskFloat.append(freeTime)
				i += 1
			}
		}
		return taskFloat
	}
	
	func scheduleKeyGetter(item:Task) -> Date? {
		let date = Date(timeIntervalSince1970: (Double)(item.getScheduleStart()));
		var component:DateComponents = DateComponents();
		component.year = Calendar.current.component(Calendar.Component.year, from: date);
		component.month = Calendar.current.component(Calendar.Component.month,from:date);
		component.day = Calendar.current.component(Calendar.Component.day,from:date);
		//print("check initializer \(Calendar.current.component(Calendar.Component.hour, from: date))");
		component.hour = 8;
		component.minute = 0;
		component.second = 0;
		//print("component day is \(component.day!)");
		return Calendar.current.date(from: component);
	}
	
	// Schedule all tasks
	func schedule() {
		var taskFloat = [DateInterval]();
		var slots = [Date:[DateInterval]]();
		
		//encapsulate all date
		for item in self.getTasks() {
			
			if (item.getPriority() == 2) {
				let key = scheduleKeyGetter(item: item)
				if (slots[key!] == nil) {
					slots[key!] = [DateInterval]();
				}
				slots[key!]!.append(DateInterval(start: Date(timeIntervalSince1970: (Double)(item.getSchedule())), duration: (Double)(item.getDuration())));
			}
		}
		// taskDate.append((interval:DateInterval(start: Date(timeIntervalSince1970:(Double)(item.getSchedule())), duration: item.getDuration()) ,priority:item.getPriority()));
		
		for item in self.getTasks() {
			if (item.getPriority() < 2) {
				let itemStart = Date(timeIntervalSince1970: (Double)(item.getSchedule()));
				let itemEnd = Date(timeIntervalSince1970: (Double)(item.getDeadline()));
				let key = scheduleKeyGetter(item:item)
				var found:Bool = false;
				// case if there are some tasks on startTime
				if (slots[key!] != nil) {
					taskFloat = scheduleHelper(taskFixed:slots[key!]!,startTime: Date(timeIntervalSince1970: (Double)(item.getScheduleStart())),changeStartTime: true);
					if (taskFloat.count != 0) {
						// can found fit time in the day of start time and the time is before deadline
						for gap in taskFloat {
							// that gap fits the requirement and start Time is before deadline // attention this is same day as startTime
							
							// TODO modify case 2 done
							if (gap.duration >= (Double)(item.getDuration()) && Date(timeInterval: (Double)(item.getDuration()), since: gap.start) <= itemEnd){
								let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
								try? item.propertySetter(["scheduled_start":newStartTime]);
								slots[key!]!.append(DateInterval(start:gap.start, duration:(Double)(item.getDuration())));
								found = true;
								break;
							}
							
						}
					}
					// can't found fit time in the day of start time
					if (found == false) {
						var keyNew = Date(timeInterval: 24*60*60, since: key!);
						//continue search the next day till found the first gap that really fits before deadline
						while (found == false && keyNew <= itemEnd) {
							
							
							// next day has fixed tasks
							if (slots[keyNew] != nil) {
								taskFloat = scheduleHelper(taskFixed: slots[keyNew]!,startTime: nil,changeStartTime: false);
								// there is gap on the fixe tasks day
								if (taskFloat.count != 0) {
									for gap in taskFloat {
										if (gap.duration >= (Double)(item.getDuration()) && Date(timeInterval: (Double)(item.getDuration()), since: gap.start) <= itemEnd )
										{
											// if the gap we found fits and before deadline
											//CASE 3 TODO MODIFY (done)
											let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
											try? item.propertySetter(["scheduled_start":newStartTime]);
											slots[keyNew]!.append(DateInterval(start: gap.start, duration: (Double)(item.getDuration())));
											found = true;
											break;
										}
										
									}
								}
								
								
							}
								//next day doesn't have fixed tasks
							else {
								// this chunck of code set the correct DateInterval start //
								var tempComponentStart:DateComponents = DateComponents();
								tempComponentStart.year = Calendar.current.component(Calendar.Component.year, from: keyNew);
								tempComponentStart.month = Calendar.current.component(Calendar.Component.month, from: keyNew);
								tempComponentStart.day = Calendar.current.component(Calendar.Component.day, from: keyNew);
								tempComponentStart.hour = (Int)(self.getSetting().getStartTime());
								tempComponentStart.minute = 0;
								tempComponentStart.second = 0;
								
								var tempComponentEnd:DateComponents = DateComponents();
								tempComponentEnd.year = Calendar.current.component(Calendar.Component.year, from: keyNew);
								tempComponentEnd.month = Calendar.current.component(Calendar.Component.month, from: keyNew);
								tempComponentEnd.day = Calendar.current.component(Calendar.Component.day, from: keyNew);
								if ((Int)(self.getSetting().getEndTime()) < 24) {
									tempComponentEnd.hour = (Int)(self.getSetting().getEndTime());
									tempComponentStart.minute = 0;
									tempComponentStart.second = 0;
								}
									// end time can only be 11:59:59 in the worst case
								else {
									tempComponentEnd.hour = (Int)(self.getSetting().getEndTime()) - 1;
									tempComponentEnd.minute = 59;
									tempComponentEnd.second = 59;
								}
								taskFloat = [DateInterval(start: Calendar.current.date(from: tempComponentStart)!, end: Calendar.current.date(from: tempComponentEnd)!)];
								// this chunck of code set correct dateInterval end
								
								
								
								// MODIFY CASE 4 TODO (done)
								if (Calendar.current.isDate(itemEnd, inSameDayAs: keyNew) == true && (DateInterval(start: taskFloat[0].start, end: itemEnd).duration > (Double)(item.getDuration()))) {
									slots[keyNew] = [DateInterval]();
									let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
									let newDuration = (Int32)(DateInterval(start: taskFloat[0].start, end: itemEnd).duration);
									try? item.propertySetter(["duration":newDuration,"scheduled_start":newStartTime])
									found = true;
									slots[keyNew]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(newDuration)));
									break;
									
								}
								else {
									slots[keyNew] = [DateInterval]();
									// fix here
									
									
									
									//taskFloat = scheduleHelper(taskFixed: slots[keyNew]!);
									let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
									try? item.propertySetter(["scheduled_start":newStartTime]);
									found = true;
									slots[keyNew]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(item.getDuration())));
									break;
								}
							}
							if (found == false) {
								keyNew = Date(timeInterval: 24*60*60, since: keyNew);
							}
						}
					}
				}
					//case no task on the startTime
					//TODO modify this else case 1
				else {
					// this chunck of code intends to give correct start and ending time of the day start //
					var tempComponentStart:DateComponents = DateComponents();
					tempComponentStart.year = Calendar.current.component(Calendar.Component.year, from: key!);
					tempComponentStart.month = Calendar.current.component(Calendar.Component.month, from: key!);
					tempComponentStart.day = Calendar.current.component(Calendar.Component.day, from: key!);
					tempComponentStart.hour = (Int)(Calendar.current.component(Calendar.Component.hour, from: itemStart));
					tempComponentStart.minute = (Int)(Calendar.current.component(Calendar.Component.minute, from: itemStart));
					tempComponentStart.second = (Int)(Calendar.current.component(Calendar.Component.second, from: itemStart));
					
					var tempComponentEnd:DateComponents = DateComponents();
					tempComponentEnd.year = Calendar.current.component(Calendar.Component.year, from: key!);
					tempComponentEnd.month = Calendar.current.component(Calendar.Component.month, from: key!);
					tempComponentEnd.day = Calendar.current.component(Calendar.Component.day, from: key!);
					if ((Int)(self.getSetting().getEndTime()) < 24) {
						tempComponentEnd.hour = (Int)(self.getSetting().getEndTime());
						tempComponentStart.minute = 0;
						tempComponentStart.second = 0;
					}
						// end time can only be 11:59:59 in the worst case
					else {
						tempComponentEnd.hour = (Int)(self.getSetting().getEndTime()) - 1;
						tempComponentEnd.minute = 59;
						tempComponentEnd.second = 59;
					}
					
					taskFloat = [DateInterval(start: Calendar.current.date(from: tempComponentStart)!, end: Calendar.current.date(from: tempComponentEnd)!)]
					//gives correct start and ending time of day end||||
					
					
					
					
					// hasn't consider the deadline case yet
					if ( Calendar.current.isDate(itemEnd, inSameDayAs: key!) == true && DateInterval(start: taskFloat[0].start, end: itemEnd).duration < (Double)(item.getDuration())) {
						slots[key!] = [DateInterval]();
						let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
						let newDuration = (Int32)(DateInterval(start: taskFloat[0].start, end: itemEnd).duration);
						try? item.propertySetter(["duration":newDuration,"scheduled_start":newStartTime])
						found = true;
						slots[key!]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(newDuration)));
						break;
						
					} else {
						slots[key!] = [DateInterval]();
						// fix here
						
						let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
						try? item.propertySetter(["scheduled_start":newStartTime])
						slots[key!]!.append(DateInterval(start:taskFloat[0].start,duration:(Double)(item.getDuration())));
						found = true;
						break;
					}
				}
			}
		}
	}
}
