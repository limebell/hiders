package game.core {
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	
	import game.map.World;
	import game.ui.Warning;
	
	public class Game extends EventDispatcher {
		private static const NO_DATA:int = -1;
		public static var currentGame:Game;
		
		private var _root:Object;
		private var _data:Object;
		
		private var _character:Character;
		private var _textBox:TextBox;
		private var _world:World;
		
		private var _display:MovieClip;
		
		private var _mapManager:MapManager;
		private var _itemManager:ItemManager;
		
		public function Game(root:MovieClip, loadData:Object=null) {
			currentGame = this;
			_data = loadData;
			
			_mapManager = new MapManager();
			_textBox = new TextBox();
			
			_root = Object(root);
			root.gotoAndStop("play");
			_root.shade.gotoAndPlay(2);
			_display = _root.disp;
			
			if(!initGame()) throw new IllegalOperationError("게임을 초기화 할 수 없습니다.");
		}
		
		private function checkInit():void {
			if(_character && _world && _itemManager && _textBox){
				startGame();
			}
		}
		
		private function initGame():Boolean {
			if(_data == null){
				if(_root.characterSelectUI == null) return false;
				
				_character = new Character(_root.characterSelectUI.index);
				Warning.warning.push("start error : "+_character.charName+"이 아직 준비되지 않았습니다... 뭔가 말을 열심히 써서 칸을 늘려야겠다 끙챠끙챠 영차영차");
				return true;
			} else return loadData();
		}
		
		private function loadData():Boolean {
			//유효한지 검사, 그리고 유효하지 않다면 false를 반환
			return true;
		}
		
		private function startGame():void {
			
		}
	}
}