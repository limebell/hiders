package game.core {
	import flash.events.EventDispatcher;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import game.map.World;
	import game.event.MapEvent;
	import fl.transitions.TweenEvent;
	import game.map.Map;
	import game.ui.Shade;
	
	public class MapManager extends EventDispatcher {
		private const
		SPD_HOR:int = 10;
		
		private var _world:World;
		private var _globalLocation:String;
		private var _tween:Tween;
		//_globalLocation의 형식 : (동굴 위치 or 빌딩 번호:빌딩 층-빌딩 x축 인덱스  ex) 2:2-3, 34)

		public function MapManager(world:World) {
			_world = world;
			_globalLocation = "0";
			this.addEventListener(MapEvent.MOVE_LEFT, moveLeftHandler);
			this.addEventListener(MapEvent.MOVE_RIGHT, moveRightHandler);
			this.addEventListener(MapEvent.MOVE_UP, moveUpHandler);
			this.addEventListener(MapEvent.MOVE_DOWN, moveDownHandler);
			setButtonOf(_globalLocation);
			redrawFromTo();
		}
		
		private function moveLeftHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			_world.character.goLeft();
			
			if(!isBuilding(_globalLocation)){
				Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 2);
				moveTo(String(int(_globalLocation)-1), SPD_HOR);
			}
			else {
				Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 1);
				for(var i:int = 0; i < _globalLocation.length; i++) if(_globalLocation.charAt(i) == "-") break;
				moveTo(_globalLocation.substr(0, i+1)+(Map.buildingIndex(_globalLocation)-1), SPD_HOR);
			}
		}
		
		private function moveRightHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			_world.character.goRight();
			
			if(!isBuilding(_globalLocation)){
				Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 2);
				moveTo(String(int(_globalLocation)+1), SPD_HOR);
			}
			else{
				Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 1);
				for(var i:int = 0; i < _globalLocation.length; i++) if(_globalLocation.charAt(i) == "-") break;
				moveTo(_globalLocation.substr(0, i+1)+(Map.buildingIndex(_globalLocation)+1), SPD_HOR);
			}
		}
		
		private function moveUpHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			if(!isBuilding(_globalLocation)){
				_world.character.climb();
				Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 5);
				_tween = new Tween(_world.backField, "y", None.easeNone, _world.backField.y, _world.backField.y+World.CAVE_HEIGHT, 60);
				Shade.fadeOut(60);
				_tween.addEventListener(TweenEvent.MOTION_FINISH, enterBuilding);
			}
		}
		
		private function moveDownHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			if(!isBuilding(_globalLocation)){
				
			} else {
				if(Map.buildingIndex(_globalLocation) == _world.map.buildingAt(Map.buildingNum(_globalLocation)).connectedRoom){
					_world.character.climb();
					Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 5);
					_tween = new Tween(_world.backField, "y", None.easeNone, _world.backField.y, _world.backField.y-World.CAVE_HEIGHT, 60);
					Shade.fadeOut(60);
					_tween.addEventListener(TweenEvent.MOTION_FINISH, leaveBuilding);
				} else {
					
				}
				
				
			}
		}
		
		private function moveTo(gloc:String, spd:int, vertical:Boolean = false):void {
			//버튼 컨트롤
			_world.setButton();
			//장거리 이동도 가능하도록 수정하고 싶음, 뭔가 gloc이 바뀔때마다 이벤트가 발생해서 새로그리도록?
			if(_tween != null && _tween.isPlaying) _tween.stop();
			if(!isBuilding(_globalLocation)){
				_tween = new Tween(_world.backField, "x", None.easeNone, _world.backField.x, -int(gloc)*World.CAVE_WIDTH, Math.abs((int(gloc)*World.CAVE_WIDTH+_world.backField.x))/Number(spd));
			} else {
				if(vertical){
					_tween = new Tween(_world.backField, "y", None.easeNone, _world.backField.y, Map.buildingFloor(gloc)*World.ROOM_HEIGHT, Math.abs(Map.buildingIndex(gloc)*World.ROOM_WIDTH-_world.backField.x)/Number(spd));
				} else {
					_tween = new Tween(_world.backField, "x", None.easeNone, _world.backField.x, -Map.buildingIndex(gloc)*World.ROOM_WIDTH, Math.abs(Map.buildingIndex(gloc)*World.ROOM_WIDTH+_world.backField.x)/Number(spd));
				}
			}
			
			_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
			
			//임시
			setButtonOf(gloc);
			
			redrawFromTo(_globalLocation, gloc);
			_globalLocation = gloc;
		}
		
		private function teleportTo(gloc){
			if(!isBuilding(gloc)){
				_world.backField.x = -int(gloc)*World.CAVE_WIDTH;
				_world.backField.y = 0;
			} else {
				_world.backField.x = -Map.buildingIndex(gloc)*World.ROOM_WIDTH;
				_world.backField.y = Map.buildingFloor(gloc)*World.ROOM_HEIGHT;
			}
			
			setButtonOf(gloc);
			_globalLocation = gloc;
			redrawFromTo();
		}
		
		private function enterBuilding(e:TweenEvent):void {
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, enterBuilding);
			_world.character.standStill();
			Shade.fadeIn(60);
			var i:int;
			for(i = 0; i < _world.map.numBuildings; i++){
				if(_world.map.buildingAt(i).connectedCave == int(_globalLocation)){
					_globalLocation = i+":"+0+"-"+_world.map.buildingAt(i).connectedRoom;
					_world.renderField(_globalLocation);
					teleportTo(_globalLocation);
					break;
				}
			}
		}
		
		private function leaveBuilding(e:TweenEvent):void {
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, leaveBuilding);
			_world.character.standStill();
			Shade.fadeIn(60);
			_globalLocation = String(_world.map.buildingAt(Map.buildingNum(_globalLocation)).connectedCave);
			_world.renderField(_globalLocation);
			teleportTo(_globalLocation);
		}
		
		private function tweenFinishHandler(e:TweenEvent):void {
			_world.character.standStill();
			if(!isBuilding(_globalLocation)){
				_world.backField.x = -int(_globalLocation)*World.CAVE_WIDTH;
			} else {
				_world.backField.x = -Map.buildingIndex(_globalLocation)*World.ROOM_WIDTH;
				_world.backField.y = Map.buildingFloor(_globalLocation)*World.ROOM_HEIGHT;
			}
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
				
		}
		
		private function setButtonOf(gloc:String):void {
			var t:int;
			if(!isBuilding(gloc)){
				t = _world.map.caveAt(int(gloc)).x;
			} else {
				t = _world.map.buildingAt(Map.buildingNum(gloc)).roomAt(Map.buildingFloor(gloc), Map.buildingIndex(gloc)).x;
			}
			
			_world.setButton(Map.isLeftOpened(t), Map.isRightOpened(t), Map.isUpOpened(t), Map.isDownOpened(t));
		}
		
		private function redrawFromTo(from:String = "$", to:String = "$"):void {
			var _from:String = (from=="$"?_globalLocation:from), _to:String = (to=="$"?_globalLocation:to);
			var i:int, j:int;
			if(!isBuilding(_globalLocation)){
				for(i = 0; i < _world.map.caveLength; i++){
					if(isCaveInRange(i, _from, _to))
						_world.caves[i].visible = true;
					else
						_world.caves[i].visible = false;
				}
			} else {
				for(i = 0; i < _world.map.buildingAt(Map.buildingNum(_globalLocation)).buildingHeight; i++){
					for(j = 0; j < _world.map.buildingAt(Map.buildingNum(_globalLocation)).buildingWidth; j++){
						if(isRoomInRange(i, j, _from, to))
							_world.buildings[Map.buildingNum(_globalLocation)][i][j].visible = true;
						else
							_world.buildings[Map.buildingNum(_globalLocation)][i][j].visible = false;
					}
				}
				
				if(Map.buildingFloor(_from) > Map.buildingFloor(_to)) j = Map.buildingFloor(_to);
				else j = Map.buildingFloor(_from);
				if(j < 2){
					for(i = 0; i < _world.map.buildingAt(Map.buildingNum(_globalLocation)).buildingWidth+4; i++){
						if(isFloorInRange(i, Map.buildingIndex(_from), Map.buildingIndex(_to))) _world.buildingFloors[Map.buildingNum(_globalLocation)][i].visible = true;
						else _world.buildingFloors[Map.buildingNum(_globalLocation)][i].visible = false;
					}
				}
			}
			
			//맵오브젝트 그리는 부분
			//...
			/*for(i=0;i<맵오브젝트 개수;i++){
				i번째 오브젝트의 글로벌 위치가 저 프롬투 범위에 있으면? > visible = true;
				아니면 false
			}*/
			
		}
		
		private function isCaveInRange(i:int, from:String, to:String):Boolean {
			var _small:int, _large:int;
			if(int(from)>int(to)){
				_small = int(to);
				_large = int(from);
			} else {
				_small = int(from);
				_large = int(to);
			}
			return (i>_small-2&&i<_large+2);
		}
		
		private function isRoomInRange(i:int ,j:int, from:String, to:String):Boolean {
			var _smallX:int, _largeX:int, _smallY:int, _largeY:int;
			if(Map.buildingFloor(from)>Map.buildingFloor(to)){
				_smallX = Map.buildingFloor(to);
				_largeX = Map.buildingFloor(from);
			} else {
				_smallX = Map.buildingFloor(from);
				_largeX = Map.buildingFloor(to);
			}
			if(Map.buildingIndex(from)>Map.buildingIndex(to)){
				_smallY = Map.buildingIndex(to);
				_largeY = Map.buildingIndex(from);
			} else {
				_smallY = Map.buildingIndex(from);
				_largeY = Map.buildingIndex(to);
			}
			return (i>_smallX-2&&i<_largeX+2&&j>_smallY-2&&j<_largeY+2);
		}
		
		private function isFloorInRange(i:int, from:int, to:int):Boolean {
			var _small:int, _large:int;
			if(from>to){
				_small = to;
				_large = from;
			} else {
				_small = from;
				_large = to;
			}
			return (i>_small-1&&i<_large+5);
		}
		
		private function isBuilding(gloc:String):Boolean {
			var flag:Boolean = false;
			for(var i:int = 0; i < gloc.length; i++){
				if(gloc.charAt(i) == ":"){
					flag = true;
					break;
				}
			}
			return flag;
		}
		
		public function goto(gloc:String, spd:int):Boolean {
			if(!isBuilding(gloc)){
				if(_world.map.caveLength <= int(gloc)) return false;
				else {
					moveTo(gloc, spd);
					return true;
				}
			} else {
				return false;
			}
		}
		
		public function tpTo(gloc:String):Boolean {
			if(!isValid(gloc)) return false;
			
			_world.renderField(gloc);
			teleportTo(gloc);
			_globalLocation = gloc;
			return true;
		}
		
		private function isValid(gloc:String):Boolean {
			if(!isBuilding(gloc)){
				if(gloc != String(int(gloc))) return false;
				if(_world.map.caveLength <= int(gloc)) return false;
			}
			else if(isBuilding(gloc)) {
				var flag1:Boolean = false, flag2:Boolean = false;
				for(var i:int = 0; i < gloc.length; i++) {
					if(gloc.charAt(i) == ":") flag1 = true;
					if(gloc.charAt(i) == "-") flag2 = true;
				}
				if(!flag1 || !flag2) return false;
				if(gloc != Map.buildingNum(gloc)+":"+Map.buildingFloor(gloc)+"-"+Map.buildingIndex(gloc)) return false;
				if(_world.map.numBuildings <= Map.buildingNum(gloc)) return false;
				else if(_world.map.buildingAt(Map.buildingNum(gloc)).buildingHeight <= Map.buildingFloor(gloc)) return false;
				else if(_world.map.buildingAt(Map.buildingNum(gloc)).buildingWidth <= Map.buildingIndex(gloc)) return false;
			}
			return true;
		}
		
		public function get currentLocation():String {
			return _globalLocation;
		}
		
		public function get caveLength():int {
			return _world.map.caveLength;
		}
		
		/*
		//from MapObjects.as
		
		public function removeItemAt(index:int):void {
			_objects[index]._isExisting = false;
			if(_objects[index].clip != null) this.removeChild(_objects[index].clip);
			redraw(_currentGlobal);
		}
		
		public function redraw(globalLocation:String):void {
			for each(var clip:MovieClip in _currentlyVisibleClips)
				clip.visible = false;
			
			for each(var object:MapObjectInfo in _objects){
				if( object.isNear(_currentGlobal) ){
					if( object.clip != null ){
						object.clip.visible = true;
					}
				}
			}
		}*/

	}
	
}
