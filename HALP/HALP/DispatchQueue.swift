//
//  DispatchQueue.swift
//  HALP
//
//  Created by Qihao Leng on 6/6/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

func DispatchQueueMainSync (_ execution: @escaping ()->(Void)) {
	DispatchQueue.global().async {
		DispatchQueue.main.sync {
			execution()
		}
	}
}

func DispatchQueueMainAsync (_ execution: @escaping ()->(Void)) {
	DispatchQueue.main.async {
		execution()
	}
}
