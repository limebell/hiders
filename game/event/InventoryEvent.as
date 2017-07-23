package game.event {
	import flash.events.Event;
	
	public class InventoryEvent extends Event {
		
		public static const
		STATE_INVENTORY:String = "state_inventory",
		STATE_CRAFT:String = "state_craft",
		STATE_DISMANTLE:String = "state_dismantle",
		ITEM_USE:String = "item_use",
		ITEM_DUMP:String = "item_dump",
		ITEM_CRAFT:String = "item_craft",
		ITEM_DISMANTLE:String = "item_dismantle",
		CHECKBOX:String = "checkbox";

		public function InventoryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
	
}
