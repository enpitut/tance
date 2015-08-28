//
//  ViewController.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/23.
//  Copyright © 2015 tance. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
	var status: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// バッジの数を０にする
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	/* お誘いボタンをした時に実行される処理 */
	@IBAction func pushBtn(sender: AnyObject) {
		
		let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let myName: String = delegate.myName!
		let str = "inviter=" + myName
		let strData = str.dataUsingEncoding(NSUTF8StringEncoding)

//		let url = NSURL(string: "http://153.121.59.91/tance/index.php")
		let url = NSURL(string: "http://210.140.68.18/api/confirm")
		let request = NSMutableURLRequest(URL: url!)
		
		request.HTTPMethod = "POST"
		request.HTTPBody = strData
		
		// PHP側でechoされた値を取得
		do{
			let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
			let myData:NSString = NSString(data:data, encoding: 1)!
			NSLog("api/confirm: \(myData)")
		}catch let error{
			NSLog("\(error)")
			return
		}
		
	}
	
	/* スイッチに変更があった時の処理 */
	@IBAction func changedSwitch(sender: UISwitch) {
		status = sender.on
		NSLog("\(status)")
	}
}

/*
 *
 * メシ友達一覧画面
 *
 */
class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var friends:[Friend] = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.viewController2 = self
        self.setupFriends()
        /*
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
		*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupFriends() {
		let f1 = Friend(name: "obata", status: "1")
		let f2 = Friend(name: "banri", status: "0")
		let f3 = Friend(name: "haya", status: "1")
		let f4 = Friend(name: "moriya", status: "0")
		
        friends.append(f1)
        friends.append(f2)
        friends.append(f3)
		friends.append(f4)
    }
	
	/* 友達追加処理 */
	func addFriend(name: String, status: String){
		let f = Friend(name: name, status: status)
		friends.append(f)
	}
	
	/* 友達一覧更新 */
	func updateFriend(){
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
	}
	
	/* Table View に関する処理 */
	// セクション数
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	// セルの行数(必須)
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friends.count
	}
	
	// セルの内容を変更
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
		let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:  indexPath) as! CustomCell
		cell.setCell(friends[indexPath.row])
		return cell
	}
    func refreshCell(name: String, status: Int){
        if status == 1{
            //参加するとき
            
        }else{
            //不参加のとき
            
        }
        
    }
}


