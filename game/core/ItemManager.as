package game.core {
	import game.item.Inventory;
	import game.item.ItemInfo;
	import game.ui.InventoryUI;
	import game.event.InventoryEvent;
	import game.db.ItemDB;
	import game.db.CraftData;
	import game.db.ItemData;
	import game.db.DecomposeData;
	import game.db.Consumable;
	import game.db.Equipment;
	import game.db.Tool;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.errors.IllegalOperationError;
	
	public class ItemManager extends EventDispatcher {
		private var _inventory:Inventory;
		private var _ui:InventoryUI;
		private var _currentTarget:int;
		private var _selectedItem:int;
		private var _prevSelectedItem:int;
		private var _viewPossibleOnly:Boolean;

		public function ItemManager(ui:InventoryUI, inv:Object = null) {
			var i:int, j:int;
			_inventory = new Inventory();
			//무게 제한 설정
			_inventory.maxWeight = 100;
			
			_ui = ui;
			_viewPossibleOnly = true;
			
			for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
				var data1:CraftData = ItemDB.getCraftRecipeAt(i);
				_ui.craftItems.push(_ui.newItem(ItemDB.getItem(data1.itemCode).clip, ItemDB.getItem(data1.itemCode).itemClass));
				_ui.craftField.addChild(_ui.craftItems[i].clip);
				_ui.craftItems[i].btn.addEventListener(MouseEvent.CLICK, clickHandler);
				_ui.recipeField.recipes.push(new Object());
				_ui.recipeField.recipes[i].vec = new Vector.<Object>();
				_ui.recipeField.recipes[i].clip = new MovieClip();
				_ui.recipeField.clip.addChild(_ui.recipeField.recipes[i].clip);
				for(j = 0; j < data1.recipe.length; j++){
					_ui.recipeField.recipes[i].vec.push(_ui.newItem(ItemDB.getItem(data1.recipe[j].x).clip, ItemDB.MATERIAL));
					_ui.recipeField.recipes[i].vec[j].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+j);
					_ui.recipeField.recipes[i].vec[j].clip.y = 30;
					_ui.recipeField.recipes[i].clip.addChild(_ui.recipeField.recipes[i].vec[j].clip);
					_ui.recipeField.recipes[i].clip.visible = false;
				}
			}
			
			for(i = ItemDB.getNumCraftRecipe(); i < ItemDB.getNumCraftRecipe()+ItemDB.getNumDecomposeRecipe(); i++){
				var data2:DecomposeData = ItemDB.getDecomposeRecipeAt(i-ItemDB.getNumCraftRecipe());
				_ui.recipeField.recipes.push(new Object());
				_ui.recipeField.recipes[i].vec = new Vector.<Object>();
				_ui.recipeField.recipes[i].clip = new MovieClip();
				_ui.recipeField.clip.addChild(_ui.recipeField.recipes[i].clip);
				for(j = 0; j < data2.recipe.length; j++){
					_ui.recipeField.recipes[i].vec.push(_ui.newItem(ItemDB.getItem(data2.recipe[j].x).clip, ItemDB.MATERIAL));
					_ui.recipeField.recipes[i].vec[j].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+j);
					_ui.recipeField.recipes[i].vec[j].clip.y = 30;
					_ui.recipeField.recipes[i].vec[j].tf.text = String(data2.recipe[j].y);
					_ui.recipeField.recipes[i].clip.addChild(_ui.recipeField.recipes[i].vec[j].clip);
					_ui.recipeField.recipes[i].clip.visible = false;
					
				}
			}
			
			this.addEventListener(InventoryEvent.STATE_INVENTORY, inventoryEventHandler);
			this.addEventListener(InventoryEvent.STATE_CRAFT, inventoryEventHandler);
			this.addEventListener(InventoryEvent.STATE_DECOMPOSE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_USE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_DUMP, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_CRAFT, inventoryEventHandler);
			this.addEventListener(InventoryEvent.ITEM_DECOMPOSE, inventoryEventHandler);
			this.addEventListener(InventoryEvent.CHECKBOX, inventoryEventHandler);
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
				
				case InventoryEvent.STATE_DECOMPOSE:
					if(_ui.state == InventoryUI.DECOMPOSE) return;
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					_ui.state = InventoryUI.DECOMPOSE;
					refreshInventoryUI();
					break;
				
				case InventoryEvent.ITEM_USE:
					if(_selectedItem == -1) return;
					useItem(_selectedItem);
					break;
				
				case InventoryEvent.ITEM_DUMP:
					if(_selectedItem == -1) return;
					removeItemAt(_selectedItem);
					break;
				
				case InventoryEvent.ITEM_CRAFT:
					if(_selectedItem == -1 || !craftable(_selectedItem)) return;
					craftItem(_selectedItem);
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					refreshInventoryUI();
					break;
				
				case InventoryEvent.ITEM_DECOMPOSE:
					if(_selectedItem == -1 || decomposeIndex(_inventory.itemAt(_selectedItem).itemCode) == -1) return;
					decomposeItem(_selectedItem);
					_ui.removeSelect(_selectedItem);
					_prevSelectedItem = _selectedItem = -1
					refreshInventoryUI();
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
		
		private function decomposeIndex(itemCode:int):int {
			var ret:int = -1, i:int;
			for(i = 0; i < ItemDB.getNumDecomposeRecipe(); i++){
				if(itemCode == ItemDB.getDecomposeRecipeAt(i).itemCode){
					ret = i;
					break;
				}
			}
			
			return ret;
		}
		
		private function useItem(index:int):void {
			if(_inventory.itemAt(index).itemClass != ItemDB.CONSUMABLE) return;
			var item:Consumable = Consumable(_inventory.itemAt(index).data);
			Game.currentGame.statusManager.add(StatusManager.CUR_HP, item.hp);
			Game.currentGame.statusManager.add(StatusManager.CUR_ST, item.st);
			removeItemAt(index);
		}
		
		private function craftItem(index:int):void {
			var i:int, j:int, data:CraftData, count;
			data = ItemDB.getCraftRecipeAt(index);
			for(i = 0; i < data.recipe.length; i++){
				count = data.recipe[i].y;
				for(j = 0; j < _inventory.numItems; j++){
					if(data.recipe[i].x == _inventory.itemAt(j).itemCode){
						if(_inventory.itemAt(j).number < count){
							count = count - _inventory.itemAt(j).number;
							removeItemAt(j, _inventory.itemAt(j).number);
							j -= 1;
						} else {
							removeItemAt(j, count);
							break;
						}						
					}
				}
			}
			achieveItem(data.itemCode);
		}
		
		private function decomposeItem(index:int):void {
			var i:int, data:DecomposeData;
			if(decomposeIndex(_inventory.itemAt(index).itemCode) == -1) throw new IllegalOperationError("잘못된 분해입니다");
			data = ItemDB.getDecomposeRecipeAt(decomposeIndex(_inventory.itemAt(index).itemCode));
			
			for(i = 0; i < data.recipe.length; i++) achieveItem(data.recipe[i].x, data.recipe[i].y);
			
			removeItemAt(index);
		}
		
		public function inventoryUIOnOff():void {
			_ui.visible = !_ui.visible;
			_prevSelectedItem = _selectedItem = -1;
			_ui.state = InventoryUI.INVENTORY;
			if(_ui.visible) refreshInventoryUI();
		}
		
		public function refreshInventoryUI():void {
			var i:int, j:int, numItems:Array, count:Array, data:ItemData, curY:int, itemClass:uint;
			_ui.selectItem(_prevSelectedItem, _selectedItem);
			numItems = [0, 0, 0, 0];
			count = [0, 0, 0, 0];
			
			_ui.classificationBars[0].visible = _ui.classificationBars[1].visible = _ui.classificationBars[2].visible = _ui.classificationBars[3].visible = false;
			
			for(i = 0; i < ItemDB.getNumCraftRecipe()+ItemDB.getNumDecomposeRecipe(); i++)
				_ui.recipeField.recipes[i].clip.visible = false;
			
			if(_ui.state == InventoryUI.INVENTORY){
				//state == inventory
				//count 정리
				for(i = 0; i < _inventory.numItems; i++){
					numItems[_inventory.itemAt(i).itemClass] += 1;
					_ui.classificationBars[_inventory.itemAt(i).itemClass].visible = true;
				}
				
				curY = 0;
				_ui.classificationBars[0].y = curY;
				if(numItems[0] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[0]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[1].y = curY;
				if(numItems[1] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[1]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[2].y = curY;
				if(numItems[2] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[2]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[3].y = curY;
				if(numItems[3] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[3]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[4].y = curY;
				
				for(i = 0; i < _inventory.numItems; i++){
					itemClass = _inventory.itemAt(i).itemClass;
					_ui.items[i].clip.visible = true;
					_ui.items[i].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+(count[itemClass]%InventoryUI.MAX_XNUM));
					_ui.items[i].clip.y = _ui.classificationBars[itemClass].y + _ui.classificationBars[0].height + InventoryUI.ITEM_HEIGHT*1.25*(1/2+int(count[itemClass]/InventoryUI.MAX_XNUM));
					count[itemClass] += 1;
					if(_inventory.itemAt(i).itemClass == ItemDB.CONSUMABLE || _inventory.itemAt(i).itemClass == ItemDB.MATERIAL) _ui.items[i].tf.text = _inventory.itemAt(i).number;
					else if(_inventory.itemAt(i).itemClass == ItemDB.TOOL){
						_ui.items[i].bar.visible = true;
						_ui.items[i].bar.bar.width = _ui.items[i].bar.width * Number(_inventory.itemAt(i).curDurability/_inventory.itemAt(i).maxDurability);
						_ui.items[i].tf.text = "";
					} else _ui.items[i].tf.text = "";
					
					if(i == _selectedItem){
						_ui.description = descriptionForUI(_inventory.itemAt(i));
					}
				}
				var stm:StatusManager = Game.currentGame.statusManager;
				_ui.statusText = "HP : "+stm.getStatus(StatusManager.CUR_HP)+"/"+stm.getStatus(StatusManager.MAX_HP)+"\n"
								+"ST : "+stm.getStatus(StatusManager.CUR_ST)+"/"+stm.getStatus(StatusManager.MAX_ST)+"\n"
								+"ATK : "+stm.getStatus(StatusManager.ATK)+"\n"
								+"DEF : "+stm.getStatus(StatusManager.DEF)+"\n"
								+"Weight : "+_inventory.totalWeight+"/"+_inventory.maxWeight;
				
			} else if(_ui.state == InventoryUI.CRAFT){
				//state == craft
				//count 정리
				for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
					if((_viewPossibleOnly && craftable(i)) || !_viewPossibleOnly){
						numItems[ItemDB.getItem(ItemDB.getCraftRecipeAt(i).itemCode).itemClass] += 1;
						_ui.classificationBars[ItemDB.getItem(ItemDB.getCraftRecipeAt(i).itemCode).itemClass].visible = true;
					}
				}
				
				curY = 0;
				_ui.classificationBars[0].y = curY;
				if(numItems[0] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[0]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[1].y = curY;
				if(numItems[1] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[1]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[2].y = curY;
				if(numItems[2] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[2]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[3].y = curY;
				if(numItems[3] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[3]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[4].y = curY;
				
				for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
					itemClass = ItemDB.getItem(ItemDB.getCraftRecipeAt(i).itemCode).itemClass;
					if((_viewPossibleOnly && craftable(i)) || !_viewPossibleOnly){
						_ui.craftItems[i].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+(count[itemClass]%InventoryUI.MAX_XNUM));
						_ui.craftItems[i].clip.y = _ui.classificationBars[itemClass].y + _ui.classificationBars[0].height + InventoryUI.ITEM_HEIGHT*1.25*(1/2+int(count[itemClass]/InventoryUI.MAX_XNUM));
						_ui.craftItems[i].clip.visible = true;
						if(itemClass == ItemDB.TOOL) _ui.craftItems[i].bar.visible = false;
						count[itemClass] += 1;
						if(i == _selectedItem){
							_ui.recipeField.recipes[i].clip.visible = true;
							data = ItemDB.getItem(ItemDB.getCraftRecipeAt(i).itemCode);
							_ui.description = descriptionForUI(null, data);
							for(j = 0; j < ItemDB.getCraftRecipeAt(i).recipe.length; j++){
								_ui.recipeField.recipes[i].vec[j].tf.text = numItem(ItemDB.getCraftRecipeAt(i).recipe[j].x)+"/"+ItemDB.getCraftRecipeAt(i).recipe[j].y;
							}
						}
					} else _ui.craftItems[i].clip.visible = false;
				}
				_ui.setCheckButton(_viewPossibleOnly);
			} else {
				//state == decompose
				//count 정리
				for(i = 0; i < _inventory.numItems; i++){
					if(decomposeIndex(_inventory.itemAt(i).itemCode) != -1){
						numItems[_inventory.itemAt(i).itemClass] += 1;
						_ui.classificationBars[_inventory.itemAt(i).itemClass].visible = true;
					}
				}
				
				curY = 0;
				_ui.classificationBars[0].y = curY;
				if(numItems[0] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[0]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[1].y = curY;
				if(numItems[1] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[1]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[2].y = curY;
				if(numItems[2] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[2]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[3].y = curY;
				if(numItems[3] != 0) curY += _ui.classificationBars[0].height+InventoryUI.ITEM_HEIGHT*1.25*(1+int((numItems[3]-1)/InventoryUI.MAX_XNUM));
				_ui.classificationBars[4].y = curY;
				
				for(i = 0; i < _inventory.numItems; i++){
					if(decomposeIndex(_inventory.itemAt(i).itemCode) != -1){
						itemClass = _inventory.itemAt(i).itemClass;
						_ui.items[i].clip.visible = true;
						_ui.items[i].clip.x = InventoryUI.ITEM_WIDTH*1.25*(1/2+(count[itemClass]%InventoryUI.MAX_XNUM));
						_ui.items[i].clip.y = _ui.classificationBars[itemClass].y + _ui.classificationBars[0].height + InventoryUI.ITEM_HEIGHT*1.25*(1/2+int(count[itemClass]/InventoryUI.MAX_XNUM));
						count[itemClass] += 1;
					} else _ui.items[i].clip.visible = false;
					
					if(_inventory.itemAt(i).itemClass == ItemDB.CONSUMABLE || _inventory.itemAt(i).itemClass == ItemDB.MATERIAL) _ui.items[i].tf.text = _inventory.itemAt(i).number;
					else if(_inventory.itemAt(i).itemClass == ItemDB.TOOL){
						_ui.items[i].bar.visible = true;
						_ui.items[i].bar.bar.width = _ui.items[i].bar.width * Number(_inventory.itemAt(i).curDurability/_inventory.itemAt(i).maxDurability);
						_ui.items[i].tf.text = "";
					} else _ui.items[i].tf.text = "";
					
					if(i == _selectedItem){
						_ui.recipeField.recipes[ItemDB.getNumCraftRecipe()+decomposeIndex(_inventory.itemAt(i).itemCode)].clip.visible = true;
						_ui.description = descriptionForUI(_inventory.itemAt(i));
					}
				}
			}
			if(_selectedItem == -1) _ui.description = "\n\n\n\n선택된 아이템이 없습니다.\n아이템 설명을 보려면 아이템을 클릭하여 선택해 주세요.";
		}
		
		private function descriptionForUI(info:ItemInfo, itemData:ItemData = null):String {
			var mid:String, data:ItemData;
			if(info != null) data = info.data;
			else data = itemData;
			
			mid = "무게 : "+data.weight+", ";
			if(data.itemClass == ItemDB.CONSUMABLE){
				if(Consumable(data).hp != 0) mid += "체력 +"+Consumable(data).hp+", ";
				if(Consumable(data).st != 0) mid += "스테미너 +"+Consumable(data).st+", ";
			} else if(data.itemClass == ItemDB.TOOL){
				if(info != null) mid += "내구도 : "+info.curDurability+"/"+info.maxDurability+", ";
				else mid += "내구도 : "+Tool(data).durability+", ";
			}
			else if(data.itemClass == ItemDB.EQUIPMENT){
				mid += "부위 : "+Equipment(data).part+", ";
				if(Equipment(data).part == ItemDB.WEAPON) mid += "무기 종류 : "+Equipment(data).weaponType+", ";
				if(Equipment(data).hp != 0) mid += "최대 체력 +"+Equipment(data).hp+", ";
				if(Equipment(data).st != 0) mid += "최대 스테미너 +"+Equipment(data).st+", ";
				if(Equipment(data).atk != 0) mid += "공격력 +"+Equipment(data).atk+", ";
				if(Equipment(data).def != 0) mid += "방어력 +"+Equipment(data).def+", ";
			}
			mid = mid.substr(0, mid.length-2);
			return data.itemName+"|"+mid+"|"+data.description;
		}
		
		public function numItem(itemCode:int):int {
			//return amount of item which has itemcode of itemCode. if any, return 0
			var i:int, num:int = 0;
			for(i = 0; i < _inventory.numItems; i++){
				if(_inventory.itemAt(i).itemCode == itemCode){
					num += _inventory.itemAt(i).number;
				}
			}
			return num;
		}
		
		public function achieveItem(code:int, amount:int = 1):void {
			//item 획득
			var flag:Boolean = true, info:ItemInfo, itemClass:uint, i:int;
			itemClass = ItemDB.getItem(code).itemClass;
			if(itemClass == ItemDB.EQUIPMENT || itemClass == ItemDB.TOOL){
				for(i = 0; i < amount; i++){
					info = new ItemInfo(ItemDB.getItem(code), 1);
					if(itemClass == ItemDB.TOOL) info.curDurability = info.maxDurability;
					_ui.items.push(_ui.newItem(info.clip, info.itemClass));
					_inventory.addItem(info);
					_ui.itemField.addChild(_ui.items[_inventory.numItems-1].clip);
					_ui.items[_inventory.numItems-1].btn.addEventListener(MouseEvent.CLICK, clickHandler);
				}
			} else {
				for(i = 0; i < _inventory.numItems; i++){
					if(_inventory.itemAt(i).itemCode == code){
						_inventory.addAmountAt(i, amount);
						flag = false;
						break;
					}
				}
				if(flag){
					info = new ItemInfo(ItemDB.getItem(code), amount);
					_ui.items.push(_ui.newItem(info.clip, info.itemClass));
					_inventory.addItem(info);
					_ui.itemField.addChild(_ui.items[i].clip);
					_ui.items[i].btn.addEventListener(MouseEvent.CLICK, clickHandler);
				}
			}
			if(_ui.visible) refreshInventoryUI();
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
