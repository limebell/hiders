package game.ui {
	import game.db.FontDB;
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import game.core.Game;
	import game.event.InventoryEvent;
	
	public class InventoryUI extends MovieClip {
		public static const
		INVENTORY:String = "inventory",
		CRAFT:String = "craft",
		DISMANTLE:String = "dismantle",
		ITEM_WIDTH:int = 50,
		ITEM_HEIGHT:int = 50,
		MAX_XNUM:int = 11;
		
		private var _state:String;
		
		private var _wasCrafting:Boolean;
		
		private var _clip:MovieClip;
		private var _typeText:TextField;
		private var _inventoryButton:Object;
		private var _craftButton:Object;
		private var _dismantleButton:Object;
		private var _useButton:Object;
		private var _dumpButton:Object;
		private var _craftConfirmButton:Object;
		private var _dumpConfirmButton:Object;
		private var _closeButton:MovieClip;
		private var _textFormat:TextFormat;
		
		private var _explanationText:TextField;
		private var _itemField:MovieClip;
		private var _craftField:MovieClip;
		private var _fieldMask:MovieClip;
		private var _equipField:Object;
		private var _possibleOnly:Object;
		private var _recipeField:Object;
		private var _items:Vector.<Object>;
		private var _craftItems:Vector.<Object>;

		public function InventoryUI() {
			_clip = new inventoryUIClip();
			
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 40, 0xffffff);
			
			_typeText = new TextField();
			_typeText.defaultTextFormat = _textFormat;
			_typeText.x = -480;
			_typeText.y = -285;
			_typeText.mouseEnabled = false;
			_typeText.width = 300;
			
			_textFormat.size = 20;
			_textFormat.align = "center";
			_textFormat.leading = 2;
			
			_inventoryButton = newButton("인벤토리", -450, -40);
			_craftButton = newButton("조합", -350, -40);
			_dismantleButton = newButton("분해", -250, -40);
			_useButton = newButton("사용하기", 250, 210);
			_dumpButton = newButton("버리기", 350, 210);
			_craftConfirmButton = newButton("조합하기", 250, 210, 200);
			_dumpConfirmButton = newButton("분해하기", 250, 210, 200);
			
			_closeButton = new button();
			_closeButton.width = _closeButton.height = 50;
			_closeButton.x = 475;
			_closeButton.y = -275
			_closeButton.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_explanationText = new TextField();
			_textFormat.align = "left";
			_textFormat.size = 20;
			_explanationText.defaultTextFormat = _textFormat;
			_explanationText.width = 200;
			_explanationText.height = 210;
			_explanationText.mouseEnabled = false;
			_explanationText.wordWrap = true;
			_explanationText.x = 250;
			
			_itemField = new MovieClip();
			_itemField.x = -450;
			_fieldMask = new MovieClip();
			_fieldMask.graphics.beginFill(0xffffff);
			_fieldMask.graphics.drawRect(0, 0, 700, 250);
			_fieldMask.x = -450;
			_itemField.mask = _fieldMask;
			_items = new Vector.<Object>();
			
			_craftField = new MovieClip();
			_craftField.x = -450;
			_craftField.mask = _fieldMask;
			_craftItems = new Vector.<Object>();
			
			_equipField = new Object();
			_equipField.clip = new MovieClip();
			_equipField.human = new human();
			_equipField.head = newEquipField(-30, -120);
			_equipField.arm = newEquipField(-100, -20);
			_equipField.body = newEquipField(-30, -40);
			_equipField.weapon = newEquipField(40, -20);
			_equipField.leg = newEquipField(-30, 70);
			_equipField.clip.y = -150;
			_equipField.clip.addChild(_equipField.human);
			_equipField.clip.addChild(_equipField.head);
			_equipField.clip.addChild(_equipField.arm);
			_equipField.clip.addChild(_equipField.body);
			_equipField.clip.addChild(_equipField.weapon);
			_equipField.clip.addChild(_equipField.leg);
			_equipField.clip.visible = false;
			
			_possibleOnly = new Object();
			_possibleOnly.clip = new MovieClip();
			_possibleOnly.tf = new TextField();
			_textFormat.align = "left";
			_textFormat.size = "15";
			_possibleOnly.tf.defaultTextFormat = _textFormat;
			_possibleOnly.tf.width = 175;
			_possibleOnly.tf.mouseEnabled = false;
			_possibleOnly.tf.text = "조합 가능한 아이템만 보기";
			_possibleOnly.checkBox = new checkBox();
			_possibleOnly.checkBox.x = _possibleOnly.tf.width;
			_possibleOnly.checkBox.y = _possibleOnly.checkBox.height/2;
			_possibleOnly.clip.x = 65;
			_possibleOnly.clip.y = -20;
			_possibleOnly.clip.addChild(_possibleOnly.tf);
			_possibleOnly.clip.addChild(_possibleOnly.checkBox);
			_possibleOnly.checkBox.addEventListener(MouseEvent.CLICK, clickHandler);
			_possibleOnly.clip.visible = false;
			
			_recipeField = new Object();
			_recipeField.clip = new MovieClip();
			_recipeField.clip.graphics.lineStyle(1, 0xffffff);
			_recipeField.clip.graphics.drawRect(0, 0, 400, 60);
			_recipeField.clip.x = -200;
			_recipeField.clip.y = -150;
			_recipeField.tf = new TextField();
			_textFormat.align = "left";
			_textFormat.size = "20";
			_recipeField.tf.defaultTextFormat = _textFormat;
			_recipeField.tf.autoSize = "left";
			_recipeField.tf.mouseEnabled = false;
			_recipeField.tf.y = -25;
			_recipeField.tf.text = "조합에 필요한 재료(소지/필요)";
			_recipeField.recipes = new Vector.<Object>;
			_recipeField.clip.addChild(_recipeField.tf);
			_recipeField.clip.visible = false;
			
			this.addChild(_clip);
			this.addChild(_typeText);
			this.addChild(_inventoryButton.clip);
			this.addChild(_craftButton.clip);
			this.addChild(_dismantleButton.clip);
			this.addChild(_useButton.clip);
			this.addChild(_dumpButton.clip);
			this.addChild(_craftConfirmButton.clip);
			this.addChild(_dumpConfirmButton.clip);
			
			this.addChild(_explanationText);
			this.addChild(_equipField.clip);
			this.addChild(_possibleOnly.clip);
			this.addChild(_recipeField.clip);
			this.addChild(_itemField);
			this.addChild(_craftField);
			this.addChild(_fieldMask);
			this.addChild(_closeButton);
			
			this.state = INVENTORY;
		}
		
		private function newButton(t:String, x:int, y:int, width:int = 100):Object {
			var obj:Object = new Object();
			obj.clip = new MovieClip();
			obj.clip.graphics.lineStyle(1, 0xffffff);
			obj.clip.graphics.drawRect(0, 0, width, 40);
			obj.clip.x = x;
			obj.clip.y = y;
			obj.tf = new TextField();
			obj.tf.defaultTextFormat = _textFormat;
			obj.tf.mouseEnabled = false;
			obj.tf.width = width;
			obj.tf.y = 7;
			obj.tf.text = t;
			obj.btn = new button();
			obj.btn.width = width;
			obj.btn.height = 40;
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
			mc.graphics.drawRect(0, 0, 60, 60);
			mc.x = x;
			mc.y = y;
			return mc;
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _inventoryButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_INVENTORY));
					break;
				case _craftButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_CRAFT));
					break;
				case _dismantleButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.STATE_DISMANTLE));
					break;
				case _useButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_USE));
					break;
				case _dumpButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_DUMP));
					break;
				case _craftConfirmButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_CRAFT));
					break;
				case _dumpConfirmButton.btn:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_DISMANTLE));
					break;
				case _possibleOnly.checkBox:
					Game.currentGame.itemManager.dispatchEvent(new InventoryEvent(InventoryEvent.CHECKBOX));
					break;
				case _closeButton:
					Game.currentGame.inventoryOnOff();
					break;
			}
		}
		
		public function newItem(clip:MovieClip):Object {
			var obj:Object = new Object();
			obj.clip = clip;
			obj.tf = new TextField();
			obj.tf.mouseEnabled = false;
			_textFormat.align = "right";
			_textFormat.size = 15;
			obj.tf.x = -20;
			obj.tf.y = 10;
			obj.tf.width = 50;
			obj.tf.defaultTextFormat = _textFormat;
			obj.btn = new button();
			obj.btn.width = obj.btn.height = 50;
			obj.select = new MovieClip();
			obj.select.graphics.lineStyle(1, 0xfcf291);
			obj.select.graphics.drawRect(-27, -27, 54, 54);
			obj.select.visible = false;
			obj.clip.addChild(obj.tf);
			obj.clip.addChild(obj.btn);
			obj.clip.addChild(obj.select);
			return obj;
		}
		
		public function selectItem(prev:int, index:int):void {
			if(prev != -1){
				if(_state == CRAFT){
					_craftItems[prev].select.visible = false;
					recipeField.recipes[prev].clip.visible = false;
				}
				else _items[prev].select.visible = false;
			}
			if(index != -1){
				if(_state == CRAFT){
					_craftItems[index].select.visible = true;
					recipeField.recipes[index].clip.visible = true;
				}
				else _items[index].select.visible = true;
			}
		}
		
		public function removeSelect(tar:int):void {
			if(tar != -1){
				if(_state == CRAFT){
					_craftItems[tar].select.visible = false;
					recipeField.recipes[tar].clip.visible = false;
				}
				else _items[tar].select.visible = false;
			}
		}
		
		public function setCheckButton(bool:Boolean):void {
			if(bool) _possibleOnly.checkBox.gotoAndStop("on");
			else _possibleOnly.checkBox.gotoAndStop("off");
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
		
		public function get recipeField():Object {
			return _recipeField;
		}
		
		public function get state():String {
			return _state;
		}
		
		public function set description(text:String):void {
			var i:int, t:int = 0, temp1:String, temp2:String, temp3:String;
			for(i = 0; i < text.length; i++){
				if(text.charAt(i) == "/"){
					temp1 = text.substr(0, i);
					temp2 = text.substr(i+1, text.length-i-1);
					break;
				}
			}
			
			if(i == text.length){
				_explanationText.text = text;
				_textFormat.align = "center";
				_textFormat.size = 15;
				_explanationText.setTextFormat(_textFormat, 0, text.length-1);
			} else {
				_explanationText.text = temp1+"\n"+temp2;
				_textFormat.align = "left";
				_textFormat.size = 15;
				_explanationText.setTextFormat(_textFormat, temp1.length+1, _explanationText.length-1);
			}
		}
		
		public function set state(t:String):void {
			if(_state == t) return;
			switch(t){
				case INVENTORY:
					_typeText.text = "Inventory";
					_useButton.clip.visible = true;
					_dumpButton.clip.visible = true;
					_craftConfirmButton.clip.visible = false;
					_dumpConfirmButton.clip.visible = false;
					_itemField.visible = true;
					_craftField.visible = false;
					_equipField.clip.visible = true;
					_possibleOnly.clip.visible = false;
					_recipeField.clip.visible = false;
					break;
				case CRAFT:
					_typeText.text = "Crafting";
					_useButton.clip.visible = false;
					_dumpButton.clip.visible = false;
					_craftConfirmButton.clip.visible = true;
					_dumpConfirmButton.clip.visible = false;
					_itemField.visible = false;
					_craftField.visible = true;
					_equipField.clip.visible = false;
					_possibleOnly.clip.visible = true;
					_recipeField.clip.visible = true;
					break;
				case DISMANTLE:
					_typeText.text = "Dismantle";
					_useButton.clip.visible = false;
					_dumpButton.clip.visible = false;
					_craftConfirmButton.clip.visible = false;
					_dumpConfirmButton.clip.visible = true;
					_itemField.visible = true;
					_craftField.visible = false;
					_equipField.clip.visible = false;
					_possibleOnly.clip.visible = false;
					_recipeField.clip.visible = true;
					break;
			}
			_state = t;
		}

	}
	
}
