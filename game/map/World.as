package game.map {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.core.Character;
	import game.core.Game;
	import game.event.MapEvent;
	
	public class World extends MovieClip {
		public static const
		BLOCK_LENGTH:int = 800,
		SIDE_BUTTON_WIDTH:int = 100,
		SIDE_BUTTON_HEIGHT:int = 600,
		UPDOWN_BUTTON_WIDTH:int = 800,
		UPDOWN_BUTTON_HEIGHT:int = 100;
		
		private var _character:Character;
		private var _caves:Vector.<MovieClip>;
		private var _backField:MovieClip;
		private var _objectsClip:MovieClip;
		private var _mapObjects:Vector.<MapObjectInfo>;
		private var _frontField:MovieClip;
		private var _moveButtons:MovieClip;
		private var _map:Map;

		public function World(character:Character, map:Map) {
			_character = character;
			_map = map;
			
			initiate();
		}
		
		private function initiate():void {
			var i:int;
			
			_caves = new Vector.<MovieClip>();
			_mapObjects = new Vector.<MapObjectInfo>();
			_backField = new MovieClip();
			_frontField = new MovieClip();
			_moveButtons = new MovieClip();
			
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
			//initiating mapObjects
			_objectsClip = new MovieClip();
			for each(var object:MapObjectInfo in _mapObjects){
				if(object.clip != null){
					_objectsClip.addChild(object.clip);
					object.clip.visible = false;
				}
			}
			//initiating character
			_character.standStill();
			_character.y = 400;
			//initiating moveButtnos
			_moveButtons.leftbtn = new button();
			_moveButtons.rightbtn = new button();
			_moveButtons.upbtn = new button();
			_moveButtons.downbtn = new button();
			_moveButtons.leftbtn.width = _moveButtons.rightbtn.width = SIDE_BUTTON_WIDTH;
			_moveButtons.leftbtn.height = _moveButtons.rightbtn.height = SIDE_BUTTON_HEIGHT;
			_moveButtons.upbtn.width = _moveButtons.downbtn.width = UPDOWN_BUTTON_WIDTH;
			_moveButtons.upbtn.height = _moveButtons.downbtn.height = UPDOWN_BUTTON_HEIGHT;
			_moveButtons.leftbtn.x = -640 + _moveButtons.leftbtn.width/2;	//640 : stageWidth/2, 360 : stageHeight/2
			_moveButtons.rightbtn.x = 640 - _moveButtons.leftbtn.width/2;
			_moveButtons.upbtn.y = -360 + _moveButtons.upbtn.height/2;
			_moveButtons.downbtn.y = 360 - _moveButtons.upbtn.height/2;
			_moveButtons.addChild(_moveButtons.leftbtn);
			_moveButtons.addChild(_moveButtons.rightbtn);
			_moveButtons.addChild(_moveButtons.upbtn);
			_moveButtons.addChild(_moveButtons.downbtn);
			
			this.addChild(_backField);
			this.addChild(_objectsClip);
			this.addChild(_character);
			this.addChild(_frontField);
			this.addChild(_moveButtons);
			
			_moveButtons.leftbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.rightbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.upbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.downbtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _moveButtons.leftbtn:
					Game.currentGame.mapManager.dispatchEvent(new MapEvent(MapEvent.MOVE_LEFT));
					break;
				case _moveButtons.rightbtn:
					Game.currentGame.mapManager.dispatchEvent(new MapEvent(MapEvent.MOVE_RIGHT));
					break;
				case _moveButtons.upbtn:
					trace("up");
					break;
				case _moveButtons.downbtn:
					trace("down");
					break;
			}
		}
		
		/*private var _character:Character;
		private var _caves:Vector.<MovieClip>;
		private var _backField:MovieClip;
		private var _mapObjects:MapObjects;
		private var _frontField:MovieClip;
		private var _moveButtons:MovieClip;
		private var _map:Map;*/

		public function get character():Character {
			return _character;
		}
		
		public function get caves():Vector.<MovieClip> {
			return _caves;
		}
		
		public function get backField():MovieClip {
			return _backField;
		}
		
		public function get objectsClip():MovieClip {
			return objectsClip;
		}
		
		public function get mapObjects():Vector.<MapObjectInfo> {
			return _mapObjects;
		}
		
		public function get frontField():MovieClip {
			return _frontField;
		}
		
		public function get map():Map {
			return _map;
		}

	}
	
}
