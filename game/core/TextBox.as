package game.core {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.events.TimerEvent;
	
	public class TextBox extends MovieClip {
		private var _text:String;
		private var _textField:TextField;
		public static var talking:Boolean = false;

		public function TextBox() {
			// constructor code
			_textField = new TextField();
			_text = '';
		}
		
		public function say(t:String):Boolean {
			if(talking) return false;
			
			_text = t;
			talking = true;
			//로그에 추가하는 기능
			return true;
		}
		
		private function timerHandler(e:TimerEvent):void {
			_remove();
		}
		
		public function stopTalking():Boolean {
			if(!talking) return false;
			
			_remove();
			return true;
		}
		
		private function _remove():void {
			talking = false;
		}

	}
	
}
