package game.core {
	import flash.events.EventDispatcher;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import game.map.World;
	import game.event.MapEvent;
	
	public class MapManager extends EventDispatcher {
		private var _world:World;
		private var _globalLocation:String;
		private var _tween:Tween;
		//_globalLocation의 형식 : (동굴 위치 or 빌딩 번호:빌딩 층-빌딩 x축 인덱스  ex) 2:2-3, 34)

		public function MapManager(world:World) {
			_world = world;
			_globalLocation = "0";
			this.addEventListener(MapEvent.MOVE_LEFT, moveLeftHandler);
			this.addEventListener(MapEvent.MOVE_RIGHT, moveRightHandler);
			redraw();
		}
		
		private function moveLeftHandler(e:MapEvent):void {
			_world.character.goLeft();
			moveTo(String(int(_globalLocation)-1), 10);
		}
		
		private function moveRightHandler(e:MapEvent):void {
			_world.character.goRight();
			moveTo(String(int(_globalLocation)+1), 10);
		}
		
		private function moveTo(gloc:String, spd:int):void {
			//장거리 이동도 가능하도록 수정하고 싶음, 뭔가 gloc이 바뀔때마다 이벤트가 발생해서 새로그리도록?
			if(!isBuilding(_globalLocation)){
				if(_tween != null && _tween.isPlaying) _tween.stop();
				_tween = new Tween(_world.backField, "x", None.easeNone, _world.backField.x, -int(gloc)*World.BLOCK_LENGTH, Math.abs((int(gloc)*World.BLOCK_LENGTH+_world.backField.x))/spd);
			}
			_globalLocation = gloc;
			redraw();
		}
		
		private function redraw():void {
			if(!isBuilding(_globalLocation)){
				for(var i:int = 0; i < _world.map.caveLength; i++){
					if(Math.abs(i-int(_globalLocation)) < 3)
						_world.caves[i].visible = true;
					else
						_world.caves[i].visible = false;
				}
			}
		}
		
		private function isBuilding(gloc:String):Boolean {
			var flag = false;
			for(var i:int = 0; i < gloc.length; i++){
				if(gloc.charAt(i) == ":"){
					flag = true;
					break;
				}
			}
			return flag;
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
