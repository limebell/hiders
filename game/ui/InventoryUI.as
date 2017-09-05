package game.ui {
	import game.db.FontDB;
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import game.core.Game;
	import game.event.InventoryEvent;
	import game.db.ItemDB;
	import system.StageInfo;
	import flash.geom.Point;
	
	public class InventoryUI extends MovieClip {
		public static const
		INVENTORY:String = "inventory",
		CRAFT:String = "craft",
		DECOMPOSE:String = "decompose",
		CONSUME:String = "consume",
		EQUIP:String = "equip",
		UNEQUIP:String = "unequip",
		ITEM_WIDTH:int = 25,
		ITEM_HEIGHT:int = 25,
		MAX_XNUM:int = 11;
		
		private var _state:String;
		
		private var _wasCrafting:Boolean;
		
		private var _clip:MovieClip;
		private var _typeText:TextField;
		private var _inventoryButton:Object;
		private var _craftButton:Object;
		private var _decomposeButton:Object;
		private var _useButton:Object;
		private var _dumpSmallButton:Object;
		private var _dumpBigButton:Object;
		private var _craftConfirmButton:Object;
		private var _decomposeConfirmButton:Object;
		private var _equipButton:Object;
		private var _unequipButton:Object;
		private var _textFormat:TextFormat;
		
		private var _explanationText:TextField;
		private var _itemField:MovieClip;
		private var _classificationBars:Vector.<MovieClip>;
		private var _craftField:MovieClip;
		private var _fieldMask:MovieClip;
		private var _equipField:Object;
		private var _possibleOnly:Object;
		private var _recipeField:Object;
		private var _items:Vector.<Object>;
		private var _craftItems:Vector.<Object>;
		private var _equipingItems:Array;

		public function InventoryUI() {
			_clip = new inventoryUIClip();
			
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 20, 0xffffff);
			
			_typeText = new TextField();
			_typeText.defaultTextFormat = _textFormat;
			_typeText.x = -220;
			_typeText.y = -140;
			_typeText.mouseEnabled = false;
			_typeText.width = 150;
			
			_textFormat.size = 10;
			_textFormat.align = "center";
			_textFormat.leading = 1;
			
			_inventoryButton = newButton("인벤토리", -225, -20, 50);
			_craftButton = newButton("조합", -175, -20, 50);
			_decomposeButton = newButton("분해", -125, -20, 50);
			_useButton = newButton("사용하기", 125, 105, 50);
			_dumpSmallButton = newButton("버리기", 175, 105, 50);
			_dumpBigButton = newButton("버리기", 125, 105, 100);
			_craftConfirmButton = newButton("조합하기", 125, 105, 100);
			_decomposeConfirmButton = newButton("분해하기", 125, 105, 100);
			_equipButton = newButton("장착하기", 125, 105, 50);
			_unequipButton = newButton("해제하기", 125, 105, 100);
			
			_explanationText = new TextField();
			_textFormat.align = "left";
			_textFormat.size = 10;
			_explanationText.defaultTextFormat = _textFormat;
			_explanationText.width = 100;
			_explanationText.height = 105;
			_explanationText.mouseEnabled = false;
			_explanationText.wordWrap = true;
			_explanationText.x = 125;
			
			_itemField = new MovieClip();
			_itemField.x = -225;
			_fieldMask = new MovieClip();
			_fieldMask.graphics.beginFill(0xffffff);
			_fieldMask.graphics.drawRect(0, 0, 348, 123);
			_fieldMask.x = -224;
			_fieldMask.y = 1;
			_items = new Vector.<Object>();
			_classificationBars = new Vector.<MovieClip>();
			_classificationBars.push(new classificationClip());
			_classificationBars.push(new classificationClip());
			_classificationBars.push(new classificationClip());
			_classificationBars.push(new classificationClip());
			_classificationBars.push(new classificationClip());
			_classificationBars.push(new classificationClip());
			_classificationBars[0].tf.text = "Consumable";
			_classificationBars[1].tf.text = "Tool";
			_classificationBars[2].tf.text = "Equipment";
			_classificationBars[3].tf.text = "Material";
			_classificationBars[4].tf.text = "Placeable";
			_classificationBars[5].tf.text = "null";
			_classificationBars[0].visible = _classificationBars[1].visible = _classificationBars[2].visible = _classificationBars[3].visible = _classificationBars[4].visible = _classificationBars[5].visible = false;
			
			_craftField = new MovieClip();
			_craftField.x = -225;
			_craftItems = new Vector.<Object>();
			
			_equipField = new Object();
			_equipField.clip = new MovieClip();
			_equipField.human = new human();
			_equipField.head = newEquipField(0, -45);
			_equipField.body = newEquipField(0, -5);
			_equipField.weapon = newEquipField(35, 5);
			_equipField.leg = newEquipField(0, 50);
			_equipField.statusText = new TextField();
			_equipField.statusText.mouseEnabled = false;
			_textFormat.align = "left";
			_textFormat.size = 8;
			_equipField.statusText.defaultTextFormat = _textFormat;
			_equipField.statusText.x = -200;
			_equipField.statusText.y = -20;
			_equipField.statusText.width = 150;
			_equipField.statusText.height = 60;
			_equipField.clip.y = -75;
			_equipField.clip.addChild(_equipField.statusText);
			_equipField.clip.addChild(_equipField.human);
			_equipField.clip.addChild(_equipField.head);
			_equipField.clip.addChild(_equipField.body);
			_equipField.clip.addChild(_equipField.weapon);
			_equipField.clip.addChild(_equipField.leg);
			_equipField.clip.visible = false;
			
			_equipingItems = new Array();
			
			_possibleOnly = new Object();
			_possibleOnly.clip = new MovieClip();
			_possibleOnly.tf = new TextField();
			_textFormat.align = "left";
			_textFormat.size = 8;
			_possibleOnly.tf.defaultTextFormat = _textFormat;
			_possibleOnly.tf.width = 90;
			_possibleOnly.tf.y = -2;
			_possibleOnly.tf.mouseEnabled = false;
			_possibleOnly.tf.text = "조합 가능한 아이템만 보기";
			_possibleOnly.checkBox = new checkBox();
			_possibleOnly.checkBox.x = _possibleOnly.tf.width;
			_possibleOnly.checkBox.y = _possibleOnly.checkBox.height/2;
			_possibleOnly.clip.x = 30;
			_possibleOnly.clip.y = -10;
			_possibleOnly.clip.addChild(_possibleOnly.tf);
			_possibleOnly.clip.addChild(_possibleOnly.checkBox);
			_possibleOnly.checkBox.addEventListener(MouseEvent.CLICK, clickHandler);
			_possibleOnly.clip.visible = false;
			
			_recipeField = new Object();
			_recipeField.clip = new MovieClip();
			_recipeField.clip.graphics.lineStyle(1, 0xffffff);
			_recipeField.clip.graphics.drawRect(0, 0, 200, 30);
			_recipeField.clip.x = -100;
			_recipeField.clip.y = -75;
			_recipeField.tf = new TextField();
			_textFormat.align = "left";
			_textFormat.size = 10;
			_recipeField.tf.defaultTextFormat = _textFormat;
			_recipeField.tf.autoSize = "left";
			_recipeField.tf.mouseEnabled = false;
			_recipeField.tf.y = -14;
			_recipeField.recipes = new Vector.<Object>;
			_recipeField.clip.addChild(_recipeField.tf);
			_recipeField.clip.visible = false;
			
			this.addChild(_clip);
			this.addChild(_typeText);
			this.addChild(_inventoryButton.clip);
			this.addChild(_craftButton.clip);
			this.addChild(_decomposeButton.clip);
			this.addChild(_useButton.clip);
			this.addChild(_dumpSmallButton.clip);
			this.addChild(_dumpBigButton.clip);
			this.addChild(_craftConfirmButton.clip);
			this.addChild(_decomposeConfirmButton.clip);
			this.addChild(_equipButton.clip);
			this.addChild(_unequipButton.clip);
			
			this.addChild(_explanationText);
			this.addChild(_equipField.clip);
			this.addChild(_possibleOnly.clip);
			this.addChild(_recipeField.clip);
			this.addChild(_itemField);
			this.addChild(_craftField);
			this.addChild(_fieldMask);
			
			this.state = INVENTORY;
		}
		
		private function newButton(t:String, x:int, y:int, width:int):Object {
			var obj:Object = new Object();
			obj.clip = new MovieClip();
			obj.clip.graphics.lineStyle(1, 0xffffff);
			obj.clip.graphics.drawRect(0, 0, width, 20);
			obj.clip.x = x;
			obj.clip.y = y;
			obj.tf = new TextField();
			obj.tf.defaultTextFormat = _textFormat;
			obj.tf.mouseEnabled = false;
			obj.tf.width = width;
			obj.tf.height = 18;
			obj.tf.y = 2.5;
			obj.tf.text = t;
			obj.btn = new button();
			obj.btn.width = width;
			obj.btn.height = 20;
			obj.btn.x = obj.btn.width/2;
			obj.btn.y = obj.btn.height/2;
			obj.clip.addChild(obj.tf);
			obj.clip.addChild(obj.btn);
			obj.btn.addEventListener(MouseEvent.CLICK, clickHandler);
			return obj;
		}
		
		private function newEquipField(x:int, y:int):MovieClip {
			var mc:MovieClip = new MovieClip();
			mc.graphics.lineStyle(1, 0xffffff);
			mc.graphics.drawRect(-15, -15, 30, 30);
			mc.x = x;
			mc.y = y;
			return mc;
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _inventoryButton.btn:
					if(_state == INVENTORY) return;
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_INVENTORY));
					break;
				case _craftButton.btn:
					if(_state == CRAFT) return;
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_CRAFT));
					break;
				case _decomposeButton.btn:
					if(_state == DECOMPOSE) return;
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_DECOMPOSE));
					break;
				case _useButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_USE));
					break;
				case _dumpSmallButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_DUMP));
					break;
				case _dumpBigButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_DUMP));
					break;
				case _craftConfirmButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_CRAFT));
					break;
				case _decomposeConfirmButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_DECOMPOSE));
					break;
				case _equipButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_EQUIP));
					break;
				case _unequipButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_UNEQUIP));
					break;
				case _possibleOnly.checkBox:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.CHECKBOX));
					break;
			}
		}
		
		private function wheelHandler(e:MouseEvent):void {
			if(e.stageX >= 77 && e.stageX <= 355 && e.stageY >= 145 && e.stageY <= 244){
				if(_state == INVENTORY || _state == DECOMPOSE){
					if(_itemField.height <= _fieldMask.height) return;
					else {
						_itemField.y += e.delta*10;
						if(_itemField.y > 0) _itemField.y = 0;
						if(_itemField.y + _itemField.height - _classificationBars[0].height < _fieldMask.height) _itemField.y = _fieldMask.height - _itemField.height + _classificationBars[0].height;
					}
				} else {
					
				}
			}
		}
		
		public function newItem(clip:MovieClip, itemClass:uint):Object {
			var obj:Object = new Object();
			obj.clip = clip;
			obj.btn = new button();
			obj.btn.width = obj.btn.height = 25;
			obj.select = new MovieClip();
			obj.select.graphics.lineStyle(1, 0xfcf291);
			obj.select.graphics.drawRect(-14, -14, 28, 28);
			obj.select.visible = false;
			obj.tf = new TextField();
			obj.tf.mouseEnabled = false;
			_textFormat.align = "right";
			_textFormat.size = 8;
			obj.tf.x = -10;
			obj.tf.y = 4;
			obj.tf.width = 25;
			obj.tf.height = 12;
			obj.tf.defaultTextFormat = _textFormat;
			if(itemClass == ItemDB.TOOL){
				obj.bar = new durabilityClip();
				obj.bar.y = 12.5;
				obj.clip.addChild(obj.bar);
			}
			obj.clip.addChild(obj.tf);
			obj.clip.addChild(obj.btn);
			obj.clip.addChild(obj.select);
			return obj;
		}
		
		public function selectItem(prev:Point, index:Point):void {
			removeSelect(prev);
			if(index != null){
				if(_state == INVENTORY){
					if(index.x == 0){
						_items[index.y].select.visible = true;
					} else _equipingItems[index.y].select.visible = true;
				} else if(_state == CRAFT){
					_craftItems[index.y].select.visible = true;
				} else _items[index.y].select.visible = true;
			}
		}
		
		public function removeSelect(tar:Point):void {
			if(tar != null){
				if(_state == INVENTORY){
					if(tar.x == 0){
						_items[tar.y].select.visible = false;
					} else _equipingItems[tar.y].select.visible = false;
				} else if(_state == CRAFT){
					_craftItems[tar.y].select.visible = false;
				}
				else _items[tar.y].select.visible = false;
			}
		}
		
		public function setCheckButton(bool:Boolean):void {
			if(bool) _possibleOnly.checkBox.gotoAndStop("on");
			else _possibleOnly.checkBox.gotoAndStop("off");
		}
		
		public function setButton(tar:String = null):void {
			_useButton.clip.visible = false;
			_dumpSmallButton.clip.visible = false;
			_dumpBigButton.clip.visible = false;
			_craftConfirmButton.clip.visible = false;
			_decomposeConfirmButton.clip.visible = false;
			_equipButton.clip.visible = false;
			_unequipButton.clip.visible = false;
			switch(tar){
				case CONSUME:
					_useButton.clip.visible = true;
					_dumpSmallButton.clip.visible = true;
					break;
				case INVENTORY:
					_dumpBigButton.clip.visible = true;
					break;
				case CRAFT:
					_craftConfirmButton.clip.visible = true;
					break;
				case DECOMPOSE:
					_decomposeConfirmButton.clip.visible = true;
					break;
				case EQUIP:
					_equipButton.clip.visible = true;
					_dumpSmallButton.clip.visible = true;
					break;
				case UNEQUIP:
					_unequipButton.clip.visible = true;
					break;
			}
		}
		
		public function on():void {
			StageInfo.stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		public function off():void {
			StageInfo.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		public function get itemField():MovieClip {
			return _itemField;
		}
		
		public function get equipField():Object {
			return _equipField;
		}
		
		public function get craftField():Object {
			return _craftField;
		}
		
		public function get items():Vector.<Object> {
			return _items;
		}
		
		public function get craftItems():Vector.<Object> {
			return _craftItems;
		}
		
		public function get equipingItems():Array {
			return _equipingItems;
		}
		
		public function get recipeField():Object {
			return _recipeField;
		}
		
		public function get classificationBars():Vector.<MovieClip> {
			return _classificationBars;
		}
		
		public function get state():String {	
			return _state;
		}
		
		public function statusText(text:String, weightText:String, level:int):void {
			var tempTF:TextFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 8);
			tempTF.align = "left";
			
			_equipField.statusText.text = text + weightText;
			switch(level){
				case 0:
					tempTF.color = 0xffffff;
					break;
				case 1:
					tempTF.color = 0xffdd00;
					break;
				case 2:
					tempTF.color = 0xff8800;
					break;
				case 3:
					tempTF.color = 0xff0000;
					break;
			}
			_equipField.statusText.setTextFormat(tempTF, text.length, _equipField.statusText.length);
		}
		
		public function set description(text:String):void {
			var i:int, j:int, t:int = 0, temp1:String, temp2:String, temp3:String, numBars:int = 0;
			
			for(i = 0; i < text.length; i++){
				if(text.charAt(i) == "|") numBars++;
			}
			
			switch(numBars){
				case 0:
					_explanationText.text = text;
					_textFormat.align = "center";
					_textFormat.size = 8;
					_explanationText.setTextFormat(_textFormat, 0, text.length-1);
					break;
				
				case 1:
					for(i = 0; i < text.length; i++){
						if(text.charAt(i) == "|"){
							temp1 = text.substr(0, i);
							temp2 = text.substr(i+1, text.length-i-1);
							break;
						}
					}
					_explanationText.text = temp1+"\n"+temp2;
					_textFormat.align = "left";
					_textFormat.size = 8;
					_explanationText.setTextFormat(_textFormat, temp1.length+1, _explanationText.length-1);
					break;
					
				case 2:
					for(i = 0; i < text.length; i++){
						if(text.charAt(i) == "|"){
							temp1 = text.substr(0, i);
							break;
						}
					}
					for(j = i+1; j < text.length; j++){
						if(text.charAt(j) == "|"){
							temp2 = text.substr(i+1, j-i-1);
							temp3 = text.substr(j+1, text.length-j-1);
							break;
						}
					}
					_explanationText.text = temp1+"\n"+temp2+"\n"+temp3;
					_textFormat.align = "left";
					_textFormat.size = 6;
					_explanationText.setTextFormat(_textFormat, temp1.length+1, temp1.length+temp2.length+1);
					_textFormat.size = 8;
					_explanationText.setTextFormat(_textFormat, temp1.length+temp2.length+2, _explanationText.length-1);
					break;
			}
		}
		
		public function set state(t:String):void {
			switch(t){
				case INVENTORY:
					_itemField.y = 0;
					_typeText.text = "Inventory";
					_itemField.visible = true;
					_craftField.visible = false;
					_equipField.clip.visible = true;
					_possibleOnly.clip.visible = false;
					_recipeField.clip.visible = false;
					_itemField.mask = _fieldMask;
					_itemField.addChild(_classificationBars[0]);
					_itemField.addChild(_classificationBars[1]);
					_itemField.addChild(_classificationBars[2]);
					_itemField.addChild(_classificationBars[3]);
					_itemField.addChild(_classificationBars[4]);
					_itemField.addChild(_classificationBars[5]);
					break;
				case CRAFT:
					_craftField.y = 0;
					_typeText.text = "Crafting";
					_itemField.visible = false;
					_craftField.visible = true;
					_equipField.clip.visible = false;
					_possibleOnly.clip.visible = true;
					_recipeField.tf.text = "조합에 필요한 재료(소지/필요)";
					_recipeField.clip.visible = true;
					_craftField.mask = _fieldMask;
					_craftField.addChild(_classificationBars[0]);
					_craftField.addChild(_classificationBars[1]);
					_craftField.addChild(_classificationBars[2]);
					_craftField.addChild(_classificationBars[3]);
					_craftField.addChild(_classificationBars[4]);
					_craftField.addChild(_classificationBars[5]);
					break;
				case DECOMPOSE:
					_itemField.y = 0;
					_typeText.text = "Decomposition";
					_itemField.visible = true;
					_craftField.visible = false;
					_equipField.clip.visible = false;
					_possibleOnly.clip.visible = false;
					_recipeField.tf.text = "분해 시 얻을 수 있는 재료";
					_recipeField.clip.visible = true;
					_itemField.mask = _fieldMask;
					_itemField.addChild(_classificationBars[0]);
					_itemField.addChild(_classificationBars[1]);
					_itemField.addChild(_classificationBars[2]);
					_itemField.addChild(_classificationBars[3]);
					_itemField.addChild(_classificationBars[4]);
					_itemField.addChild(_classificationBars[5]);
					break;
			}
			_state = t;
			setButton();
		}

	}
	
}
