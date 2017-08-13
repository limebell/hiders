package game.item {
	import game.db.ItemDB;
	import flash.errors.IllegalOperationError;
	
	public class Inventory {
		private var _items:Vector.<ItemInfo>;
		private var _numItems:int;
		private var _numOfType:Array;

		public function Inventory() {
			_items = new Vector.<ItemInfo>();
			_numItems = 0;
			_numOfType = [0, 0, 0, 0];
		}
		
		public function itemAt(index:int):ItemInfo {
			return _items[index];
		}
		
		public function addItem(info:ItemInfo):void {
			_items.push(info);
			addRemoveOfType(info.itemClass, info.number);
			_numItems++;
		}
		
		public function addAmountAt(index:int, amount:int):void {
			_items[index].number = _items[index].number + amount;
			addRemoveOfType(_items[index].itemClass, amount);
		}
		
		public function removeAmountAt(index:int, amount:int):Boolean {
			if(_items[index].number <= amount){
				addRemoveOfType(_items[index].itemClass, -_items[index].number);
				_items.removeAt(index);
				_numItems--;
				return true;
			} else {
				addRemoveOfType(_items[index].itemClass, -amount);
				_items[index].number -= amount;
				return false;
			}
		}
		
		private function addRemoveOfType(tar:String, amount:int){
			switch(tar){
				case ItemDB.CONSUMABLE:
					_numOfType[0] += amount;
					break;
				case ItemDB.EQUIPMENT:
					_numOfType[1] += amount;
					break;
				case ItemDB.TOOL:
					_numOfType[2] += amount;
					break;
				case ItemDB.MATERIAL:
					_numOfType[3] += amount;
					break;
				default:
					throw new IllegalOperationError("addAmountAt : 잘못된 아이템 클래스입니다");
					break;
			}
		}
		
		public function numOfType(tar:String):int {
			var num:int = -1;
			switch(tar){
				case ItemDB.CONSUMABLE:
					num = _numOfType[0];
					break;
				case ItemDB.EQUIPMENT:
					num = _numOfType[1];
					break;
				case ItemDB.TOOL:
					num = _numOfType[2];
					break;
				case ItemDB.MATERIAL:
					num = _numOfType[3];
					break;
				default:
					throw new IllegalOperationError("numOfType : 잘못된 아이템 클래스입니다.");
					return -1;
					break;
			}
			return num;
		}
		
		
		public function get numItems():int {
			return _numItems;
		}
		

	}
	
}
