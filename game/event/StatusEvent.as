package game.event {
	import flash.events.Event;
	
	public class StatusEvent extends Event {
		public static const
		EQUIP_EVENT:String = "equip_event";

		public function StatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
