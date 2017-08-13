package game.db {
	import flash.display.MovieClip;
	
	public class MapObjectDB {
		
		private static var objects:Vector.<MapObjectData>;

		{
			objects = new Vector.<MapObjectData>();
			
			//아이템 배치
			addObject(0, null, true);
			//돌무더미
			addObject(1, "object_rock", true);
			
		}
		
		private static function addObject(objectCode:int, clip:String, interactionable:Boolean):void {
			var data:MapObjectData = new MapObjectData();
			data._objectCode = objectCode;
			data._clip = clip;
			data._interactionable = interactionable;
			
			objects.push(data);
		}
		
		public static function getObject(objectCode:int):MapObjectData {
			return objects[objectCode];
		}

	}
	
}
