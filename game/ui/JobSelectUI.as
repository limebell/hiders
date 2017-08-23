package game.ui {
	import game.db.JobDB;
	import game.db.JobData;
	import game.db.FontDB;
	import game.core.StageInfo;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.media.Sound;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class JobSelectUI extends MovieClip {
		private var _index:int;
		private var _clip:MovieClip;
		private var _textFormat:TextFormat;
		
		private var _job:JobData;
		private var _portrait:MovieClip;
		private var _portraitField:MovieClip;
		private var _name:TextField;
		private var _status:TextField;
		private var _description:TextField;
		
		private var _leftbtn:MovieClip;
		private var _rightbtn:MovieClip;
		
		private var _timer:Timer;
		private var _switchSound:Sound;
		private var _paperflipSound:Sound;

		public function JobSelectUI() {
			_clip = new jobSelectUIClip();
			this.addChild(_clip);
			_leftbtn = _clip.leftbtn;
			_rightbtn = _clip.rightbtn;
			
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NPen));
			_textFormat.align = "center";
			_textFormat.leading = 4;
			
			_portraitField = new MovieClip();
			_portraitField.y = -70;
			
			_name = new TextField();
			_status = new TextField();
			_description = new TextField();
			
			_textFormat.size = 15;
			_textFormat.color = 0xffffff;
			_textFormat.bold = true;
			_name.defaultTextFormat = _textFormat;
			_textFormat.size = 13;
			_textFormat.bold = false;
			_status.defaultTextFormat = _textFormat;
			_description.defaultTextFormat = _textFormat;
			
			this.addChild(_portraitField);
			this.addChild(_name);
			this.addChild(_status);
			this.addChild(_description);
			
			_name.mouseEnabled = _status.mouseEnabled = _description.mouseEnabled = false;
			_name.width = 100;
			_status.width = _description.width = StageInfo.stageWidth/5*4;
			_description.height = 100;
			
			_name.x = -_name.width/2;
			_status.x = -_status.width/2;
			_description.x = -_description.width/2;
			
			_name.y = 30;
			_status.y = 50;
			_description.y = 70;
			_description.wordWrap = true;
			
			_leftbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_rightbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_timer = new Timer(400);
			_switchSound = new sound_switch();
			_paperflipSound = new sound_paperflip();
			
			changeJobTo(0);
			_clip.gotoAndStop("on");
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _leftbtn:
					if(_index != 0) moveJobTo(_index-1);
					else _paperflipSound.play();
					break;
				case _rightbtn:
					if(_index != JobDB.getNumJobs()-1) moveJobTo(_index+1);
					else _paperflipSound.play();
					break;
			}
		}
		
		private function moveJobTo(index):void {
			if(_timer.running) return;
			
			_switchSound.play();
			_clip.gotoAndStop("off");
			Shade.fadeOut(12);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			function timerHandler(e:TimerEvent):void {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_switchSound.play();
				_clip.gotoAndStop("on");
				Shade.fadeIn(12);
				changeJobTo(index);
			}
		}
		
		private function changeJobTo(index:int) {
			_index = index;
			_job = JobDB.getJobAt(index);
			
			if(_portrait != null) _portraitField.removeChild(_portrait);
			
			_portrait = _job.clip;
			_portraitField.addChild(_portrait);
			_portrait.gotoAndStop("select");
			
			_name.text = _job.jobName;
			_status.text ="ATK : "+_job.baseATK+", DEF : "+_job.baseDEF+", HP : "+_job.baseHP+", ST : "+_job.baseST;
			_description.text = _job.description;
		}
		
		public function get index():int {
			return _index;
		}

	}
	
}
