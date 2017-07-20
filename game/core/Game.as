package game.core {
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	
	import game.map.World;
	import game.ui.Warning;
	import game.map.Map;
	import game.ui.GameplayUI;
	import game.ui.ConsoleUI;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import game.ui.Shade;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		public static var currentGame:Game;
		
		private var _root:MovieClip;
		private var _data:Object;
		
		private var _console:ConsoleUI;
		private var _ui:GameplayUI;
		private var _world:World;
		private var _map:Map;
		
		private var _display:MovieClip;
		
		private var _mapManager:MapManager;
		private var _statusManager:StatusManager;
		private var _itemManager:ItemManager;
		
		private var _characterIndex:int;
		
		public function Game(root:MovieClip, loadData:Object=null) {
			currentGame = this;
			_data = loadData;
			
			_root = root;
			root.gotoAndStop("play");
			_root.shade.gotoAndPlay(2);
			_display = _root.disp;
			
			_root.stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			
			if(!initGame()) throw new IllegalOperationError("게임을 초기화 할 수 없습니다.");
			else startGame();
		}
		
		private function checkInit():void {
			if(_world && _itemManager){
				startGame();
			}
		}
		
		private function initGame():Boolean {
			if(_data == null){
				if(_root.characterSelectUI == null) return false;
				
				_characterIndex = _root.characterSelectUI.index;
				
				_map = new Map();
				return true;
			} else return loadData();
		}
		
		private function loadData():Boolean {
			//유효한지 검사, 그리고 유효하지 않다면 false를 반환
			return true;
		}
		
		private function startGame():void {
			_world = new World(new Character(_characterIndex), _map);
			_mapManager = new MapManager(_world);
				
			_ui = new GameplayUI();
			_statusManager = new StatusManager(_ui, true, _characterIndex);
			
			_console = new ConsoleUI();
			_console.visible = false;
			
			_display.addChild(_world);
			_display.addChild(_ui);
			_display.addChild(_console);
			
			Shade.fadeIn();
		}
		
		private function endGame():void {
			_display.removeChild(_world);
			_display.removeChild(_ui);
			_display.removeChild(_console);
		}
		
		public function setMouse(state:String):void {
			_root.mc_cursor.gotoAndStop(state);
		}
		
		public function get character():int {
			return _characterIndex;
		}
		
		public function get itemManager():ItemManager {
			return _itemManager;
		}
		
		public function get statusManager():StatusManager {
			return _statusManager;
		}
		
		public function get mapManager():MapManager {
			return _mapManager;
		}
		
		public function get root():MovieClip {
			return _root;
		}
		
		private function keydownHandler(e:KeyboardEvent):void {
			switch(e.keyCode){
				case 192:	//`
					//open console
					_console.switchState();
					break;
				case Keyboard.I:
					//open inventory;
					break;
				case Keyboard.EXIT:
					//open menu;
					break;
			}
		}
	}
}