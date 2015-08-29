//
//  FooTableViewController.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/24.
//  Copyright © 2015年 myname. All rights reserved.
//

import UIKit

class FooTableViewController: UITableViewController {
	
	let ftd = FooTableData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ftd.items.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->  UITableViewCell {
	let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FooTableViewCell // ここを忘れないように
	let item = ftd.places[indexPath.row]
	let title.text = item.title
	let subTitle.text = item.subTitle
	return cell
	}
}