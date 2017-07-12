package game.map {
	import flash.geom.Point;
	
	public class Building {
		private var _building:Vector.<Vector.<Point>>;

		public function Building(width:int, height:int) {
			randomize(width, height);
		}
		
		private function randomize(width:int, height:int):void {
			var i:int, j:int;
			for(i = 0; i < width; i++){
				for(j = 0; j < height; j++){
					_building[i][j] = new Point(0,0);
				}
			}
		}

	}
	
}
