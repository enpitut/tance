//
//  Friend.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/23.
//  Copyright © 2015年 myname. All rights reserved.
//

import Foundation

class Friend : NSObject {
	var name: NSString
	//var imageUrl: NSURL?
	var status: String
	
	init(name: String, status: String){
		self.name = name
		//self.imageUrl = imageUrl
		self.status = status
	}
}