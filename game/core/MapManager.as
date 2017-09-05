package game.core {
	import game.map.World;
	import game.event.MapEvent;
	import game.map.Map;
	import game.ui.Shade;
	
	import flash.events.EventDispatcher;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class MapManager extends EventDispatcher {
		private const
		SPD_HOR:int = 5;
		
		private var _world:World;
		private var _globalLocation:String;
		private var _tween:Tween;
		private var _isMoving:Boolean;
		//_globalLocation의 형식 : (동굴 위치 or 빌딩 번호:빌딩 층-빌딩 x축 인덱스  ex) 2:2-3, 34)

		public function MapManager(world:World) {
			_world = world;
			_globalLocation = "0";
			_isMoving = false;
			this.addEventListener(MapEvent.MOVE_LEFT, moveLeftHandler);
			this.addEventListener(MapEvent.MOVE_RIGHT, moveRightHandler);
			this.addEventListener(MapEvent.MOVE_UP, moveUpHandler);
			this.addEventListener(MapEvent.MOVE_DOWN, moveDownHandler);
			setButtonOf(_globalLocation);
			redrawFromTo();
		}
		
		private function moveLeftHandler(e:MapEvent):void {
			if(_isMoving) return;
			if(Game.currentGame.noAction) return;
			_world.character.goLeft();
			
			if(!Map.isBuilding(_globalLocation)){
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_CAVE_HORIZONTAL)){
					moveTo(String(int(_globalLocation)-1), SPD_HOR);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			}
			else {
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_BUILDING_HORIZONTAL)){
					for(var i:int = 0; i < _globalLocation.length; i++) if(_globalLocation.charAt(i) == "-") break;
					moveTo(_globalLocation.substr(0, i+1)+(Map.buildingIndex(_globalLocation)-1), SPD_HOR);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			}
		}
		
		private function moveRightHandler(e:MapEvent):void {
			if(_isMoving) return;
			if(Game.currentGame.noAction) return;
			_world.character.goRight();
			
			if(!Map.isBuilding(_globalLocation)){
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_CAVE_HORIZONTAL)){
					moveTo(String(int(_globalLocation)+1), SPD_HOR);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			}
			else{
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_BUILDING_HORIZONTAL)){
					moveTo((Map.buildingNum(_globalLocation))+":"+(Map.buildingFloor(_globalLocation))+"-"+(Map.buildingIndex(_globalLocation)+1), SPD_HOR);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			}
		}
		
		private function moveUpHandler(e:MapEvent):void {
			if(_isMoving) return;
			if(Game.currentGame.noAction) return;
			if(!Map.isBuilding(_globalLocation)){
				_world.character.climb();
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_ENTERLEAVE)){
					_world.initInterection();
					moveFields(_world.backField.x, _world.backField.y + World.CAVE_HEIGHT, 60);
					Shade.fadeOut(60);
					_tween.addEventListener(TweenEvent.MOTION_FINISH, enterBuilding);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			} else {
				_world.character.goRight();
				if(Game.currentGame.statusManager.move(StatusManager.MOVE_BUILDING_VERTICAL)){
					moveTo((Map.buildingNum(_globalLocation))+":"+(Map.buildingFloor(_globalLocation)+1)+"-"+(Map.buildingIndex(_globalLocation)), SPD_HOR, true);
				} else {
					trace("너무 무거워서 움직일 수 없음");
					return;
				}
			}
		}
		
		private function moveDownHandler(e:MapEvent):void {
			if(_isMoving) return;
			if(Game.currentGame.noAction) return;
			if(!Map.isBuilding(_globalLocation)){
				
			} else {
				if(Map.buildingFloor(_globalLocation) == 0 && Map.buildingIndex(_globalLocation) == _world.map.buildingAt(Map.buildingNum(_globalLocation)).connectedRoom){
					_world.character.climb();
					if(Game.currentGame.statusManager.move(StatusManager.MOVE_ENTERLEAVE)){
						_world.initInterection();
						moveFields(_world.backField.x, _world.backField.y - World.CAVE_HEIGHT, 60);
						Shade.fadeOut(60);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, leaveBuilding);
					} else {
						trace("너무 무거워서 움직일 수 없음");
						return;
					}
				} else {
					_world.character.goLeft();
					if(Game.currentGame.statusManager.move(StatusManager.MOVE_BUILDING_VERTICAL)){
						moveTo((Map.buildingNum(_globalLocation))+":"+(Map.buildingFloor(_globalLocation)-1)+"-"+(Map.buildingIndex(_globalLocation)), SPD_HOR, true);
					} else {
						trace("너무 무거워서 움직일 수 없음");
						return;
					}
				}
				
				
			}
		}
		
		private function moveTo(gloc:String, spd:int, vertical:Boolean = false):void {
			//버튼 컨트롤
			_world.setButton();
			//장거리 이동도 가능하도록 수정하고 싶음, 뭔가 gloc이 바뀔때마다 이벤트가 발생해서 새로그리도록?
			if(_tween != null && _tween.isPlaying) _tween.stop();
			_isMoving = true;
			//인터렉션 필드 초기화
			_world.initInterection();
			
			if(!Map.isBuilding(_globalLocation)){
				//동굴 내에서 좌우로 움직이는 트윈
				moveFields(-int(gloc)*World.CAVE_WIDTH, 0, Math.abs((int(gloc)*World.CAVE_WIDTH+_world.backField.x))/Number(spd));
				_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
			} else {
				if(vertical){
					if(Map.buildingFloor(gloc)>Map.buildingFloor(_globalLocation)){
						_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x+75, 75/spd);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, _goUp);
						function _goUp(e:TweenEvent):void {
							//빌딩 내에서 위로 올라가는 트윈
							_world.character.goLeft();
							_tween.removeEventListener(TweenEvent.MOTION_FINISH, _goUp);
							moveFields(_world.backField.x, _world.backField.y+World.ROOM_HEIGHT, 225/spd);
							_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x-150, 225/spd);
							_tween.addEventListener(TweenEvent.MOTION_FINISH, _goRight);
						}
						function _goRight(e:TweenEvent):void {
							_world.character.goRight();
							_tween.removeEventListener(TweenEvent.MOTION_FINISH, _goRight);
							_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x+75, 75/spd);
							_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
						}
					} else {
						//빌딩 내에서 아래로 내려오는 트윈
						_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x-75, 75/spd);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, _goDown);
						function _goDown(e:TweenEvent):void {
							_world.character.goRight();
							_tween.removeEventListener(TweenEvent.MOTION_FINISH, _goDown);
							moveFields(_world.backField.x, _world.backField.y-World.ROOM_HEIGHT, 225/spd);
							_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x+150, 225/spd);
							_tween.addEventListener(TweenEvent.MOTION_FINISH, _goLeft);
						}
						function _goLeft(e:TweenEvent):void {
							_world.character.goRight();
							_tween.removeEventListener(TweenEvent.MOTION_FINISH, _goLeft);
							_tween = new Tween(_world.character, "x", None.easeNone, _world.character.x, _world.character.x-75, 75/spd);
							_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
						}
					}
				} else {
					//빌딩 내에서 좌우로 움직이는 트윈
					moveFields(-Map.buildingIndex(gloc)*World.ROOM_WIDTH, _world.backField.y, Math.abs(Map.buildingIndex(gloc)*World.ROOM_WIDTH+_world.backField.x)/Number(spd));
					_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
				}
			}
			
			
			//임시
			setButtonOf(gloc);
			
			redrawFromTo(_globalLocation, gloc);
			_globalLocation = gloc;
		}
		
		private function moveFields(desX:Number, desY:Number, time:Number):void {
			_tween = new Tween(_world.backField, "x", None.easeNone, _world.backField.x, desX, time);
			new Tween(_world.frontField, "x", None.easeNone, _world.frontField.x, desX, time);
			new Tween(_world.backField, "y", None.easeNone, _world.backField.y, desY, time);
			new Tween(_world.frontField, "y", None.easeNone, _world.frontField.y, desY, time);
		}

		
		private function teleportTo(gloc){
			if(!Map.isBuilding(gloc)){
				_world.backField.x = _world.frontField.x = -int(gloc)*World.CAVE_WIDTH;
				_world.backField.y = _world.frontField.y = 0;
			} else {
				_world.backField.x = _world.frontField.x = -Map.buildingIndex(gloc)*World.ROOM_WIDTH;
				_world.backField.y = _world.frontField.y = Map.buildingFloor(gloc)*World.ROOM_HEIGHT;
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
			_world.setInterection(_globalLocation);
			if(!Map.isBuilding(_globalLocation)){
				_world.backField.x = _world.frontField.x = -int(_globalLocation)*World.CAVE_WIDTH;
			} else {
				_world.backField.x = _world.frontField.x = -Map.buildingIndex(_globalLocation)*World.ROOM_WIDTH;
				_world.backField.y = _world.frontField.y = Map.buildingFloor(_globalLocation)*World.ROOM_HEIGHT;
			}
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
			_isMoving = false;
		}
		
		private function setButtonOf(gloc:String):void {
			var t:int;
			if(!Map.isBuilding(gloc)){
				t = _world.map.caveAt(int(gloc)).x;
			} else {
				t = _world.map.buildingAt(Map.buildingNum(gloc)).roomAt(Map.buildingFloor(gloc), Map.buildingIndex(gloc)).x;
			}
			
			_world.setButton(Map.isLeftOpened(t), Map.isRightOpened(t), Map.isUpOpened(t), Map.isDownOpened(t));
		}
		
		public function redraw():void {
			redrawFromTo();
			_world.initInterection();
			_world.setInterection(_globalLocation);
		}
		
		private function redrawFromTo(from:String = "$", to:String = "$"):void {
			var _from:String = (from=="$"?_globalLocation:from), _to:String = (to=="$"?_globalLocation:to);
			var i:int, j:int;
			if(!Map.isBuilding(_globalLocation)){
				//동굴그리기
				for(i = 0; i < _world.map.caveLength; i++){
					if(isCaveInRange(i, _from, _to))
						_world.caves[i].visible = true;
					else
						_world.caves[i].visible = false;
				}
				//오브젝트 그리기
				for(i = 0; i < _world.mapObjects.length; i++){
					if(isCaveInRange(int(_world.mapObjects[i].globalLocation), _from, _to)){
						if(_world.mapObjects[i].clip != null){
							if(_world.mapObjects[i].isExisting) _world.mapObjects[i].clip.visible = true;
							else _world.mapObjects[i].clip.visible = false;
						}
					} else {
						if(_world.mapObjects[i].clip != null) _world.mapObjects[i].clip.visible = false;
					}
				}
				
			} else {
				//방 그리기
				for(i = 0; i < _world.map.buildingAt(Map.buildingNum(_globalLocation)).buildingHeight; i++){
					for(j = 0; j < _world.map.buildingAt(Map.buildingNum(_globalLocation)).buildingWidth; j++){
						if(isRoomInRange(i, j, _from, to))
							_world.buildings[Map.buildingNum(_globalLocation)][i][j].visible = true;
						else
							_world.buildings[Map.buildingNum(_globalLocation)][i][j].visible = false;
					}
				}
				//오브젝트 그리기
				for(i = 0; i < _world.mapObjects.length; i++){
					if(isRoomInRange(Map.buildingFloor(_world.mapObjects[i].globalLocation), Map.buildingIndex(_world.mapObjects[i].globalLocation), _from, _to))
						if(_world.mapObjects[i].clip != null){
							if(_world.mapObjects[i].isExisting) _world.mapObjects[i].clip.visible = true;
							else _world.mapObjects[i].clip.visible = false;
						}
					else
						if(_world.mapObjects[i].clip != null) _world.mapObjects[i].clip.visible = false;
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
		
		public function goto(gloc:String, spd:int):Boolean {
			if(!Map.isBuilding(gloc)){
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
			if(!Map.isValid(gloc)) return false;
			else if(!Map.isBuilding(gloc)){
				if(gloc != String(int(gloc))) return false;
				if(_world.map.caveLength <= int(gloc)) return false;
			} else if(Map.isBuilding(gloc)) {
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
	}
	
}
