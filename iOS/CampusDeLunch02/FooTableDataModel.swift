import Foundation

class FooTableData {
	class FooTableDataModel : NSObject {
		var title: String
		var subTitle: String
		
		init(title: String, subTitle: String){
			self.title = title
			self.subTitle = subTitle
		}
	}
	let items = [
		FooTableDataModel(title: "title 1", subTitle: "subTitle 1"),
		FooTableDataModel(title: "title 2", subTitle: "subTitle 2"),
		FooTableDataModel(title: "title 3", subTitle: "subTitle 3"),
		FooTableDataModel(title: "title 4", subTitle: "subTitle 4")
	]
}