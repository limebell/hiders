package game.core {
	import game.item.Inventory;
	import game.item.ItemInfo;
	import game.ui.InventoryUI;
	import game.db.ItemDB;
	import flash.text.TextField;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import game.event.InventoryEvent;
	import game.db.CraftData;
	import flash.display.MovieClip;
	import game.db.ItemData;
	
	public class ItemManager extends EventDispatcher {
		private var _inventory:Inventory;
		private var _ui:InventoryUI;
		private var _currentTarget:int;
		private var _selectedItem:int;
		private var _prevSelectedItem:int;
		private var _viewPossibleOnly:Boolean;

		public function ItemManager(ui:InventoryUI, inv:Object = null) {
			_inventory = new Inventory();
			_ui = ui;
			_viewPossibleOnly = true;
			
			for(var i:int = 0; i < ItemDB.getNumCraftRecipe(); i++){
				var data:CraftData = ItemDB.getCraftRecipeAt(i);
				_ui.craftItems.push(_ui.newItem(ItemDB.getItem(data.itemCode).clip));
				_ui.craftField.addChild(_ui.craftItems[i].clip);
				_ui.craftItems[i].btn.addEventListener(MouseEvent.CLICK, clickHandler);
				_ui.recipeField.recipes.push(new Object());
				_ui.recipeField.recipes[i].vec = new Vector.<Object>();
				_ui.recipeField.recipes[i].clip = new MovieClip();
				_ui.recipeField.clip.addChild(_ui.recipeField.recipes[i].clip);
				for(var j:int = 0; j < data.recipe.length; j++){
					_ui.recipeField.recipes[i].vec.push(_ui.newItem(ItemDB.getItem(data.recipe[j].x).clip));
					_ui.recipeField.recipes[i].vec[j].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+j);
					_ui.recipeField.recipes[i].vec[j].clip.y = 30;
					_ui.recipeField.recipes[i].clip.addChild(_ui.recipeField.recipes[i].vec[j].clip);
					_ui.recipeField.recipes[i].clip.visible = false;
				}
			}
			
			this.addEventListener(InventoryEvent.STATE_INVENTORY, inventoryEventHandler);
			this.addEventListener(InventoryEvent.STATE_CRAFT, inventoryEventHandler);
			this.addEventListener(InventoryEvent.STATE_DISMANTLE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_USE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_DUMP, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_CRAFT, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_DISMANTLE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.CHECKBOX, inventoryEventHandler);
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
				_ui.items.push(_ui.newItem(info.clip));
				_inventory.addItem(info);
				_ui.itemField.addChild(_ui.items[i].clip);
				_ui.items[i].btn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			if(_ui.visible) refreshInventoryUI();
		}
		
		private function clickHandler(e:MouseEvent):void {
			var i:int;
			if(_ui.state != InventoryUI.CRAFT){
				for(i = 0; i < _inventory.numItems; i++){
					if(e.target == _ui.items[i].btn) break;
				}
				_prevSelectedItem = _selectedItem;
				_selectedItem = i;
			} else {
				for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
					if(e.target == _ui.craftItems[i].btn) break;
				}
				_prevSelectedItem = _selectedItem;
				_selectedItem = i;
			}
			refreshInventoryUI();
		}
		
		private function inventoryEventHandler(e:InventoryEvent):void {
			switch(e.type){
				case InventoryEvent.STATE_INVENTORY:
					if(_ui.state == InventoryUI.INVENTORY) return;
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					_ui.state = InventoryUI.INVENTORY;
					refreshInventoryUI();
					break;
				
				case InventoryEvent.STATE_CRAFT:
					if(_ui.state == InventoryUI.CRAFT) return;
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					_ui.state = InventoryUI.CRAFT;
					_viewPossibleOnly = true;
					refreshInventoryUI();
					break;
				
				case InventoryEvent.STATE_DISMANTLE:
					if(_ui.state == InventoryUI.DISMANTLE) return;
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					_ui.state = InventoryUI.DISMANTLE;
					refreshInventoryUI();
					break;
				
				case InventoryEvent.ITEM_USE:
					break;
				
				case InventoryEvent.ITEM_DUMP:
					if(_selectedItem == -1) return;
					removeItemAt(_selectedItem);
					break;
				
				case InventoryEvent.ITEM_CRAFT:
					if(_selectedItem == -1 || !craftable(_selectedItem)) return;
					craft(_selectedItem);
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					refreshInventoryUI();
					break;
				
				case InventoryEvent.ITEM_DISMANTLE:
					break;
				
				case InventoryEvent.CHECKBOX:
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					_viewPossibleOnly = !_viewPossibleOnly;
					refreshInventoryUI();
					break;
			}
		}
		
		private function craftable(index:int):Boolean {
			var flag:Boolean = true, i:int, data:CraftData = ItemDB.getCraftRecipeAt(index);
			for(i = 0; i < data.recipe.length; i++){
				if(numItem(data.recipe[i].x) < data.recipe[i].y) flag = false;
			}
			
			return flag;
		}
		
		private function craft(index:int):void {
			var i:int, j:int, data:CraftData;
			data = ItemDB.getCraftRecipeAt(index);
			for(i = 0; i < data.recipe.length; i++){
				for(j = 0; j < _inventory.numItems; j++){
					if(data.recipe[i].x == _inventory.itemAt(j).itemCode){
						removeItemAt(j, data.recipe[i].y);
						break;
					}
				}
			}
			achieveItem(data.itemCode);
		}
		
		public function inventoryUIOnOff():void {
			_ui.visible = !_ui.visible;
			_prevSelectedItem = _selectedItem = -1;
			if(_ui.visible) refreshInventoryUI();
		}
		
		public function refreshInventoryUI():void {
			var i:int, j:int, count:int;
			_ui.selectItem(_prevSelectedItem, _selectedItem);
			
			if(_ui.state != InventoryUI.CRAFT){
				for(i = 0; i < _inventory.numItems; i++){
					_ui.items[i].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+(i%InventoryUI.MAX_XNUM));
					_ui.items[i].clip.y = InventoryUI.ITEM_HEIGHT*1.25*(1/2+int(i/InventoryUI.MAX_XNUM));
					if(_inventory.itemAt(i).number != 1) _ui.items[i].tf.text = _inventory.itemAt(i).number;
					else _ui.items[i].tf.text = "";
					
					if(i == _selectedItem){
						_ui.description = _inventory.itemAt(i).itemName+"/"+_inventory.itemAt(i).description;
					}
				}
			} else {
				count = 0;
				for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
					if((_viewPossibleOnly && craftable(i)) || !_viewPossibleOnly){
						_ui.craftItems[i].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+(count%InventoryUI.MAX_XNUM));
						_ui.craftItems[i].clip.y = InventoryUI.ITEM_HEIGHT*1.25*(1/2+int(count/InventoryUI.MAX_XNUM));
						_ui.craftItems[i].clip.visible = true;
						count++;
						if(i == _selectedItem){
							var data:ItemData = ItemDB.getItem(ItemDB.getCraftRecipeAt(i).itemCode);
							_ui.description = data.itemName+"/"+data.description;
							for(j = 0; j < ItemDB.getCraftRecipeAt(i).recipe.length; j++){
								_ui.recipeField.recipes[i].vec[j].tf.text = numItem(ItemDB.getCraftRecipeAt(i).recipe[j].x)+"/"+ItemDB.getCraftRecipeAt(i).recipe[j].y;
							}
							
						}
					} else _ui.craftItems[i].clip.visible = false;
				}
				_ui.setCheckButton(_viewPossibleOnly);
			}
			if(_selectedItem == -1) _ui.description = "\n\n\n\n선택된 아이템이 없습니다.\n아이템 설명을 보려면 아이템을 클릭하여 선택해 주세요.";
		}
		
		public function numItem(itemCode:int):int {
			//return amount of itemCode. if don't have, return 0
			var i:int, num:int = 0;
			for(i = 0; i < _inventory.numItems; i++){
				if(_inventory.itemAt(i).itemCode == itemCode){
					num = _inventory.itemAt(i).number;
					break;
				}
			}
			return num;
		}
		
		public function removeItemAt(index:int, amount:int = 1):void {
			//item 제거
			if(_inventory.removeAmountAt(index, amount)){
				_ui.itemField.removeChild(_ui.items[index].clip);
				_ui.items.removeAt(index);
				if(_ui.state != InventoryUI.CRAFT) _prevSelectedItem = _selectedItem = -1;
			}
			refreshInventoryUI();
		}

	}
	
}
