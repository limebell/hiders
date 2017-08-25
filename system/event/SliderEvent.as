package system.event {
	import flash.events.Event;
	
	public class SliderEvent extends Event {
		
		public static const
		SLIDER_MOVED:String = "sliderMoved";

		public function SliderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
