package game.map {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.db.MapObjectDB;
	
	public class MapObjects extends MovieClip {
		private var _objects:Vector.<MapObjectInfo>;
		private var _currentGlobal:String;
		private var _currentlyVisibleClips:Vector.<MovieClip>;

		public function MapObjects() {
			
			_objects = new Vector.<MapObjectInfo>();
			_currentlyVisibleClips = new Vector.<MovieClip>();
			
		}
		
		public function addObject(code:int, globalLocation:String, localLocation:Point):void {
			var object:MapObjectInfo = new MapObjectInfo();
			object._data = game.db.MapObjectDB.getObject(code);
			object._globalLocation = globalLocation;
			object._localLocation = localLocation;
			object._isExisting = true;
			
			_objects.push(object);
		}
		
		public function initialize():void {
			for each(var object:MapObjectInfo in _objects){
				if(object.clip != null){
					this.addChild(object.clip);
					object.clip.visible = false;
				}
			}
		}
		
		public function removeItemAt(index:int):void {
			_objects[index]._isExisting = false;
			if(_objects[index].clip != null) this.removeChild(_objects[index].clip);
			redraw(_currentGlobal);
		}
		
		public function redraw(globalLocation:String):void {
			for each(var clip:MovieClip in _currentlyVisibleClips)
				clip.visible = false;
			
			for each(var object:MapObjectInfo in _objects){
				if( object.isNear(_currentGlobal) ){
					if( object.clip != null ){
						object.clip.visible = true;
					}
				}
			}
		}

	}
	
}
