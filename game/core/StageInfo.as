package game.core {
	import flash.display.MovieClip;
	
	public class StageInfo {
		private static var _root:MovieClip;

		public function StageInfo(root:MovieClip) {
			_root = root;
		}
		
		public static function get stageWidth():Number {
			return _root.stage.stageWidth;
		}
		
		public static function get stageHeight():Number {
			return _root.stage.stageHeight;
		}

	}
	
}
