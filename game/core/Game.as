package game.core {
	import game.map.World;
	import game.ui.Warning;
	import game.map.Map;
	import game.ui.GameplayUI;
	import game.ui.Console;
	import game.ui.Shade;
	import game.ui.InventoryUI;
	
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		public static var currentGame:Game;
		
		private var _root:MovieClip;
		private var _data:Object;
		
		private var _console:Console;
		private var _ui:GameplayUI;
		private var _world:World;
		private var _map:Map;
		
		private var _display:MovieClip;
		
		private var _noAction:Boolean;
		
		private var _mapManager:MapManager;
		private var _statusManager:StatusManager;
		private var _itemManager:ItemManager;
		private var _interectionManager:InterectionManager;
		
		private var _jobIndex:int;
		
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
				if(_root.jobSelectUI == null) return false;
				
				_jobIndex = _root.jobSelectUI.index;
				
				_map = new Map();
				return true;
			} else return loadData();
		}
		
		private function loadData():Boolean {
			//유효한지 검사, 그리고 유효하지 않다면 false를 반환
			return true;
		}
		
		private function startGame():void {
			_noAction = false;
			
			_world = new World(new Character(_jobIndex), _map);
			_mapManager = new MapManager(_world);
				
			_ui = new GameplayUI();
			_statusManager = new StatusManager(_ui, true, _jobIndex);
			_itemManager = new ItemManager(_ui.inventoryUI);
			_interectionManager = new InterectionManager();
			
			_console = new Console();
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
		
		public function get job():int {
			return _jobIndex;
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
		
		public function get interectionManager():InterectionManager {
			return _interectionManager;
		}
		
		public function inventoryOnOff():void {
			_itemManager.inventoryUIOnOff();
			switchAction();
		}
		
		public function get root():MovieClip {
			return _root;
		}
		
		public function get noAction():Boolean {
			return _noAction;
		}
		
		public function set noAction(b:Boolean):void {
			_noAction = b;
		}
		
		public function switchAction():void {
			_noAction = !_noAction;
		}
		
		private function keydownHandler(e:KeyboardEvent):void {
			switch(e.keyCode){
				case 192:	//"`"
					//open console
					_console.switchState();
					this.switchAction();
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