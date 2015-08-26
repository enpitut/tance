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
		
		// アイコンをセット
		/*
		if friend.checked {
			self.iconCheck.image = UIImage(named: "icon_tick")
		}else{
			self.iconCheck.image = UIImage(named: "icon_not")
		}
*/
	}
}