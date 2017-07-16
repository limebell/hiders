package game.core {
	import flash.events.EventDispatcher;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import game.map.World;
	import game.event.MapEvent;
	import fl.transitions.TweenEvent;
	
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
			setButtonOf(_globalLocation);
			redrawFromTo();
		}
		
		private function moveLeftHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			_world.character.goLeft();
			Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 2);
			moveTo(String(int(_globalLocation)-1), 10);
		}
		
		private function moveRightHandler(e:MapEvent):void {
			if(_tween != null && _tween.isPlaying) return;
			_world.character.goRight();
			Game.currentGame.statusManager.sub(StatusManager.CUR_ST, 2);
			moveTo(String(int(_globalLocation)+1), 10);
		}
		
		private function moveTo(gloc:String, spd:int):void {
			//버튼 컨트롤
			_world.setButton();
			//장거리 이동도 가능하도록 수정하고 싶음, 뭔가 gloc이 바뀔때마다 이벤트가 발생해서 새로그리도록?
			if(!isBuilding(_globalLocation)){
				if(_tween != null && _tween.isPlaying) _tween.stop();
				_tween = new Tween(_world.backField, "x", None.easeNone, _world.backField.x, -int(gloc)*World.BLOCK_LENGTH, Math.abs((int(gloc)*World.BLOCK_LENGTH+_world.backField.x))/spd);
				
			}
			
			_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
			
			//임시
			setButtonOf(gloc);
			
			redrawFromTo(_globalLocation, gloc);
			_globalLocation = gloc;
		}
		
		private function tweenFinishHandler(e:TweenEvent):void {
			_world.character.standStill();
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
		}
		
		private function setButtonOf(gloc:String):void {
			if(!isBuilding(gloc)){
				switch(_world.map.caveAt(int(gloc)).x){
					case 0:
						_world.setButton(true, true);
						break;
					case 1:
						_world.setButton(false, true);
						break;
					case 2:
						_world.setButton(true, false);
						break;
				}
			}
		}
		
		private function redrawFromTo(from:String = "$", to:String = "$"):void {
			var _from:String = (from=="$"?_globalLocation:from), _to:String = (to=="$"?_globalLocation:to);
			if(!isBuilding(_globalLocation)){
				for(var i:int = 0; i < _world.map.caveLength; i++){
					if(Math.abs(i-int(from)) < 2 || Math.abs(i-int(to)) < 2)
						_world.caves[i].visible = true;
					else
						_world.caves[i].visible = false;
				}
			}
			
			//맵오브젝트 그리는 부분
			//...
			/*for(i=0;i<맵오브젝트 개수;i++){
				i번째 오브젝트의 글로벌 위치가 저 프롬투 범위에 있으면? > visible = true;
				아니면 false
			}*/
			
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
