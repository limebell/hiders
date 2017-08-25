package game.ui {
	import system.CustomSlider;
	import system.Settings;
	import system.event.SliderEvent;
	import system.StageInfo;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	
	public class GameMenuUI extends MovieClip {
		private var _clip:MovieClip;
		private var _settingClip:MovieClip;
		private var _bgmSlider:CustomSlider;
		private var _sfxSlider:CustomSlider;
		private var _buttons:Vector.<MovieClip>;

		public function GameMenuUI() {
			_clip = new gameMenuUIClip();
			
			_buttons = new Vector.<MovieClip>();
			_buttons[0] = new button();
			_buttons[1] = new button();
			_buttons[2] = new button();
			_buttons[0].width = _buttons[1].width = _buttons[2].width = 80;
			_buttons[0].height = _buttons[1].height = _buttons[2].height = 18;
			_buttons[0].x = _buttons[1].x = _buttons[2].x = -200 + 40;
			_buttons[0].y = -30;
			_buttons[1].y = -10;
			_buttons[2].y = 10;
			_buttons[0].addEventListener(MouseEvent.CLICK, clickHandler);
			_buttons[1].addEventListener(MouseEvent.CLICK, clickHandler);
			_buttons[2].addEventListener(MouseEvent.CLICK, clickHandler);
			
			_settingClip = _clip.settingClip;
			_bgmSlider = new CustomSlider(Settings.BGMVolume);
			_sfxSlider = new CustomSlider(Settings.SFXVolume);
			
			_settingClip.addChild(_bgmSlider);
			_settingClip.addChild(_sfxSlider);
			_bgmSlider.addEventListener(SliderEvent.SLIDER_MOVED, sliderMovedHandler);
			_sfxSlider.addEventListener(SliderEvent.SLIDER_MOVED, sliderMovedHandler);
			
			_bgmSlider.x = _sfxSlider.x = 110;
			_bgmSlider.y = 69;
			_sfxSlider.y = 85;
			
			_clip.addChild(_buttons[0]);
			_clip.addChild(_buttons[1]);
			_clip.addChild(_buttons[2]);
			this.addChild(_clip);
			
			_settingClip.visible = false;
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _buttons[0]:
					_settingClip.visible = !_settingClip.visible;
					break;
				case _buttons[1]:
					StageInfo.root.gotoAndStop("title");
					break;
				case _buttons[2]:
					fscommand("quit");
					break;
			}
		}
		
		private function sliderMovedHandler(e:SliderEvent):void {
			switch(e.target){
				case _bgmSlider:
					Settings.BGMVolume = _bgmSlider.value;
					break;
				case _sfxSlider:
					Settings.SFXVolume = _sfxSlider.value;
					break;
			}
		}

	}
	
}
