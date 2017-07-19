package game.event {
	import flash.events.Event;
	
	public class MapEvent extends Event {
		
		public static const
		MOVE_LEFT:String = "moveLeft",
		MOVE_RIGHT:String = "moveRight",
		MOVE_UP:String = "moveUp",
		MOVE_DOWN:String = "moveDown";

		public function MapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
