package game.map {
	import flash.geom.Point;
	
	public class Map {
		private const
		MIN_CAVE_LENGTH:int = 100,
		MAX_CAVE_LENGTH:int = 120;
		
		private var _cave:Vector.<Point>;
		private var _buildings:Vector.<Building>;
		private var _caveLength:int;

		public function Map() {
			_cave = new Vector.<Point>();
			_buildings = new Vector.<Building>();
			
			randomizeMap();
		}
		
		private function randomizeMap():void {
			var i:int;
			_caveLength = MIN_CAVE_LENGTH + int((MAX_CAVE_LENGTH-MIN_CAVE_LENGTH)*Math.random());
			_cave[0] = newCave(false, true, false, false);
			for(i = 1; i < _caveLength-1; i++){
				_cave[i] = newCave(true, true, false, false);
			}
			
			_cave[1] = newCave(true, true, true, false);
			_buildings.push(new Building(1, 4, 3));
			
			_cave[_caveLength-1] = newCave(true, false, false, false);
		}
		
		private function newCave(l:Boolean, r:Boolean, u:Boolean, d:Boolean):Point {
			return new Point((int(l)<<3) + (int(r)<<2) + (int(u)<<1) + int(d), 0);
		}
		
		public function get caveLength():int {
			return _caveLength;
		}
		
		public function caveAt(index:int):Point {
			return _cave[index];
		}
		
		public function get numBuildings():int {
			return _buildings.length;
		}
		
		public function buildingAt(index:int):Building {
			return _buildings[index];
		}
		
		public static function isLeftOpened(tar:int):Boolean {
			return Boolean((tar>>3)%2);
		}
		
		public static function isRightOpened(tar:int):Boolean {
			return Boolean((tar>>2)%2);
		}
		
		public static function isUpOpened(tar:int):Boolean {
			return Boolean((tar>>1)%2);
		}
		
		public static function isDownOpened(tar:int):Boolean {
			return Boolean(tar%2);
		}
		
		public static function buildingNum(gloc:String):int {
			var i:int, num:int = -1;
			for(i = 0; i < gloc.length; i++){
				if(gloc.charAt(i)==":"){
					num = int(gloc.substr(0, i-1));
					break;
				}
			}
			return num;
		}
		
		public static function buildingFloor(gloc:String):int {
			var i:int, start:int, floor:int = -1;
			for(i = 0; i < gloc.length; i++){
				if(gloc.charAt(i) == ":") start = i+1;
				else if(gloc.charAt(i) == "-"){
					floor = int(gloc.substr(start, i-1));
					break;
				}
			}
			return floor;
		}
		
		public static function buildingIndex(gloc:String):int {
			var i:int, index:int = -1;
			for(i = 0; i < gloc.length; i++){
				if(gloc.charAt(i) == "-"){
					index = int(gloc.substr(i+1, gloc.length-1));
					break;
				}
			}
			return index;
		}

	}
	
}
