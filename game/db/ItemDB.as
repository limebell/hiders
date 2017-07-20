package game.db {
	import flash.display.MovieClip;
	
	public class ItemDB {
		private static var items:Vector.<ItemData>;
		
		{
			items = new Vector.<ItemData>();
			
			addItem(0x00, "RedPotion", "아직 흑백 게임이라 회색 포션처럼 보이지만 실제로는 빨간 포션입니다.", "Consumable", 1, 100, new redPotion());
			
		}
		
		private static function addItem(itemCode:int, itemName:String, description:String, itemClass:String, weight:int, durability:int, clip:MovieClip)
		{
			var data:ItemData = new ItemData();
			data._itemCode = itemCode;
			data._name = itemName;
			data._description = description;
			data._itemClass = itemClass;
			data._weight = weight;
			data._durability = durability;
			data._clip = clip;
			
			items.push(data);
		}		
		
		public static function getItem(itemCode:int):itemData {
			return items[itemCode];
		}
		
		public static function getNumItems():uint {
			return items.length;
		}
	}
	
}
