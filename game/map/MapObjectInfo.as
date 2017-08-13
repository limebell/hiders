package game.map {
	import flash.geom.Point;
	import game.db.MapObjectData;
	import flash.display.MovieClip;
	
	public class MapObjectInfo {
		
		private var _data:MapObjectData, _clip:MovieClip, _globalLocation:String, _localLocation:Point, _isFront:Boolean, _isExisting:Boolean;
		
		public function MapObjectInfo(data:MapObjectData, globalLocation:String, localLocation:Point, isFront:Boolean, isExisting:Boolean) {
			_data = data;
			_clip = _data.clip;
			_globalLocation = globalLocation;
			_localLocation = localLocation;
			_isFront = isFront;
			_isExisting = isExisting;
		}
		
		public function get objectCode():int {
			return _data.objectCode;
		}
		
		public function get clip():MovieClip {
			return _clip;
		}
		
		public function get interactionable():Boolean {
			return _data.interactionable;
		}
		
		public function get globalLocation():String {
			return _globalLocation;
		}
		
		public function get localLocation():Point {
			return _localLocation;
		}
		
		public function get isFront():Boolean {
			return _isFront;
		}
		
		public function get isExisting():Boolean {
			return _isExisting;
		}
		
		public function isNear(target:String):Boolean {
			//Need to be fixed
			trace(target+" is Near");
			return true;
		}

	}
	
}
