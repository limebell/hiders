package game.core {
	import game.item.Inventory;
	import game.item.ItemInfo;
	import game.ui.InventoryUI;
	import game.db.ItemDB;
	import flash.text.TextField;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class ItemManager extends EventDispatcher {
		private var _inventory:Inventory;
		private var _ui:InventoryUI;
		private var _currentTarget:int;
		private var _selectedItem:int;
		private var _prevSelectedItem:int;

		public function ItemManager(ui:InventoryUI, inv:Object = null) {
			_inventory = new Inventory();
			_ui = ui;
		}
		
		public function achieveItem(code:int, amount:int = 1):void {
			var flag:Boolean = true, info:ItemInfo;
			for(var i:int = 0; i < _inventory.numItems; i++){
				if(_inventory.itemAt(i).itemCode == code){
					_inventory.addAmountAt(i, amount);
					flag = false;
					break;
				}
			}
			if(flag){
				info = new ItemInfo(ItemDB.getItem(code), amount, ItemDB.getItem(code).durability);
				_ui.newItem(info.clip);
				_inventory.addItem(info);
				_ui.itemField.addChild(_ui.items[i].clip);
				_ui.items[i].btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			if(_ui.visible) refreshInventoryUI();
		}
		
		private function clickHandler(e:MouseEvent):void {
			var i:int, info:ItemInfo;
			for(i = 0; i < _inventory.numItems; i++){
				if(e.target == _ui.items[i].btn){
					info = _inventory.itemAt(i);
					break;
				}
			}
			_prevSelectedItem = _selectedItem;
			_selectedItem = i;
			_ui.selectItem(_prevSelectedItem, _selectedItem);
			_ui.description = info.itemName+"\n"+info.itemClass+"\n"+info.description;
		}
		
		public function inventoryUIOnOff():void {
			_ui.visible = !_ui.visible;
			_prevSelectedItem = _selectedItem = -1;
			if(_ui.visible) refreshInventoryUI();
		}
		
		public function refreshInventoryUI():void {
			var i:int;
			for(i = 0; i < _inventory.numItems; i++){
				_ui.items[i].clip.x = _ui.ITEM_WIDTH*1.25*(1/2+(i%_ui.MAX_XNUM));
				_ui.items[i].clip.y = _ui.ITEM_WIDTH*1.25*(1/2+int(i/_ui.MAX_XNUM));
				_ui.items[i].tf.text = _inventory.itemAt(i).number;
				//_ui.items[i].clip.visible = true;
			}
		}

	}
	
}
