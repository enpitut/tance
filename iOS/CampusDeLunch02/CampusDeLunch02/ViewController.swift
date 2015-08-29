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
	
	/* グローバル変数をもつインスタンス */
	let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
    override func viewDidLoad() {
        super.viewDidLoad()
		appDel.waitState = true
		// バッジの数を０にする
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	/*
	 *
	 * Step.1 Device(Sasower) -> Server
	 *
	 */
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
		appDel.waitState = sender.on
		NSLog("switch: \(appDel.waitState)")
	}
}

/*
 *
 * メシ友達一覧画面
 *
 */
class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var friends:[Friend] = [Friend]()
	
    @IBOutlet weak var tableView: UITableView!
	
	/* 戻るボタン */
	@IBAction func prevBtn(sender: AnyObject) {
		let firstViewController: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController1") as! ViewController
		self.presentViewController(firstViewController, animated: false, completion: nil)
		// フレンドリストの初期化
		appDel.friendList = [Friend]()
	}
	
	/* グローバル変数をもつインスタンス */
	let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
    override func viewDidLoad() {
        super.viewDidLoad()
        //let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		self.navigationController?.popViewControllerAnimated(true)
        tableView?.delegate = self
        tableView?.dataSource = self
		
		// バックグラウンドからのTableView更新ができないため、タイマーでフレンド情報を取得する
		NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
    }
	
	// タイマーによる定期更新される処理
	func onUpdate(timer : NSTimer){
		friends = appDel.friendList
		self.tableView.reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		tableView?.reloadData()
		super.viewWillAppear(true)
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/* Table View に関する処理 */
	// セルの行数（必須）
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friends.count
	}
	
	// セルの内容を変更（必須）
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
		let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:  indexPath) as! CustomCell
		cell.setCell(friends[indexPath.row])
		return cell
	}
}


