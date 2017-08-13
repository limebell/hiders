package game.map {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.core.Character;
	import game.core.Game;
	import game.event.MapEvent;
	import flash.text.TextField;
	import game.db.MapObjectDB;
	import flash.geom.Point;
	
	public class World extends MovieClip {
		public static const
		CAVE_WIDTH:int = 1000,
		CAVE_HEIGHT:int = 400,
		ROOM_WIDTH:int = 500,
		ROOM_HEIGHT:int = 300,
		CAVE_CHARACTER_Y:int = 200,
		BUILDING_CHARACTER_Y:int = 130,
		SIDE_BUTTON_WIDTH:int = 100,
		SIDE_BUTTON_HEIGHT:int = 600,
		UPDOWN_BUTTON_WIDTH:int = 800,
		UPDOWN_BUTTON_HEIGHT:int = 100;
		
		private var _character:Character;
		private var _caves:Vector.<MovieClip>;
		private var _buildings:Array;
		private var _buildingFloors:Array;
		private var _backField:MovieClip;
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
			var i:int, j:int, k:int, t:int, tb:Building;
			
			_caves = new Vector.<MovieClip>();
			_frontField = new MovieClip();
			_moveButtons = new MovieClip();
			
			//initiating backField
			for(i = 0; i < _map.caveLength; i++){
				t = _map.caveAt(i).x;
				_caves[i] = new MovieClip();
				_caves[i].addChild(new cave_back_0);
				if(Map.isLeftOpened(t)){
					
				} else {
					_caves[i].addChild(new cave_leftB_0);
				}
				
				if(Map.isRightOpened(t)){
					
				} else {
					_caves[i].addChild(new cave_rightB_0);					
				}
				
				if(Map.isUpOpened(t)){
					_caves[i].addChild(new cave_upA_0);
				} else {
					_caves[i].addChild(new cave_upB_0);
				}
				
				if(Map.isDownOpened(t)){
					_caves[i].addChild(new cave_downA_0);
				} else {
					_caves[i].addChild(new cave_downB_0);
				}
				
				_caves[i].tf = new TextField();
				_caves[i].tf.text = i+"번째 동굴";
				_caves[i].tf.mouseEnabled = false;
				_caves[i].addChild(_caves[i].tf);
				
				_caves[i].x = i*CAVE_WIDTH;
			}
			
			_buildings = new Array();
			_buildingFloors = new Array();
			for(i = 0; i < _map.numBuildings; i++){
				_buildings[i] = new Array();
				tb = _map.buildingAt(i);
				for(j = 0; j < tb.buildingHeight; j++){
					_buildings[i][j] = new Vector.<MovieClip>();
					for(k = 0; k < tb.buildingWidth; k++){
						t = tb.roomAt(j, k).x;
						_buildings[i][j][k] = new MovieClip();
						_buildings[i][j][k].addChild(new room_back_0);
						if(Map.isLeftOpened(t)){
							
						} else {
							_buildings[i][j][k].addChild(new room_leftB_0);
						}
						
						if(Map.isRightOpened(t)){
							
						} else {
							_buildings[i][j][k].addChild(new room_rightB_0);					
						}
						
						if(Map.isUpOpened(t)){
							_buildings[i][j][k].addChild(new room_upA_0);
						} else {
							_buildings[i][j][k].addChild(new room_upB_0);
						}
						
						if(Map.isDownOpened(t)){
							if(j == 0 && tb.connectedRoom == k) _buildings[i][j][k].addChild(new room_downC_0);
							else _buildings[i][j][k].addChild(new room_downA_0);
						} else {
							_buildings[i][j][k].addChild(new room_downB_0);
						}
				
						_buildings[i][j][k].tf = new TextField();
						_buildings[i][j][k].tf.text = i+"번째 빌딩 "+j+"층 "+k+"칸";
						_buildings[i][j][k].tf.mouseEnabled = false;
						_buildings[i][j][k].addChild(_buildings[i][j][k].tf);
						
						_buildings[i][j][k].x = k*ROOM_WIDTH;
						_buildings[i][j][k].y = -j*ROOM_HEIGHT;
					}
				}
				_buildingFloors[i] = new Array();
				for(j = 0; j < tb.buildingWidth+4; j++){
					switch(tb.floorAt(j)){
						case 0:
							if(j-2 != tb.connectedRoom) _buildingFloors[i][j] = new building_floor_0();
							else _buildingFloors[i][j] = new building_floorToCave_0();
							break;
					}
					_buildingFloors[i][j].x = (j-2)*ROOM_WIDTH;
					_buildingFloors[i][j].y = ROOM_HEIGHT/2;
				}
			}
			
			//initiating character, mapObject, and rendering backField and mapObjects
			_backField = new MovieClip();
			_frontField = new MovieClip();
			_mapObjects = new Vector.<MapObjectInfo>();
			_mapObjects.push(new MapObjectInfo(MapObjectDB.getObject(1), "0", new Point(0, 200), true, true));
			for(i = 0; i < _mapObjects.length; i++){
				//바닥이 기준점
				if(Map.isBuilding(_mapObjects[i].globalLocation)){
					_mapObjects[i].clip.x = Map.buildingIndex(_mapObjects[i].globalLocation)*ROOM_WIDTH+_mapObjects[i].localLocation.x;
					_mapObjects[i].clip.y = Map.buildingFloor(_mapObjects[i].globalLocation)*ROOM_HEIGHT+_mapObjects[i].localLocation.y;
				} else {
					_mapObjects[i].clip.x = int(_mapObjects[i].globalLocation)*CAVE_WIDTH + _mapObjects[i].localLocation.x;
					_mapObjects[i].clip.y = _mapObjects[i].localLocation.y;
				}
			}
			renderField("0");
			
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
			this.addChild(_character);
			this.addChild(_frontField);
			this.addChild(_moveButtons);
			
			_moveButtons.leftbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.rightbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.upbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_moveButtons.downbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_moveButtons.leftbtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_moveButtons.rightbtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_moveButtons.upbtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_moveButtons.downbtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			_moveButtons.leftbtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_moveButtons.rightbtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_moveButtons.upbtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_moveButtons.downbtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			
			setButton();
		}
		
		public function renderField(gloc:String):void {
			//initiating character
			_character.standStill();
			if(buildingNum(gloc) == -1) _character.y = CAVE_CHARACTER_Y;
			else _character.y = BUILDING_CHARACTER_Y;
			
			for(i = backField.numChildren; i > 0; i--) backField.removeChildAt(0);
			for(i = frontField.numChildren; i > 0; i--) frontField.removeChildAt(0);
			
			//rendering backField
			var i:int, j:int, k:int, t:int, tb:Building;
			if(buildingNum(gloc) == -1){
				for(i = 0; i < _map.caveLength; i++){
					_backField.addChild(_caves[i]);
					_caves[i].visible = false;
				}
			} else {
				i = buildingNum(gloc);
				tb = _map.buildingAt(i);
				for(j = 0; j < tb.buildingHeight; j++){
					for(k = 0; k < tb.buildingWidth; k++){
						_backField.addChild(_buildings[i][j][k]);
						_buildings[i][j][k].visible = false;
					}
				}
				for(j = 0; j < tb.buildingWidth+4; j++){
					_backField.addChild(_buildingFloors[i][j]);
					_buildingFloors[i][j].visible = false;
				}
			}
			
			//rendering mapObjects
			for each(var object:MapObjectInfo in _mapObjects){
				if(object.clip == null) continue;

				if(buildingNum(object.globalLocation) == buildingNum(gloc)){
					if(object.isFront)
						_frontField.addChild(object.clip);
					else
						_backField.addChild(object.clip);
				}
				object.clip.visible = false;
			}
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
					Game.currentGame.mapManager.dispatchEvent(new MapEvent(MapEvent.MOVE_UP));
					break;
				case _moveButtons.downbtn:
					Game.currentGame.mapManager.dispatchEvent(new MapEvent(MapEvent.MOVE_DOWN));
					break;
			}
		}
		
		private function buildingNum(gloc:String):int {
			var num:int = -1;
			for(var i:int = 0; i < gloc.length; i++){
				if(gloc.charAt(i) == ":"){
					num = int(gloc.substr(0, i-1));
					break;
				}
			}
			return num;
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			Game.currentGame.setMouse("move");
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			Game.currentGame.setMouse("standard");
		}
		
		public function setButton(l:Boolean = false, r:Boolean = false, u:Boolean = false, d:Boolean = false):void {
			_moveButtons.leftbtn.mouseEnabled = l;
			_moveButtons.rightbtn.mouseEnabled = r;
			_moveButtons.upbtn.mouseEnabled = u;
			_moveButtons.downbtn.mouseEnabled = d;
		}

		public function get character():Character {
			return _character;
		}
		
		public function get caves():Vector.<MovieClip> {
			return _caves;
		}
		
		public function get buildings():Array {
			return _buildings;
		}
		
		public function get buildingFloors():Array {
			return _buildingFloors;
		}
		
		public function get backField():MovieClip {
			return _backField;
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
