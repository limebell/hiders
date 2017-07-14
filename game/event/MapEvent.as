package game.event {
	import flash.events.Event;
	
	public class MapEvent extends Event {
		
		public static const
		MOVE_LEFT:String = "moveLeft",
		MOVE_RIGHT:String = "moveRight",
		ENTER_BUILDING:String = "enterBuilding",
		LEAVE_BUILDING:String = "leaveBuilding";

		public function MapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
