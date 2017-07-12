package game.ui {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.db.FontDB;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	public class Warning {
		public static var warning:Warning;
		private var _field:MovieClip
		private var _message:String;
		private var _textField:TextField;
		private var _textFormat:TextFormat;

		public function Warning(field:MovieClip) {
			warning = this;
			
			_textField = new TextField();
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.HYShin));
			_textFormat.align = "center";
			_textFormat.leading = 7;
			_textFormat.size = 20;
			_textField.defaultTextFormat = _textFormat;
			_textField.width = 400;
			_textField.height = 200;
			_textField.x = -_textField.width/2;
			_textField.y = -100;
			_textField.wordWrap = true;
			_textField.mouseEnabled = false;
			
			_field = field;
			_field.addChild(_textField);
			_field.mouseEnabled = false;
			_field.visible = false;
		}
		
		private function clickHandler(e:MouseEvent):void {
			_field.mouseEnabled = false;
			_field.visible = false;
			
			_field.okbtn.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function push(text:String) {
			_field.visible = true;
			_field.mouseEnabled = true;
			
			_textField.text = text;
			
			_field.okbtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}

	}
	
}
