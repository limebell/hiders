package game.db {
	import flash.display.MovieClip;
	
	public class ItemDB {
		public static const
		CONSUMABLE:String = "consumable",
		EQUIPABLE:String = "equipable",
		MATERIAL:String = "material";
		
		private static var items:Vector.<ItemData>;
		
		{
			items = new Vector.<ItemData>();
			
			addItem(0x00, "RedPotion", "아직 흑백 게임이라 회색 포션처럼 보이지만 실제로는 빨간 포션입니다.", CONSUMABLE, 1, 100, "item_RedPotion");
			addItem(0x01, "얍새의 롯리모자", "알바의 사람만이 착용할 수 있다고 알려진 전설적인 모자입니다. 매력적인 빨간색을 띄고 있습니다.", EQUIPABLE, 10, 100, "item_LotteriaHat");
			
		}
		
		private static function addItem(itemCode:int, itemName:String, description:String, itemClass:String, weight:int, durability:int, clip:String)
		{
			var data:ItemData = new ItemData();
			data._itemCode = itemCode;
			data._itemName = itemName;
			data._description = description;
			data._itemClass = itemClass;
			data._weight = weight;
			data._durability = durability;
			data._clip = clip;
			
			items.push(data);
		}		
		
		public static function getItem(itemCode:int):ItemData {
			return items[itemCode];
		}
		
		public static function getNumItems():uint {
			return items.length;
		}
	}
	
}
