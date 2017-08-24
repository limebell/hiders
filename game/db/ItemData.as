package game.db {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class ItemData {

		internal var _itemCode:int, _itemName:String, _description:String, _itemClass:uint, _weight:uint, _clip:String;
		
		public function get itemCode():int {
			return _itemCode;
		}
		
		public function get itemName():String {
			return _itemName;
		}
		
		public function get description():String {
			return _description;
		}
		
		public function get itemClass():uint {
			return _itemClass;
		}
		
		public function get weight():uint {
			return _weight;
		}
		
		public function get clip():MovieClip {
			return new (Class(getDefinitionByName(_clip)))();
		}
		
		public function get clipName():String {
			return _clip;
		}

	}
	
}
