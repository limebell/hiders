package game.ui {
	import game.core.Game;
	import game.db.CharacterDB;
	import game.db.FontDB;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GameplayUI extends MovieClip {
		public const
		BAR_LENGTH:int = 170;
		
		private var _clip:MovieClip;
		private var _portrait:MovieClip;
		private var _bar_hp:MovieClip;
		private var _bar_st:MovieClip;
		private var _txt_hp:TextField;
		private var _txt_st:TextField;
		private var _textFormat:TextFormat;
		
		private var _inventorybtn:MovieClip;
		private var _menubtn:MovieClip;

		public function GameplayUI() {
			_clip = new gameplayUIClip();
			_portrait = new MovieClip();
			_portrait.graphics.copyFrom(CharacterDB.getCharacterAt(Game.currentGame.character).clip.graphics);
			_bar_hp = new bar_hp();
			_bar_st = new bar_st();
			_txt_hp = new TextField();
			_txt_st = new TextField();
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 12, 0xffffff);
			_textFormat.align = "center";
			
			_inventorybtn = new button();
			_menubtn = new button();
			
			//_portrait.gotoAndStop("portrait");
			_portrait.width = _portrait.height = 100;
			_portrait.x = -560;
			_portrait.y = -280;
			
			_bar_hp.x = _bar_st.x = -455;
			_bar_hp.y = -285;
			_bar_st.y = -245;
			
			_txt_hp.defaultTextFormat = _txt_st.defaultTextFormat = _textFormat;
			_txt_hp.x = _txt_st.x = -420;
			_txt_hp.y = -293;
			_txt_st.y = -253;
			_txt_hp.mouseEnabled = _txt_st.mouseEnabled = false;
			
			_inventorybtn.width = _inventorybtn.height = _menubtn.width = _menubtn.height = 50;
			_inventorybtn.x = 525;
			_menubtn.x = 585;
			_inventorybtn.y = _menubtn.y = -305;
			
			this.addChild(_clip);
			_clip.addChild(_portrait);
			_clip.addChild(_bar_hp);
			_clip.addChild(_bar_st);
			_clip.addChild(_txt_hp);
			_clip.addChild(_txt_st);
			_clip.addChild(_menubtn);
			_clip.addChild(_inventorybtn);
		}
		
		public function get hpBar():MovieClip {
			return _bar_hp;
		}
		
		public function get stBar():MovieClip {
			return _bar_st;
		}
		
		public function set hpTxt(s:String):void {
			_txt_hp.text = s;
		}
		
		public function set stTxt(s:String):void {
			_txt_st.text = s;
		}

	}
	
}
