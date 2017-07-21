package game.map {
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class Building {
		private var _buildingWidth:int;
		private var _buildingHeight:int;
		private var _connectedCave:int;
		private var _connectedRoom:int;
		private var _building:Array;
		private var _buildingFloors:Vector.<int>;

		public function Building(cave:int, width:int, height:int) {
			_buildingWidth = width;
			_buildingHeight = height;
			_connectedCave = cave;
			_connectedRoom = 3;
			
			randomize();
		}
		
		private function randomize():void {
			var i:int, j:int;
			_building = new Array();
			for(i = 0; i < _buildingHeight; i++){
				_building[i] = new Array()
				for(j = 0; j < _buildingWidth; j++){
					_building[i][j] = newRoom(true, true, false, false);
				}
				_building[i][0] = newRoom(false, true, false, false);
				_building[i][1] = newRoom(true, true, true, true);
				_building[i][j-1] = newRoom(true, false, false, false);
			}
			_building[0][_connectedRoom] = roomToCave(_building[0][_connectedRoom]);
			_building[0][1] = newRoom(true, true, true, false);
			_building[_buildingHeight-1][1] = newRoom(true, true, false, true);
			
			_buildingFloors = new Vector.<int>();
			for(i = 0; i < _buildingWidth+4; i++){
				_buildingFloors[i] = 0;
			}
		}
		
		private function newRoom(l:Boolean, r:Boolean, u:Boolean, d:Boolean):Point {
			return new Point((int(l)<<3) + (int(r)<<2) + (int(u)<<1) + int(d), 0);
		}
		
		private function roomToCave(t:Point):Point {
			var ret:Point = new Point();
			ret.x = ((t.x>>1)<<1)+1;
			ret.y = t.y;
			return ret;
		}
		
		public function get connectedCave():int {
			return _connectedCave;
		}
		
		public function get connectedRoom():int {
			return _connectedRoom;
		}
		
		public function get buildingWidth():int {
			return _buildingWidth;
		}
		
		public function get buildingHeight():int {
			return _buildingHeight;
		}
		
		public function roomAt(height:int, index:int):Point {
			return _building[height][index];
		}
		
		public function floorAt(index:int):int {
			return _buildingFloors[index];
		}

	}
	
}
