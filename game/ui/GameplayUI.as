package game.ui {
	import flash.display.MovieClip;
	import game.core.Game;
	import game.db.CharacterDB;
	
	public class GameplayUI extends MovieClip {
		public const
		BAR_LENGTH:int = 170;
		
		private var _clip:MovieClip;
		private var _portrait:MovieClip;
		private var _bar_hp:MovieClip;
		private var _bar_st:MovieClip;
		
		private var _inventorybtn:MovieClip;
		private var _menubtn:MovieClip;

		public function GameplayUI() {
			_clip = new gameplayUIClip();
			
			//_portrait = CharacterDB.getCharacterAt(Game.currentGame.character).clip;
			_bar_hp = new bar_hp();
			_bar_st = new bar_st();
			_inventorybtn = new button();
			_menubtn = new button();
			
			//_portrait.gotoAndStop("portrait");
			//_portrait.width = _portrait.height = 100;
			//_portrait.x = -560;
			//_portrait.y = -280;
			
			_bar_hp.x = _bar_st.x = -455;
			_bar_hp.y = -285;
			_bar_st.y = -245;
			
			_inventorybtn.width = _inventorybtn.height = _menubtn.width = _menubtn.height = 50;
			_inventorybtn.x = 525;
			_menubtn.x = 585;
			_inventorybtn.y = _menubtn.y = -305;
			
			this.addChild(_clip);
			//_clip.addChild(_portrait);
			_clip.addChild(_bar_hp);
			_clip.addChild(_bar_st);
			_clip.addChild(_menubtn);
			_clip.addChild(_inventorybtn);
		}
		
		public function get hpBar():MovieClip {
			return _bar_hp;
		}
		
		public function get stBar():MovieClip {
			return _bar_st;
		}

	}
	
}
