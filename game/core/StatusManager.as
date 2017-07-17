package game.core {
	import game.ui.GameplayUI;
	import game.db.CharacterDB;
	import game.db.CharacterData;
	
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class StatusManager extends EventDispatcher {
		public static const
		ATK:String = "atk",
		DEF:String = "def",
		MAX_HP:String = "maxHP",
		MAX_ST:String = "maxST",
		CUR_HP:String = "curHP",
		CUR_ST:String = "curST";
		//ST for stamina
		
		private var _tempData:CharacterData;
		private var _ui:GameplayUI;
		
		private var _tweenHP:Tween;
		private var _tweenST:Tween;
		
		private var _atk:int;
		private var _def:int;

		private var _maxHP:int;
		private var _maxST:int;
		private var _curHP:int;
		private var _curST:int;
		
		
		public function StatusManager(ui:GameplayUI, isNew:Boolean, charIndex:int, atk:int = -1, def:int = -1, maxHP:int = -1, maxST:int = -1, curHP:int = -1, curST:int = -1) {
			_ui = ui;
			if(isNew){
				_tempData = CharacterDB.getCharacterAt(charIndex);
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
				_curHP = _maxHP;
			else
				_curHP = curHP;
			
			if(curST == -1)
				_curST = _maxST;
			else
				_curST = curST;
			
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
			
			if( _curHP > _maxHP ) _curHP = _maxHP;
			if( _curST > _maxST ) _curST = _maxST;
			
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
			
			if( _maxHP < 0 ) _maxHP = 0;
			if( _maxST < 0 ) _maxST = 0;
			if( _curHP > _maxHP ) _curHP = _maxHP;
			if( _curST > _maxST ) _curST = _maxST;
			if( _curST <= 0 ){
				_curHP += _curST*2;
				_curST = 0;
			}
			if( _curHP <= 0 ){
				_curHP = 0;
				trace("gameover");
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
			
			refresh()
		}
		
		private function refresh():void {
			if(_tweenHP != null && _tweenHP.isPlaying) _tweenHP.stop();
			if(_tweenST != null && _tweenST.isPlaying) _tweenST.stop();
			_tweenHP = new Tween(_ui.hpBar, "scaleX", Regular.easeOut, _ui.hpBar.scaleX, _curHP/_maxHP, 36);
			_tweenST = new Tween(_ui.stBar, "scaleX", Regular.easeOut, _ui.stBar.scaleX, _curST/_maxST, 36);
			_ui.hpTxt = _curHP+"/"+_maxHP;
			_ui.stTxt = _curST+"/"+_maxST;
		}
	}
	
}
