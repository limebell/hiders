package game.db {
	import flash.geom.Point;
	
	public class CraftData {
		
		internal var _itemCode:int, _recipe:Vector.<Point>;

		public function get itemCode():int {
			return _itemCode;
		}
		
		public function get recipe():Vector.<Point> {
			return _recipe;
		}
	}
	
}
