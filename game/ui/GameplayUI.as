package game.ui {
	import game.core.Game;
	import game.db.JobDB;
	import game.db.FontDB;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class GameplayUI extends MovieClip {
		public const
		BAR_LENGTH:int = 170;
		
		private var _clip:MovieClip;
		private var _portrait:MovieClip;
		private var _bar_hp:MovieClip;
		private var _bar_st:MovieClip;
		private var _txt_hp:TextField;
		private var _txt_st:TextField;
		private var _portraitTextField:Object;
		private var _textFormat:TextFormat;
		
		private var _inventorybtn:MovieClip;
		private var _menubtn:MovieClip;
		private var _uiClip:MovieClip;
		private var _closebtn:MovieClip;
		private var _inventoryUI:InventoryUI;
		private var _gameMenuUI:GameMenuUI;

		public function GameplayUI() {
			_clip = new gameplayUIClip();
			_portrait = JobDB.getJobAt(Game.currentGame.job).clip;
			_bar_hp = new bar_hp();
			_bar_st = new bar_st();
			_txt_hp = new TextField();
			_txt_st = new TextField();
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NPen), 8, 0xffffff);
			_textFormat.align = "center";
			
			_inventorybtn = new button();
			_menubtn = new button();
			_inventoryUI = new InventoryUI();
			_gameMenuUI = new GameMenuUI();
			_uiClip = new uiClipUI();
			_closebtn = new button();
			
			_portrait.gotoAndStop("portrait");
			_portrait.x = -280;
			_portrait.y = -140;
			_portrait.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			_bar_hp.x = _bar_st.x = -228;
			_bar_hp.y = -142;
			_bar_st.y = -122;
			
			_txt_hp.defaultTextFormat = _txt_st.defaultTextFormat = _textFormat;
			_txt_hp.x = _txt_st.x = -235;
			_txt_hp.y = -148.5;
			_txt_st.y = -128.5;
			_txt_hp.mouseEnabled = _txt_st.mouseEnabled = false;
			
			_portraitTextField = new Object();
			_portraitTextField.clip = new MovieClip();
			_portraitTextField.middle = new portraitTextFieldClip_middle();
			_portraitTextField.down = new portraitTextFieldClip_down();
			_portraitTextField.tf = new TextField();
			_portraitTextField.tf.mouseEnabled = false;
			_portraitTextField.tf.wordWrap = true;
			_portraitTextField.tf.autoSize = "center";
			_portraitTextField.tf.width = 90;
			_portraitTextField.tf.x = 5;
			_textFormat.size = 10;
			_textFormat.color = 0;
			_portraitTextField.tf.defaultTextFormat = _textFormat;
			_portraitTextField.tf.text = JobDB.getJobAt(Game.currentGame.job).jobName+"\n";
			_portraitTextField.tf.appendText(JobDB.getJobAt(Game.currentGame.job).description);
			_textFormat.size = 8;
			_portraitTextField.tf.setTextFormat(_textFormat, JobDB.getJobAt(Game.currentGame.job).jobName.length+1, _portraitTextField.tf.length-1);
			_portraitTextField.down.y = _portraitTextField.middle.height = _portraitTextField.tf.height;
			_portraitTextField.clip.addChild(new portraitTextFieldClip_up());
			_portraitTextField.clip.addChild(_portraitTextField.middle);
			_portraitTextField.clip.addChild(_portraitTextField.down);
			_portraitTextField.clip.addChild(_portraitTextField.tf);
			_portraitTextField.clip.x = _portrait.x - _portrait.width/2;
			_portraitTextField.clip.y = _portrait.y + _portrait.height;
			_portraitTextField.clip.visible = false;
			
			_inventorybtn.width = _inventorybtn.height = _menubtn.width = _menubtn.height = 25;
			_inventorybtn.x = 262.5;
			_menubtn.x = 292.5;
			_inventorybtn.y = _menubtn.y = -152.5;
			_closebtn.width = 16;
			_closebtn.height = 32;
			_closebtn.x = 245;
			
			_inventorybtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_menubtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_closebtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_uiClip.addChild(_inventoryUI);
			_uiClip.addChild(_gameMenuUI);
			_uiClip.addChild(_closebtn);
			_uiClip.visible = false;
			_inventoryUI.visible = false;
			_gameMenuUI.visible = false;
			
			this.addChild(_clip);
			_clip.addChild(_portrait);
			_clip.addChild(_bar_hp);
			_clip.addChild(_bar_st);
			_clip.addChild(_txt_hp);
			_clip.addChild(_txt_st);
			_clip.addChild(_menubtn);
			_clip.addChild(_inventorybtn);
			_clip.addChild(_portraitTextField.clip);
			_clip.addChild(_uiClip);
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			if(Game.currentGame.noAction) return;
			switch(e.target){
				case _portrait:
					_portrait.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
					_portrait.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
					_portraitTextField.clip.visible = true;
					break;
			}
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			switch(e.target){
				case _portrait:
					_portrait.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
					_portrait.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
					_portraitTextField.clip.visible = false;
					break;
			}
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _inventorybtn:
					if(Game.currentGame.noAction) return;
					Game.currentGame.inventoryOn();
					break;
				case _menubtn:
					if(Game.currentGame.noAction) return;
					Game.currentGame.gameMenuOn();
					break;
				case _closebtn:
					Game.currentGame.uiClipOff();
					break;
			}
		}
		
		public function gameMenuUIOn():void {
			_gameMenuUI.visible = true;
		}
		
		public function gameMenuUIOff():void {
			_gameMenuUI.visible = false;
		}
		
		public function get hpBar():MovieClip {
			return _bar_hp;
		}
		
		public function get stBar():MovieClip {
			return _bar_st;
		}
		
		public function get uiClip():MovieClip {
			return _uiClip;
		}
		
		public function get inventoryUI():InventoryUI {
			return _inventoryUI;
		}
		
		public function set hpTxt(s:String):void {
			_txt_hp.text = s;
		}
		
		public function set stTxt(s:String):void {
			_txt_st.text = s;
		}
		

	}
	
}
