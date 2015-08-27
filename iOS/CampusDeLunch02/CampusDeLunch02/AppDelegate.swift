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

	/* 位置情報取得のための変数 */
	var lm: CLLocationManager!
	var latitude: CLLocationDegrees!
	var longitude: CLLocationDegrees!
	
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
		
	}

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		print(application.applicationState)
		switch(application.applicationState) {
		case .Active:
			NSLog("Active!")
		case .Background:
			NSLog("Background..")
			
			/* 位置情報を取得 */
			/*
			
			lm.delegate = self
			lm.requestAlwaysAuthorization()
			
			lm.desiredAccuracy = kCLLocationAccuracyBest
			lm.distanceFilter = 1000
			
			lm.pausesLocationUpdatesAutomatically = false
			lm.startUpdatingLocation()
			*/
			
		case .Inactive:
			NSLog("Inactive")
		}
	}
	
	/* 位置情報取得成功時に実行される関数 */
	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
		latitude = newLocation.coordinate.latitude
		longitude = newLocation.coordinate.longitude
		NSLog("latitude: \(latitude) , longitude: \(longitude)")
		//lm.stopUpdatingLocation()
		
		// 中心点からの距離でキャンパス内にいるかどうか判定
		let c_latitude = 36.1104929
		let c_longitude = 140.0994325
		let current: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
		let center: CLLocation = CLLocation(latitude: c_latitude, longitude: c_longitude)
		let distance = center.distanceFromLocation(current)
		NSLog("\(distance)m")
		if(distance < 1000){ // 1km以内
			NSLog("キャンパス内にいます")
		}else{
			NSLog("キャンパス外です")
		}
	}
	
	/* 位置情報取得失敗時に実行される関数 */
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
		NSLog("Error")
	}
}

