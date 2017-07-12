package game.map {
	import flash.display.MovieClip;
	
	public class World extends MovieClip {
		private const
		BLOCK_LENGTH:int = 800;
		
		private var _character:MovieClip;
		private var _caves:Vector.<MovieClip>;
		private var _backField:MovieClip;
		private var _mapObjects:MapObjects;
		private var _frontField:MovieClip;
		private var _moveButtons:MovieClip;
		private var _map:Map;

		public function World(character:MovieClip, map:Map) {
			_character = character;
			_caves = new Vector.<MovieClip>();
			_mapObjects = new MapObjects();
			_backField = new MovieClip();
			_frontField = new MovieClip();
			_moveButtons = new MovieClip();
			_map = map;
			
			initiate();
		}
		
		private function initiate():void {
			var i:int;
			//initiating backField
			for(i = 0; i < _map.caveLength; i++){
				switch(_map.caveAt(i).x){
					case 0:
						_caves[i] = new cave_0_0();
						_backField.addChild(_caves[i]);
						_caves[i].x = i*BLOCK_LENGTH;
						_caves[i].visible = false;
						break;
					case 1:
						break;
				}
			}
			//initiating character
			
			this.addChild(_backField);
			this.addChild(_mapObjects);
			this.addChild(_character);
			this.addChild(_frontField);
			this.addChild(_moveButtons);
		}

	}
	
}
