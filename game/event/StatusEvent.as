package game.event {
	import flash.events.Event;
	
	public class StatusEvent extends Event {
		public static const
		INCREASED_ATK:String = "increased_atk",
		INCREASED_DEF:String = "increased_def",
		INCREASED_MHP:String = "increased_mhp",
		INCREASED_MST:String = "increased_mst",
		INCREASED_HP:String = "increased_hp",
		INCREASED_ST:String = "increased_st",
		DECREASED_ATK:String = "decreased_atk",
		DECREASED_DEF:String = "increased_def",
		DECREASED_MHP:String = "increased_mhp",
		DECREASED_MST:String = "increased_mst",
		DECREASED_HP:String = "increased_hp",
		DECREASED_ST:String = "increased_st";

		public function StatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
