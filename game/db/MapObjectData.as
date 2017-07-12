﻿package game.db {
	import flash.display.MovieClip;
	
	public class MapObjectData {
		
		internal var _objectCode:int, _clip:MovieClip, _interactionable:Boolean;
		
		public function get objectCode():int {
			return _objectCode;
		}
		
		public function get clip():MovieClip {
			return _clip;
		}
		
		public function get interactionable():Boolean {
			return _interactionable;
		}

	}
	
}