package game.item {
	
	public class Inventory {
		private var _items:Vector.<ItemInfo>;
		private var _numItems:int;

		public function Inventory() {
			_items = new Vector.<ItemInfo>();
			_numItems = 0;
		}
		
		public function itemAt(index:int):ItemInfo {
			return _items[index];
		}
		
		public function addItem(info:ItemInfo):void {
			_items.push(info);
			_numItems++;
		}
		
		public function addAmountAt(index:int, amount:int):void {
			_items[index].number = _items[index].number + amount;
		}
		
		public function removeAmountAt(index:int, amount:int):Boolean {
			if(_items[index].number <= amount){
				_items.removeAt(index);
				_numItems--;
				return true;
			} else {
				_items[index].number -= amount;
				return false;
			}
		}
		
		public function get numItems():int {
			return _numItems;
		}
		
		public function get isOverloaded():Boolean {
			return false;
		}

	}
	
}
