package game.core {
	import game.ui.GameplayUI;
	import game.db.JobDB;
	import game.db.JobData;
	
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import game.event.StatusEvent;
	
	public class StatusManager extends EventDispatcher {
		public static const
		ATK:String = "atk",
		DEF:String = "def",
		MAX_HP:String = "maxHP",
		MAX_ST:String = "maxST",
		CUR_HP:String = "curHP",
		CUR_ST:String = "curST";
		//ST for stamina
		
		private var _tempData:JobData;
		private var _ui:GameplayUI;
		
		private var _tweenHP:Tween;
		private var _tweenST:Tween;
		
		private var _atk:int;
		private var _def:int;

		private var _maxHP:int;
		private var _maxST:int;
		private var _curHP:int;
		private var _curST:int;
		
		private var _itemATK:int;
		private var _itemDEF:int;
		private var _itemHP:int;
		private var _itemST:int;
		
		
		public function StatusManager(ui:GameplayUI, isNew:Boolean, jobIndex:int, atk:int = -1, def:int = -1, maxHP:int = -1, maxST:int = -1, curHP:int = -1, curST:int = -1) {
			_ui = ui;
			if(isNew){
				_tempData = JobDB.getJobAt(jobIndex);
				_atk = _tempData.baseATK;
				_def = _tempData.baseDEF;
				_maxHP = _tempData.baseHP;
				_maxST = _tempData.baseST;
			} else {
				if(atk == -1 || def == -1 || maxHP == -1 || maxST == -1) throw new IllegalOperationError("status manager : 잘못된 초기값입니다.");
				_atk = atk;
				_def = def;
				
				_maxHP = maxHP;
				_maxST = maxST;
			}
			
			if(curHP == -1)
				_curHP = getStatus(MAX_HP);
			else
				_curHP = curHP;
			
			if(curST == -1)
				_curST = getStatus(MAX_ST);
			else
				_curST = curST;
			
			this.addEventListener(StatusEvent.EQUIP_EVENT, equipEventHandler);
			refresh();
		}
		
		public function add(tar:String, amount:int) {
			switch(tar) {
				case ATK:
					_atk += amount;
					break;
				case DEF:
					_def += amount;
					break;
				case MAX_HP:
					_maxHP += amount;
					break;
				case MAX_ST:
					_maxST += amount;
					break;
				case CUR_HP:
					_curHP += amount;
					break;
				case CUR_ST:
					_curST += amount;
					break;
			}
			
			refresh();
		}
		
		public function sub(tar:String, amount:int) {
			switch(tar) {
				case ATK:
					_atk -= amount;
					break;
				case DEF:
					_def -= amount;
					break;
				case MAX_HP:
					_maxHP -= amount;
					break;
				case MAX_ST:
					_maxST -= amount;
					break;
				case CUR_HP:
					_curHP -= amount;
					break;
				case CUR_ST:
					_curST -= amount;
					break;
			}
			
			refresh();
		}
		
		public function setValue(tar:String, amount:int) {
			switch(tar) {
				case ATK:
					_atk = amount;
					break;
				case DEF:
					_def = amount;
					break;
				case MAX_HP:
					_maxHP = amount;
					break;
				case MAX_ST:
					_maxST = amount;
					break;
				case CUR_HP:
					_curHP = amount;
					break;
				case CUR_ST:
					_curST = amount;
					break;
			}
			
			refresh();
		}
		
		public function getStatus(tar:String):int {
			var val:int = -1;
			switch(tar){
				case ATK:
					val = _atk+_itemATK;
					break;
				case DEF:
					val = _def+_itemDEF;
					break;
				case MAX_HP:
					if(Game.currentGame.job == 0) val = int(1.1*(_maxHP+_itemHP))
					else val = _maxHP+_itemHP;
					break;
				case MAX_ST:
					val = _maxST+_itemST;
					break;
				case CUR_HP:
					val = _curHP;
					break;
				case CUR_ST:
					val = _curST;
					break;
				default:
					throw new IllegalOperationError("getStatus : 잘못된 대상입니다");
					break;
			}
			return val;
		}
		
		private function equipEventHandler(e:StatusEvent):void {
			var arr:Array = Game.currentGame.itemManager.itemSpec();
			_itemATK = arr[0];
			_itemDEF = arr[1];
			_itemHP = arr[2];
			_itemST = arr[3];
			
			refresh();
		}
		
		private function refresh():void {
			if( _curHP > getStatus(MAX_HP) ) _curHP = getStatus(MAX_HP);
			if( _curST > getStatus(MAX_ST) ) _curST = getStatus(MAX_ST);
			if( _curST <= 0 ){
				_curHP += _curST*2;
				_curST = 0;
			}
			if( _curHP <= 0 ){
				_curHP = 0;
				trace("gameover");
			}
			
			if(_tweenHP != null && _tweenHP.isPlaying) _tweenHP.stop();
			if(_tweenST != null && _tweenST.isPlaying) _tweenST.stop();
			_tweenHP = new Tween(_ui.hpBar, "scaleX", Regular.easeOut, _ui.hpBar.scaleX, _curHP/getStatus(MAX_HP), 36);
			_tweenST = new Tween(_ui.stBar, "scaleX", Regular.easeOut, _ui.stBar.scaleX, _curST/getStatus(MAX_ST), 36);
			_ui.hpTxt = _curHP+"/"+getStatus(MAX_HP);
			_ui.stTxt = _curST+"/"+getStatus(MAX_ST);
		}
		
		public function get statusForConsole():String {
			return "ATK : "+_atk+", itemATK : "+_itemATK+", finalATK : "+getStatus(ATK)+", DEF : "+_def+", itemDEF : "+_itemDEF+", finalDEF : "+getStatus(DEF)+
				", maxHP : "+_maxHP+", itemHP : "+_itemHP+", finalMaxHP : "+getStatus(MAX_HP)+", curHP : "+_curHP+
				", maxST : "+_maxST+", itemST : "+_itemST+", finalMaxST : "+getStatus(MAX_HP)+", curST : "+_curST;
		}
		
	}
	
}
