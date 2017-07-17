package game.db {
	import flash.display.MovieClip;
	
	public class ItemDB {

		private static var items:Vector.<ItemData>;
		
		// 이 중괄호의 의미는? Initializing?
		{
			items = new Vector.<ItemData>();
			
			addItem(0x01, "Red Potion", "아직 흑백 게임이라 회색 포션처럼 보이지만 사실 빨간 포션입니다.", 1, 100, "Consumable", 
			new redPotion());
		}

		private static function addItem(itemCode:int, itemName:String, description:String, weight:int, durability:int, itemType:String, clip:MovieClip):void{
			var data:ItemData = new ItemData();
			data._itemCode = itemCode;
			data._itemName = itemName;
			data._description = description;
			data._weight = weight;
			data._durability = durability;
			data._itemType = itemType;
			data._clip = clip;
			
			items.push(data);
		}
		
		public static function getItem(itemCode:int):ItemData{
			return items[itemCode];
		}
		
		public static function getItemNum():uint{
			return items.length;
		}
	}
	
}
