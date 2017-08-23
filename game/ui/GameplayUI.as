﻿package game.ui {
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
		private var _skillField:MovieClip;
		private var _skillBox:MovieClip;
		private var _skillText:TextField;
		private var _textFormat:TextFormat;
		
		private var _inventorybtn:MovieClip;
		private var _menubtn:MovieClip;
		private var _inventoryUI:InventoryUI;

		public function GameplayUI() {
			_clip = new gameplayUIClip();
			_portrait = JobDB.getJobAt(Game.currentGame.job).clip;
			_bar_hp = new bar_hp();
			_bar_st = new bar_st();
			_txt_hp = new TextField();
			_txt_st = new TextField();
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NPen), 6, 0xffffff);
			_textFormat.align = "center";
			
			_inventorybtn = new button();
			_menubtn = new button();
			_inventoryUI = new InventoryUI();
			
			_portrait.gotoAndStop("portrait");
			_portrait.x = -280;
			_portrait.y = -140;
			_portrait.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			
			_bar_hp.x = _bar_st.x = -228;
			_bar_hp.y = -142;
			_bar_st.y = -122;
			
			_txt_hp.defaultTextFormat = _txt_st.defaultTextFormat = _textFormat;
			_txt_hp.x = _txt_st.x = -235;
			_txt_hp.y = -147;
			_txt_st.y = -127;
			_txt_hp.mouseEnabled = _txt_st.mouseEnabled = false;
			
			_skillField = new MovieClip();
			_skillBox = new skillFieldClip();
			_skillText = new TextField();
			_skillText.mouseEnabled = false;
			_skillText.wordWrap = true;
			_skillText.autoSize = "left";
			_skillText.width = 150;
			_textFormat.color = 0;
			_skillText.defaultTextFormat = _textFormat;
			_skillText.appendText(JobDB.getJobAt(Game.currentGame.job).description);
			_skillBox.width = _skillText.width;
			_skillBox.height = _skillText.height;
			_skillField.addChild(_skillBox);
			_skillField.addChild(new skillFieldClip_up());
			_skillField.addChild(_skillText);
			_skillField.x = _portrait.x - _portrait.width/2;
			_skillField.y = _portrait.y + 60;
			_skillField.visible = false;
			
			_inventorybtn.width = _inventorybtn.height = _menubtn.width = _menubtn.height = 25;
			_inventorybtn.x = 262.5;
			_menubtn.x = 297.5;
			_inventorybtn.y = _menubtn.y = -152.5;
			
			_inventorybtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_menubtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_inventoryUI.visible = false;
			
			this.addChild(_clip);
			_clip.addChild(_portrait);
			_clip.addChild(_bar_hp);
			_clip.addChild(_bar_st);
			_clip.addChild(_txt_hp);
			_clip.addChild(_txt_st);
			_clip.addChild(_menubtn);
			_clip.addChild(_inventorybtn);
			_clip.addChild(_skillField);
			_clip.addChild(_inventoryUI);
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			if(Game.currentGame.noAction) return;
			switch(e.target){
				case _portrait:
					_portrait.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
					_portrait.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
					_skillField.visible = true;
					break;
			}
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			switch(e.target){
				case _portrait:
					_portrait.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
					_portrait.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
					_skillField.visible = false;
					break;
			}
		}
		
		private function clickHandler(e:MouseEvent):void {
			if(Game.currentGame.noAction) return;
			switch(e.target){
				case _inventorybtn:
					Game.currentGame.inventoryOnOff();
					break;
				case _menubtn:
					trace("menu button");
					break;
			}
		}
		
		public function get hpBar():MovieClip {
			return _bar_hp;
		}
		
		public function get stBar():MovieClip {
			return _bar_st;
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
