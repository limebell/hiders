package game.ui {	
	import game.db.*;
	import game.core.Game;
	import game.core.StatusManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import game.map.Map;
	
	public class Console extends MovieClip {
		private var _clip:MovieClip;
		private var _outputText:TextField;
		private var _inputText:TextField;
		private var _textFormat:TextFormat;
		private var _msgFormat:TextFormat;
		private var _prevMessage:String;

		public function Console() {
			_clip = new consoleUIClip();
			
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 10, 0xffffff);
			_msgFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun), 10, 0x666666, null, true);
			
			_outputText = new TextField();
			_inputText = new TextField();
			
			_outputText.defaultTextFormat = _inputText.defaultTextFormat = _textFormat;
			_inputText.multiline = false;
			_inputText.type = "input";
			_outputText.selectable = true;
			_outputText.wordWrap = true;
			
			_inputText.restrict = "^`";
			
			_outputText.width = _inputText.width = 450;
			_outputText.height = 225;
			
			_outputText.x = _inputText.x = -225;
			_outputText.y = -127.5;
			_inputText.y = 107.5;
			
			this.addChild(_clip);
			this.addChild(_outputText);
			this.addChild(_inputText);
		}
		
		private function keydownHandler(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.ENTER) push(_inputText.text);
			else if(e.keyCode == Keyboard.UP) getLastMessage();
		}
		
		public function getLastMessage():void {
			if(_prevMessage != null) _inputText.text = _prevMessage;
		}
		
		private function push(t:String):void {
			if(t == "") return;
			_prevMessage = t;
			_outputText.appendText(t+"\n");
			_inputText.text = "";
			analyze(t);
		}
		
		private function analyze(t:String):void {
			var i:int, j:int, script:String, msg:String, loc:int, flag:Boolean, temp1:String, temp2:String, itemData:ItemData, craftData:CraftData, decomposeData:DecomposeData;
			for(i = 0; i < t.length; i++){
				if(t.charAt(i) == "@"){
					script = t.substr(0, i);
					loc = i;
					break;
				}
			}
			
			switch(script){
				case "help":
					msg = "currentLocation@\ncaveLength@\nstatus@\n"+
							"add@target(string),amount(int)\nsub@target(string),amount(int)\nteleportTo@gloc(string)\ngoto@gloc(string),spd(int)\n"+
							"addItem@itemCode(int),amount(int)\nitemList@\ncraftRecipeList@\ndecomposeRecipeList@\nitemInfo@itemCode(int)";
					break;
				
				case "currentLocation":
					msg = "현재 위치는 "+Game.currentGame.mapManager.currentLocation+"입니다.";
					break;
				
				case "caveLength":
					msg = "동굴의 길이는 "+Game.currentGame.mapManager.caveLength+"입니다.";
					break;
				
				case "status":
					msg = Game.currentGame.statusManager.statusForConsole;
					break;
				
				case "add":
					flag = false;
					for(i = loc+1; i < t.length; i++){
						if(t.charAt(i) == ","){
							temp1 = t.substr(loc+1, i-loc-1);
							loc = i;
							flag = true;
							break;
						}
					}
					if(!flag) msg = "명령어의 형식이 잘못되었습니다. add는 두 개의 인수 target(string)과 amount(int)가 필요합니다.";
					else {
						temp2 = t.substr(loc+1, t.length-1);
						if(temp2 == null) msg = "명령어의 형식이 잘못되었습니다. add는 두 개의 인수 target(string)과 amount(int)가 필요합니다.";
						else if(temp2 != String(int(temp2))) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 양의 숫자가 들어가야 합니다.";
						else if((int(temp2)) <= 0) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 0보다 큰 숫자가 들어가야 합니다.";
						else {
							switch(temp1){
								case "HP":
									Game.currentGame.statusManager.add(StatusManager.CUR_HP, int(temp2));
									msg = "현재 체력이 "+temp2+"만큼 증가했습니다.";
									break;
								case "ST":
									Game.currentGame.statusManager.add(StatusManager.CUR_ST, int(temp2));
									msg = "현재 스테미너가 "+temp2+"만큼 증가했습니다.";
									break;
								case "MHP":
									Game.currentGame.statusManager.add(StatusManager.MAX_HP, int(temp2));
									msg = "최대 체력이 "+temp2+"만큼 증가했습니다.";
									break;
								case "MST":
									Game.currentGame.statusManager.add(StatusManager.MAX_ST, int(temp2));
									msg = "최대 스테미너가 "+temp2+"만큼 증가했습니다.";
									break;
								default:
									msg = "명령어의 형식이 잘못되었습니다. target(string)에는 \"HP\", \"ST\", \"MHP\", \"MST\"의 값만 들어갈 수 있습니다.";
									break;
							}
						}
					}
					break;
					
				case "sub":
					flag = false;
					for(i = loc+1; i < t.length; i++){
						if(t.charAt(i) == ","){
							temp1 = t.substr(loc+1, i-loc-1);
							loc = i;
							flag = true;
							break;
						}
					}
					if(!flag) msg = "명령어의 형식이 잘못되었습니다. add는 두 개의 인수 target(string)과 amount(int)가 필요합니다.";
					else {
						temp2 = t.substr(loc+1, t.length-1);
						if(temp2 == null) msg = "명령어의 형식이 잘못되었습니다. add는 두 개의 인수 target(string)과 amount(int)가 필요합니다.";
						else if(temp2 != String(int(temp2))) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 숫자가 들어가야 합니다.";
						else if((int(temp2)) <= 0) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 0보다 큰 숫자가 들어가야 합니다.";
						else {
							switch(temp1){
								case "HP":
									Game.currentGame.statusManager.sub(StatusManager.CUR_HP, int(temp2));
									msg = "현재 체력이 "+temp2+"만큼 감소했습니다.";
									break;
								case "ST":
									Game.currentGame.statusManager.sub(StatusManager.CUR_ST, int(temp2));
									msg = "현재 스테미너가 "+temp2+"만큼 감소했습니다.";
									break;
								case "MHP":
									Game.currentGame.statusManager.sub(StatusManager.MAX_HP, int(temp2));
									msg = "최대 체력이 "+temp2+"만큼 감소했습니다.";
									break;
								case "MST":
									Game.currentGame.statusManager.sub(StatusManager.MAX_ST, int(temp2));
									msg = "최대 스테미너가 "+temp2+"만큼 감소했습니다.";
									break;
								default:
									msg = "명령어의 형식이 잘못되었습니다. target(string)에는 \"HP\", \"ST\", \"MHP\", \"MST\"의 값만 들어갈 수 있습니다.";
									break;
							}
						}
					}
					break;
					
				case "teleportTo":
					temp1 = t.substr(i+1, t.length-1);
					if(Game.currentGame.mapManager.tpTo(temp1)){
						msg = temp1+"로 순간이동합니다.";
					} else msg = temp1+"은 유효한 위치가 아닙니다.";
					break;
				
				case "goto":
					flag = false;
					for(i = loc+1; i < t.length; i++){
						if(t.charAt(i) == ","){
							temp1 = t.substr(loc+1, i-loc-1);
							loc = i;
							flag = true;
							break;
						}
					}
					if(!flag) msg = "명령어의 형식이 잘못되었습니다. goto는 두 개의 인수 gloc(string)과 spd(int)가 필요합니다.";
					else {
						temp2 = t.substr(loc+1, t.length-1);
						if(temp2 == null) msg = "명령어의 형식이 잘못되었습니다. goto는 두 개의 인수 gloc(string)과 spd(int)가 필요합니다.";
						else if(temp2 != String(int(temp2))) msg = "명령어의 형식이 잘못되었습니다. spd(int)에는 숫자가 들어가야 합니다.";
						else if((int(temp2)) <= 0) msg = "명령어의 형식이 잘못되었습니다. spd(int)에는 0보다 큰 숫자가 들어가야 합니다.";
						else {
							if(Map.isValid(temp1)){
								msg = "명령어의 형식이 잘못되었습니다. gloc(stinrg)의 형식은 \"(buildingNo)\"혹은, \"(buildingNo):(floor)-(roomIndex)\"입니다.";
							} else if(Map.isBuilding(temp1)){
								//building에 있는 상태
								msg = "아직 빌딩은 구현되지 않았습니다.";
							} else {
								//cave에 있는 상태
								if(Game.currentGame.mapManager.goto(temp1, int(temp2))) msg = temp1+"까지 "+temp2+"의 속도로 이동합니다.";
								else msg = "이동 범위가 잘못되었습니다.";
								
							}
						}
					}
					break;
					
				case "addItem":
					flag = false;
					for(i = loc+1; i < t.length; i++){
						if(t.charAt(i) == ","){
							temp1 = t.substr(loc+1, i-loc-1);
							loc = i;
							flag = true;
							break;
						}
					}
					if(!flag) msg = "명령어의 형식이 잘못되었습니다. addItem은 두 개의 인수 itemCode(int)과 amount(int)가 필요합니다.";
					else if(temp1 != String(int(temp1))) msg = "명령어의 형식이 잘못되었습니다. itemCode(int)에는 숫자가 들어가야 합니다.";
					else if(int(temp1) >= ItemDB.getNumItems()) msg = "명령어의 형식이 잘못되었습니다. itemCode(int)는 유효한 범위가 아닙니다.";
					else {
						temp2 = t.substr(loc+1, t.length-1);
						if(temp2 == null) msg = "명령어의 형식이 잘못되었습니다. addItem은 두 개의 인수 itemCode(int)과 amount(int)가 필요합니다.";
						else if(temp2 != String(int(temp2))) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 숫자가 들어가야 합니다.";
						else if((int(temp2)) <= 0) msg = "명령어의 형식이 잘못되었습니다. amount(int)에는 0보다 큰 숫자가 들어가야 합니다.";
						else {
							Game.currentGame.itemManager.achieveItem(int(temp1), int(temp2));
							msg = "아이템 코드 "+temp1+" "+ItemDB.getItem(int(temp1)).itemName+"(이)가 "+temp2+"개 만큼 인벤토리에 추가되었습니다.";
						}
					}
					break;
					
				case "itemList":
					msg = "numItems : "+ItemDB.getNumItems()+"\n"+"Items (itemCode(int), itemName(String), itemClass(uint))";
					for(i = 0; i < ItemDB.getNumItems(); i++){
						itemData = ItemDB.getItem(i);
						msg += "\n"+i+", "+itemData.itemName+", "+ItemDB.itemClassToString(itemData.itemClass);
					}
					break;
					
				case "craftRecipeList":
					msg = "Craft Recipes (craftRecipeIndex(int), itemCode(int) : [itemCode(int), number(int)] []..)"
					for(i = 0; i < ItemDB.getNumCraftRecipe(); i++){
						craftData = ItemDB.getCraftRecipeAt(i);
						msg += "\n"+i+", "+craftData.itemCode+", (req "+craftData.req+")"+" :";
						for(j = 0; j < craftData.recipe.length; j++) msg += " ["+craftData.recipe[j].x+", "+craftData.recipe[j].y+"]";
					}
					break;
					
				case "decomposeRecipeList":
					msg = "Decompose Recipes (decomposeRecipeIndex(int), itemCode(int) : [itemCode(int), number(int)] []..)"
					for(i = 0; i < ItemDB.getNumDecomposeRecipe(); i++){
						decomposeData = ItemDB.getDecomposeRecipeAt(i);
						msg += "\n"+i+", "+decomposeData.itemCode+", (req "+decomposeData.req+")"+" :";
						for(j = 0; j < decomposeData.recipe.length; j++) msg += " ["+decomposeData.recipe[j].x+", "+decomposeData.recipe[j].y+"]";
					}
					break;
				
				case "itemInfo":
					temp1 = t.substr(i+1, t.length-1);
					if(temp1 == "" || temp1 != String(int(temp1))) msg = "명령어의 형식이 잘못되었습니다. itemInfo는 인수 itemCode(int)가 필요합니다.";
					else if(int(temp1) >= ItemDB.getNumItems()) msg = "itemCode(int)의 범위가 잘못되었습니다.";
					else msg = getItemInfo(int(temp1));
					break;
				
				default:
					msg = "존재하지 않는 명령어 입니다. help@를 입력하여 존재하는 명령어를 알아보세요.";
					break;
			}
			
			_outputText.appendText(msg+"\n");
			_outputText.setTextFormat(_msgFormat, _outputText.length - msg.length - 1, _outputText.length - 1);
			_outputText.scrollV = _outputText.maxScrollV;
		}
		
		private function getItemInfo(itemCode:int):String {
			var msg:String, itemData:ItemData;
			itemData = ItemDB.getItem(itemCode);
			msg = "itemCode : "+itemCode+"\nitemName : "+itemData.itemName+"\ndescription : "+itemData.description+"\nitemClass : "+ItemDB.itemClassToString(itemData.itemClass)+", weight : "+itemData.weight;
			switch(itemData.itemClass){
				case ItemDB.CONSUMABLE:
					msg += "\nhp : "+Consumable(itemData).hp+", st : "+Consumable(itemData).st;
					break;
				case ItemDB.TOOL:
					msg += "\ndurability : "+Tool(itemData).durability;
					break;
				case ItemDB.EQUIPMENT:
					msg += "\natk : "+Equipment(itemData).atk+", def : "+Equipment(itemData).def+", hp : "+Equipment(itemData).hp+", st : "+Equipment(itemData).st;
					msg += ", part : "+ItemDB.partToString(Equipment(itemData).part)+", weaponType : "+Equipment(itemData).weaponType;
					break;
				default:
					break;
			}
			msg += "\nclip : "+itemData.clipName;
			return msg;
		}
		
		public function switchState():void {
			if(this.visible == false){
				this.visible = true;
				_inputText.text = "";
				Game.currentGame.root.stage.focus = _inputText;
				_inputText.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			} else {
				this.visible = false;
				_inputText.removeEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			}
		}

	}
	
}
