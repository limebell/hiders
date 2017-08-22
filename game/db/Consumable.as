package game.db {
	
	public class Consumable extends ItemData {
		
		internal var _hp:int, _st:int;
		
		public function get hp():int {
			return _hp;
		}
		
		public function get st():int {
			return _st;
		}

	}
	
}
