//
//  ViewController.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/23.
//  Copyright © 2015 tance. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

	var checked: Bool!
	
	// 自分の名前(各自自分の名前を設定する)
	let myName: String = "Akihisa Kodera"
    
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
		let str = "name=" + myName
		let strData = str.dataUsingEncoding(NSUTF8StringEncoding)

		let url = NSURL(string: "http://153.121.59.91/tance/index.php")
		let request = NSMutableURLRequest(URL: url!)
		
		request.HTTPMethod = "POST"
		request.HTTPBody = strData
		
		// PHP側でechoされた値を取得
		/*
		var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
		*/
		do{
			let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
			//var dic =  try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
			let myData:NSString = NSString(data:data, encoding: 1)!
			NSLog("\(myData)")
		}catch let error{
			NSLog("\(error)")
			return
		}
	}
	
	/* スイッチに変更があった時の処理 */
	@IBAction func changedSwitch(sender: UISwitch) {
		checked = sender.on
		NSLog("\(checked)")
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
        
        self.setupFriends()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        //tableView?.delegate = self
        //tableView?.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupFriends() {
		let f1 = Friend(name: "Jun Obata", imageUrl: NSURL(string: "http://153.121.59.91/tance/thumb_data/thumb_obata.png"), checked: true)
		let f2 = Friend(name: "Banri Nakamura", imageUrl: NSURL(string: "http://153.121.59.91/tance/thumb_data/thumb_banri.png"), checked: false)
		let f3 = Friend(name: "Yu Hayakawa", imageUrl: NSURL(string: "http://153.121.59.91/tance/thumb_data/thumb_hayakawa.png"), checked: true)
		let f4 = Friend(name: "Yudai Moriya", imageUrl: NSURL(string: "http://153.121.59.91/tance/thumb_data/thumb_moriya.png"), checked: false)
		
        friends.append(f1)
        friends.append(f2)
        friends.append(f3)
		friends.append(f4)
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
}


