﻿package game.map {
	import flash.geom.Point;
	import game.db.MapObjectData;
	import flash.display.MovieClip;
	
	public class MapObjectInfo {
		
		private var _data:MapObjectData, _globalLocation:String, _localLocation:Point, _isExisting:Boolean, _isFront:Boolean;
		
		public function MapObjectInfo(data:MapObjectData, globalLocation:String, localLocation:Point, isExisting:Boolean, isFront:Boolean) {
			_data = data;
			_globalLocation = globalLocation;
			_localLocation = localLocation;
			_isExisting = isExisting;
			_isFront = isFront;
		}
		
		public function set objectCode(objCode:int):void {
			
		}
		
		public function get objectCode():int {
			return _data.objectCode;
		}
		
		public function get clip():MovieClip {
			return _data.clip;
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
		
		public function get isExisting():Boolean {
			return _isExisting;
		}
		
		public function get isFront():Boolean {
			return _isFront;
		}
		
		public function isNear(target:String):Boolean {
			//Need to be fixed
			trace(target+" is Near");
			return true;
		}

	}
	
}
