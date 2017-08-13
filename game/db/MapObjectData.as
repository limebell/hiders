package game.db {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class MapObjectData {
		
		internal var _objectCode:int, _clip:String, _interactionable:Boolean;
		
		public function get objectCode():int {
			return _objectCode;
		}
		
		public function get clip():MovieClip {
			return new (Class(getDefinitionByName(_clip)))();
		}
		
		public function get interactionable():Boolean {
			return _interactionable;
		}

	}
	
}
