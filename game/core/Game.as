package game.core {
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	
	import game.map.World;
	import game.ui.Warning;
	import game.map.Map;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		public static var currentGame:Game;
		
		private var _root:Object;
		private var _data:Object;
		
		private var _character:Character;
		private var _world:World;
		private var _map:Map;
		
		private var _display:MovieClip;
		
		private var _mapManager:MapManager;
		private var _itemManager:ItemManager;
		
		public function Game(root:MovieClip, loadData:Object=null) {
			currentGame = this;
			_data = loadData;
			
			_mapManager = new MapManager();
			
			_root = Object(root);
			root.gotoAndStop("play");
			_root.shade.gotoAndPlay(2);
			_display = _root.disp;
			
			if(!initGame()) throw new IllegalOperationError("게임을 초기화 할 수 없습니다.");
		}
		
		private function checkInit():void {
			if(_character && _world && _itemManager){
				startGame();
			}
		}
		
		private function initGame():Boolean {
			if(_data == null){
				if(_root.characterSelectUI == null) return false;
				
				_character = new Character(_root.characterSelectUI.index);
				_map = new Map();
				
				_world = new World(_character, _map);
				_display.addChild(_world);
				return true;
			} else return loadData();
		}
		
		private function loadData():Boolean {
			//유효한지 검사, 그리고 유효하지 않다면 false를 반환
			return true;
		}
		
		private function startGame():void {
			
		}
		
		public function get mapManager():MapManager {
			return _mapManager;
		}
		
		public function get itemManager():ItemManager {
			return _itemManager;
		}
	}
}