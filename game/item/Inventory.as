package game.item {
	
	public class Inventory {
		private var _items:Vector.<ItemInfo>;

		public function Inventory() {
			_items = new Vector.<ItemInfo>();
		}
		
		public function itemAt(index:int):ItemInfo {
			return _items[index];
		}
		
		public function addItem(info:ItemInfo):void {
			_items.push(info);
		}
		
		public function addAmountAt(index:int, amount:int):void {
			_items[index].number = _items[index].number + amount;
		}
		
		public function get numItems():int {
			return _items.length;
		}
		
		public function get isOverloaded():Boolean {
			return false;
		}

	}
	
}
