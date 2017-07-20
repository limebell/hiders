package game.db {
	import flash.display.MovieClip;
	
	public class ItemData {

		internal var _itemCode:String, _itemName:String, _description:String, _itemClass:String, _durability:int, _weight:int, _clip:MovieClip;
		
		public function get itemCode():String {
			return _itemCode;
		}
		
		public function get itemName():String {
			return _itemName;
		}
		
		public function get description():String {
			return _description;
		}
		
		public function get itemClass():String {
			return _itemClass;
		}
		
		public function get durability():int {
			return _int;
		}
		
		public function get weight():int {
			return _weight;
		}
		
		public function get clip():MovieClip {
			return _clip;
		}

	}
	
}
