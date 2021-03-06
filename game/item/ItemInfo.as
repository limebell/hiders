﻿package game.item {
	import game.db.ItemData;
	import game.db.*;
	
	import flash.display.MovieClip;
	
	public class ItemInfo {
		private var _data:ItemData, _number:int, _durability:int;
		
		public function ItemInfo(data:ItemData, number:int) {
			_data = data;
			_number = number;
		}
		
		public function get data():ItemData {
			return _data;
		}
		
		public function get itemCode():int {
			return _data.itemCode;
		}
		
		public function get itemName():String {
			return _data.itemName;
		}
		
		public function get description():String {
			return _data.description;
		}
		
		public function get itemClass():uint {
			return _data.itemClass;
		}
		
		public function get weight():int {
			return _data.weight;
		}
		
		public function get clip():MovieClip {
			return _data.clip;
		}
		
		public function get number():int {
			return _number;
		}
		
		public function get maxDurability():int {
			return Tool(_data).durability;
		}
		
		public function get curDurability():int {
			return _durability;
		}
		
		public function set number(num:int):void {
			_number = num;
		}
		
		public function set curDurability(num:int):void {
			_durability = num;
		}

	}
	
}
