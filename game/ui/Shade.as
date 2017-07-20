package game.ui {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class Shade {
		private static var _shade:MovieClip;
		private static var _tween:Tween;
		
		public function Shade(shade:MovieClip) {
			_shade = shade;
			_shade.mouseEnabled = false;
			_shade.alpha = 0;
		}
		
		public static function fadeIn(t:int = 36):void {
			if(_tween != null && _tween.isPlaying) _tween.stop();
			_shade.mouseEnabled = true;
			_shade.visible = true;
			_tween = new Tween(_shade, "alpha", None.easeIn, 1, 0, t);
			_tween.addEventListener(TweenEvent.MOTION_FINISH, finishHandler);
		}
		
		public static function fadeOut(t:int = 36):void {
			if(_tween != null && _tween.isPlaying) _tween.stop();
			_shade.mouseEnabled = true;
			_shade.visible = true;
			_tween = new Tween(_shade, "alpha", None.easeIn, 0, 1, t);
		}
		
		private static function finishHandler(e:TweenEvent):void {
			_shade.mouseEnabled = false;
			_shade.visible = false;
		}
	}
	
}
