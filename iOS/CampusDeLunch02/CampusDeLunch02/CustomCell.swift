//
//  CustomCell.swift
//  CampusDeLunch02
//
//  Created by Akihisa Kodera on 2015/08/23.
//  Copyright © 2015年 myname. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var iconCheck: UIImageView!
	
	// プロフィール画像用連想配列
	var thumbDic: Dictionary<String, String> = [
		"aki": "thumb_aki",
		"banri": "thumb_banri",
		"haya": "thumb_haya",
		"moriya": "thumb_moriya",
		"obata": "thumb_obata",
	]
	
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
	func setCell(friend :Friend) {
		// 名前をセット
		self.name.text = friend.name as String
		// 画像の読み込み(URLから)
		/*
		var imageData: NSData
		do{
			// ファイルダウンロード
			imageData = try NSData(contentsOfURL: friend.imageUrl!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
		} catch {
			NSLog("画像データ読み込み失敗")
			return
		}
		// 画像をセット
		self.iconImage.image = UIImage(data: imageData)
		*/
		
		// 画像の読み込み（デバイスから）
		self.iconImage.image = UIImage(named: thumbDic[friend.name as String]!)
		
		// アイコンをセット
		if friend.status == "1" {
			self.iconCheck.image = UIImage(named: "icon_tick")
		}else{
			self.iconCheck.image = UIImage(named: "icon_not")
		}
	}
}