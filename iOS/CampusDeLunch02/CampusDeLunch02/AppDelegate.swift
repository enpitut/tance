//
//  AppDelegate.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/23.
//  Copyright © 2015年 myname. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

	
    var window: UIWindow?
    var viewController2: ViewController2!
	var timer: NSTimer!

	/* 位置情報取得のための変数 */
	var lm: CLLocationManager!
	var latitude: CLLocationDegrees!
	var longitude: CLLocationDegrees!
//	var current: CLLocation!
	// 筑波大学中心地点
	let c_latitude = 36.1104929
	let c_longitude = 140.0994325
//	var center: CLLocation!
	// 2点間の距離と閾値半径（m）
	var distance: Double = 0.0
	let radius: Double = 500.0
	// 自分の名前(各自自分の名前を設定する)
	let myName: String? = "aki"

	func application( application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		let types : UIUserNotificationType =
		[UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
		let settins : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(settins)
		// バックグラウンドで実行されるインターバルを指定
		//UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

		return true
	}
	
	func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
		// サイレントプッシュ通知のため以下の１行を追加
		application.unregisterForRemoteNotifications()
		application.registerForRemoteNotifications()
	}
	
	/* デバイストークン取得 */
	func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
		// <>と" "(空白)を取る
		let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
		let deviceTokenString: String = ( deviceToken.description as NSString )
			.stringByTrimmingCharactersInSet( characterSet )
			.stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
		NSLog(deviceTokenString)
		
		/* 位置情報を取得 */
		lm = CLLocationManager();
		longitude = CLLocationDegrees();
		latitude = CLLocationDegrees();
		
		lm.delegate = self
		lm.requestAlwaysAuthorization()
		
		//位置情報の精度
		//lm.desiredAccuracy = kCLLocationAccuracyBest
		//位置情報取得間隔(m) 100m間隔で位置情報を更新
		lm.distanceFilter = 100
		
		lm.allowDeferredLocationUpdatesUntilTraveled(CLLocationDistanceMax, timeout: 3)
		
		lm.pausesLocationUpdatesAutomatically = false
		lm.startUpdatingLocation()
		
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print(error)
	}

    func applicationWillResignActive(application: UIApplication) {
		/* アクティブからホームボタンを押してバックグラウンドに切り替わる瞬間の処理 */
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
	
	func application(application: UIApplication, var didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		NSLog("PUSH通知を受け取りました")
		print(userInfo)
		print(userInfo["inviter"]) // 誘った人の名前
		print(userInfo["invitee"]) // 誘われた人の名前
		print(userInfo["status"]) // 誘われた人が行けるかどうか
		// 送信用パラメータ
		let inviter: String = userInfo["inviter"] as! String
		let invitee: String = userInfo["invitee"] as! String
		/*
		var invitee: String?
		invitee = userInfo["invitee"] as? String
		*/
		var status: NSString
		status = userInfo["status"] as! NSString
		//var status = 0 as! NSNumber
		/* ["status"]がNSString型である場合に実行する
		if let _status = userInfo["status"] as? NSString {
			var inCampus = _status as NSString
			print(inCampus)
		}
		*/
		
		
		// プッシュ通知が来たときデバイスの状況に合わせて振り分け
		switch(application.applicationState) {
		case .Active:
			/* アクティブ時 処理 */
			NSLog("Active!")
			
			/* ステータスをチェックして相手が参加できるかどうか確認する */
			if status == "1" {
				NSLog("test")
				// 誘った相手が参加できる：CustomCellを追加する
				let storybiard = UIStoryboard(name: "Main", bundle: nil)
				let vc2 = storybiard.instantiateViewControllerWithIdentifier("ViewController2") as! ViewController2
				//vc2.addFriend(invitee, status: status as String)
				//vc2.updateFriend()
				//vc2.cell.setCell(Friend(name: invitee, status: status as String))
				
			}else{
				// 誘った相手が参加できない：特に何もしない
			}
			
		case .Background:
			/* バックグラウンド時 処理 */
			NSLog("Background..")
			
			if inviter == myName {
				// 私は「さそわー」です（誘う人）
				NSLog("I am SASOWER.")
			}else{
				// 私は「さそうぃー」です（誘われる人）
				NSLog("I am SASOWEE.")
				
				// 中心点からの距離でキャンパス内にいるかどうか判定
				let current = CLLocation(latitude: latitude, longitude: longitude)
				let center = CLLocation(latitude: c_latitude, longitude: c_longitude)
				distance = center.distanceFromLocation(current)
				//NSLog("\(distance)m")
				if(distance < 1000){ // 1km以内
					NSLog("キャンパス内にいます")
					status = "1"
				}else{
					NSLog("キャンパス外です")
					status = "0"
				}
			}
			
			
			/* パラメータをポストする */
			let postParam = "inviter=" + inviter + "&invitee=" + invitee + "&status=" + String(status)
			NSLog("\(postParam)");
			let strData = postParam.dataUsingEncoding(NSUTF8StringEncoding)
			
			//let url = NSURL(string: "http://153.121.59.91/tance/index.php")
			let url = NSURL(string: "http://210.140.68.18/api/reply")
			let request = NSMutableURLRequest(URL: url!)
			
			request.HTTPMethod = "POST"
			request.HTTPBody = strData
			
			// PHP側でechoされた値を取得
			do{
				let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
				NSLog("requestしました")
				let myData:NSString = NSString(data:data, encoding: 1)!
				NSLog("api/reply: \(myData)")
			}catch let error{
				NSLog("\(error)")
				return
			}
			
			
		case .Inactive:
			/* インアクティブ時 処理 */
			NSLog("Inactive")
		}

		/*
		 *
		 * 誘う側が全て揃ったデータを取得し、TableViewを更新する処理
		 *
		 */
/*
        if inviter == myName{
			/* 誘う側の処理 */
			NSLog("I am SASOWER!")
            if status == 1{
                //参加できる人の処理
				let storybiard = UIStoryboard(name: "Main", bundle: nil)
				let viewcontroller2 = storybiard.instantiateViewControllerWithIdentifier("ViewController2") as! ViewController2
				//viewcontroller2.addFriends(invitee!, imageUrl: NSURL(string: imageUrl!)!, status: status!)
            }else{
                //参加できない人の処理
            }
        }else{
			/* 誘われる側の処理 */
			NSLog("I am SASOWEE!")
        }
*/
	}
	
	/* 位置情報取得成功時に実行される関数 */
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		latitude = locations[0].coordinate.latitude
		longitude = locations[0].coordinate.longitude
		NSLog("latitude: \(latitude) , longitude: \(longitude)")
		// LocationManagerを停止させる
		//lm.stopUpdatingLocation()
	}
	
	/* 位置情報取得失敗時に実行される関数 */
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
		NSLog("\(error)")
	}
}

