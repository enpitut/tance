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
	
	var timer: NSTimer!

	/* 位置情報取得のための変数 */
	var lm: CLLocationManager!
	var latitude: CLLocationDegrees!
	var longitude: CLLocationDegrees!
	var current: CLLocation!
	// 筑波大学中心地点
	let c_latitude = 36.1104929
	let c_longitude = 140.0994325
	var center: CLLocation!
	// 2点間の距離と閾値半径（m）
	var distance: Double = 0.0
	let radius: Double = 500.0
	// 自分の名前(各自自分の名前を設定する)
	let myName: String? = "Akihisa Kodera"
	
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
		print(userInfo)
		print(userInfo["inviter"]) // 誘った人の名前
		print(userInfo["invitee"]) // 誘われた人の名前
		print(userInfo["stauts"]) // 誘われた人が行けるかどうか
		switch(application.applicationState) {
		case .Active:
			NSLog("Active!")
		case .Background:
			NSLog("Background..")
			/* バックグラウンド処理 */
			
			if(userInfo["invitee"] == nil){
				// 私は「さそうぃー」です（誘われる人）
				userInfo["invitee"] = myName
				
				// 中心点からの距離でキャンパス内にいるかどうか判定
				current = CLLocation(latitude: latitude, longitude: longitude)
				center = CLLocation(latitude: c_latitude, longitude: c_longitude)
				distance = center.distanceFromLocation(current)
				//NSLog("\(distance)m")
				if(distance < 1000){ // 1km以内
					NSLog("キャンパス内にいます")
				}else{
					NSLog("キャンパス外です")
				}
				
			}else{
				// 私は「さそわー」です（誘う人）
			}
			
		case .Inactive:
			NSLog("Inactive")
		}
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
		NSLog("Error")
	}
}

