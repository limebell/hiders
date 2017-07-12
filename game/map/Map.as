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
			for(i = 0; i < _caveLength; i++){
				_cave[i] = new Point(0,0);
			}
		}
		
		public function get caveLength():int {
			return _caveLength;
		}
		
		public function caveAt(index:int):Point {
			return _cave[index];
		}

	}
	
}
