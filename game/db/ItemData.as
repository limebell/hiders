package game.db {
	import flash.display.MovieClip;
	
	public class ItemData {
		
		internal var _itemCode:int, _itemName:String, _description:String, _weight:int, _durability:int, _itemType:String, _clip:MovieClip;
		
		public function get itemCode():int{
			return _itemCode;
		}
		
		public function get itemName():String{
			return _itemName;
		}
		
		public function get description():String{
			return _description();
		}
		
		public function get weight():int{
			return _weight;
		}
		
		public function get durability():int{
			return _durability;
		}
		
		public function get itemType():String{
			return _itemType;
		}
		
		public function get clip():MovieClip{
			return _clip;
		}
	}
	
}
