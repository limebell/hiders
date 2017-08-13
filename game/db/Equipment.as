package game.db {
	import game.db.ItemData;
	
	public class Equipment extends ItemData {
		
		internal var _atk:int, _def:int, _hp:int, _st:int, _part:String, _weaponType:String;

		public function get atk():int {
			return _atk;
		}

		public function get def():int {
			return _def;
		}

		public function get hp():int {
			return _hp;
		}

		public function get st():int {
			return _st;
		}

		public function get part():String {
			return _part;
		}

		public function get weaponType():String {
			return _weaponType;
		}

	}
	
}
