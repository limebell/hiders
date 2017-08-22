package game.db {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.db.Equipment;
	
	public class ItemDB {
		public static const
		CONSUMABLE:uint = 0,
		TOOL:uint = 1,
		EQUIPMENT:uint = 2,
		MATERIAL:uint = 3,
		
		HEAD:String = "head",
		ARM:String = "arm",
		BODY:String = "body",
		SHOES:String = "shoes",
		WEAPON:String = "weapon",
		
		DAGGER:String = "dagger",
		SWORD:String = "sword",
		BAT:String = "bat",
		SPEAR:String = "spear";
		
		
		private static var items:Vector.<ItemData>;
		private static var craftRecipes:Vector.<CraftData>;
		private static var decomposeRecipes:Vector.<DecomposeData>;
		private static var numItems:int;
		
		{
			items = new Vector.<ItemData>();
			craftRecipes = new Vector.<CraftData>();
			decomposeRecipes = new Vector.<DecomposeData>();
			
			numItems = 0;
			//Consumables : itemName, description, weight, hp, st, clip
			addConsumeItem("RedPotion", "아직 흑백 게임이라 회색 포션처럼 보이지만 실제로는 빨간 포션입니다.", 2, 10, 0, "item_redpotion");
			//Tools : itemName, description, weight, durability, clip
			addToolItem("곡괭이", "머리부분이 심하게 녹슨 낡은 곡괭이 입니다. 돌을 부술 수 있습니다", 15, 10, "item_pickax");
			//Equipments : itemName, description, weight, atk, def, hp, st, part, weaponType, clip
			addEquipItem("얍새의 롯리모자", "알바에 통달한 사람만이 착용할 수 있다고 알려진 전설적인 모자입니다. 매력적인 빨간색을 띄고 있습니다.",
							5, 0, 4, 0, 0, HEAD, null, "item_lotteriahat");
			addEquipItem("나무 막대", "짧은 나무 막대입니다. 무기로 사용할 수 있습니다.",
							3, 3, 0, 0, 0, WEAPON, DAGGER, "item_woodstick");
			addEquipItem("긴 나무 막대", "긴 나무 막대입니다. 무기로 사용할 수 있습니다.",
							6, 8, 0, 0, 0, WEAPON, BAT, "item_woodlongstick");
			//Materials : itemName, description, weight, clip
			addMaterialItem("넙죽이", "정체를 알 수 없는 넙죽한 물질입니다. 보기보다 꽤 묵직합니다.", 5, "item_nupjook");
			addMaterialItem("종이테이프", "거의 다 사용해 얼마 남지 않은 종이테이프입니다.", 1, "item_tape");
			
			//Craft Recipes
			addCraftRecipe(0x01, new <Point>[new Point(0x03, 1), new Point(0x05, 2)]);
			addCraftRecipe(0x04, new <Point>[new Point(0x03, 2), new Point(0x06, 1)]);
			
			//Decomposition Recipes
			addDecomposeRecipe(0x02, new <Point>[new Point(0x00, 1), new Point(0x01, 1)]);
			addDecomposeRecipe(0x04, new <Point>[new Point(0x03, 1)]);
		}
		
		private static function addConsumeItem(itemName:String, description:String, weight:uint, hp:int, st:int, clip:String)
		{
			var data:Consumable = new Consumable();
			data._itemCode = numItems;
			data._itemName = itemName;
			data._description = description;
			data._itemClass = CONSUMABLE;
			data._weight = weight;
			data._hp = hp;
			data._st = st;
			data._clip = clip;
			
			items.push(data);
			numItems++;
		}
		
		private static function addToolItem(itemName:String, description:String, weight:uint, durability:uint, clip:String)
		{
			var data:Tool = new Tool();
			data._itemCode = numItems;
			data._itemName = itemName;
			data._description = description;
			data._itemClass = TOOL;
			data._weight = weight;
			data._durability = durability;
			data._clip = clip;
			
			items.push(data);
			numItems++;
		}
		
		private static function addEquipItem(itemName:String, description:String, weight:uint, atk:int, def:int, hp:int, st:int, part:String, weaponType:String, clip:String)
		{
			var data:Equipment = new Equipment();
			data._itemCode = numItems;
			data._itemName = itemName;
			data._description = description;
			data._itemClass = EQUIPMENT;
			data._weight = weight;
			data._atk = atk;
			data._def = def;
			data._hp = hp;
			data._st = st;
			data._part = part;
			if(data._part == WEAPON) data._weaponType = weaponType;
			data._clip = clip;
			
			items.push(data);
			numItems++;
		}
		
		private static function addMaterialItem(itemName:String, description:String, weight:uint, clip:String)
		{
			var data:ItemData = new ItemData();
			data._itemCode = numItems;
			data._itemName = itemName;
			data._description = description;
			data._itemClass = MATERIAL;
			data._weight = weight;
			data._clip = clip;
			
			items.push(data);
			numItems++;
		}
		
		private static function addCraftRecipe(itemCode:int, recipe:Vector.<Point>)
		{
			var data:CraftData = new CraftData();
			data._itemCode = itemCode;
			data._recipe = recipe;
			
			craftRecipes.push(data);
		}		
		
		private static function addDecomposeRecipe(itemCode:int, recipe:Vector.<Point>)
		{
			var data:DecomposeData = new DecomposeData();
			data._itemCode = itemCode;
			data._recipe = recipe;
			
			decomposeRecipes.push(data);
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
		
		public static function getDecomposeRecipeAt(index:int):DecomposeData {
			return decomposeRecipes[index];
		}
		
		public static function getNumDecomposeRecipe():uint {
			return decomposeRecipes.length;
		}
	}
	
}
