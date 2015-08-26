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
    
    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
	
	var waiting: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm = CLLocationManager();
        longitude = CLLocationDegrees();
        latitude = CLLocationDegrees();
        
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        //lm.desiredAccuracy = kCLLocationAccuracyBest
        //lm.distanceFilter = 1000
        lm.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* 位置情報取得成功時に実行される関数 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        NSLog("latitude: \(latitude) , longitude: \(longitude)")
        lm.stopUpdatingLocation()
		
		// 位置情報がキャンパス内かどうか判定します
		// leftTop
		let lT: Dictionary = ["lat": 36.111226, "lon": 140.098593]
		// rightBottom
		let rB: Dictionary = ["lat": 26.1089814, "lon": 140.1013616]
		// 位置判定
		if((lT["lat"] > latitude && latitude > rB["lat"]) && (lT["lon"] < longitude && longitude < rB["lon"])){
			NSLog("キャンパス内にいます")
		}
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        NSLog("Error")
    }
	
	/* お誘いボタンをした時に実行される処理 */
	@IBAction func pushBtn(sender: AnyObject) {
		let str = "name=Akihisa Kodera&purpose=lunch"
		let strData = str.dataUsingEncoding(NSUTF8StringEncoding)

		//var url = NSURL(string: "http://153.121.59.91/tance/ApnsPHP-r100/sample_push.php")
		var url = NSURL(string: "http://153.121.59.91/tance/index.php")
		var request = NSMutableURLRequest(URL: url!)
		
		request.HTTPMethod = "POST"
		request.HTTPBody = strData
		
		//var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
		do{
			var data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
			//var dic =  try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
			var myData:NSString = try NSString(data:data, encoding: 1)!
			NSLog("\(myData)")
		}catch let error{
			NSLog("\(error)")
			return
		}
	}
	
	/* スイッチに変更があった時の処理 */
	@IBAction func changedSwitch(sender: UISwitch) {
		waiting = sender.on
		NSLog("\(waiting)")
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
    
    /* Table View */
    //let texts = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    /* 必須処理 */
    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    */
    /* 必須処理 */
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    */
    
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
    
    // functions needed to be implemented
    // for table view
	// セクション数
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	// セルの行数
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friends.count
	}
	
	// セルの内容を変更
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
		//let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath:  indexPath) as! CustomCell
		//let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
		let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
		cell.setCell(friends[indexPath.row])
		return cell
	}
}


