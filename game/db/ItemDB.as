package game.db {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class ItemDB {
		public static const
		CONSUMABLE:String = "consumable",
		EQUIPABLE:String = "equipable",
		MATERIAL:String = "material";
		
		private static var items:Vector.<ItemData>;
		private static var craftRecipes:Vector.<CraftData>;
		
		{
			items = new Vector.<ItemData>();
			craftRecipes = new Vector.<CraftData>();
			
			addItem(0x00, "RedPotion", "아직 흑백 게임이라 회색 포션처럼 보이지만 실제로는 빨간 포션입니다.", CONSUMABLE, 1, 100, "item_RedPotion");
			addItem(0x01, "얍새의 롯리모자", "알바에 통달한 사람만이 착용할 수 있다고 알려진 전설적인 모자입니다. 매력적인 빨간색을 띄고 있습니다.", EQUIPABLE, 10, 100, "item_LotteriaHat");
			addItem(0x02, "넙죽이", "정체를 알 수 없는 넙죽한 물질입니다.", MATERIAL, 5, 100, "item_Nupjook");
			
			addCraftRecipe(0x01, new <Point>[new Point(0x00, 1), new Point(0x02,3)]);
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
		
		private static function addCraftRecipe(itemCode:int, recipe:Vector.<Point>)
		{
			var data:CraftData = new CraftData();
			data._itemCode = itemCode;
			data._recipe = recipe;
			
			craftRecipes.push(data);
		}		
		
		public static function getItem(itemCode:int):ItemData {
			return items[itemCode];
		}
		
		public static function getNumItems():uint {
			return items.length;
		}
		
		public static function getCraftRecipeAt(index:int):CraftData {
			return craftRecipes[index];
		}
		
		public static function getNumCraftRecipe():uint {
			return craftRecipes.length;
		}
	}
	
}
