package game.core {
	import game.ui.GameplayUI;
	import game.db.JobDB;
	import game.db.JobData;
	
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
		
		private var _tempData:JobData;
		private var _ui:GameplayUI;
		
		private var _tweenHP:Tween;
		private var _tweenST:Tween;
		
		private var _atk:int;
		private var _def:int;

		private var _realMaxHP:int;
		private var _realMaxST:int;
		private var _finalMaxHP:int;
		private var _finalMaxST:int;
		private var _curHP:int;
		private var _curST:int;
		
		
		public function StatusManager(ui:GameplayUI, isNew:Boolean, jobIndex:int, atk:int = -1, def:int = -1, maxHP:int = -1, maxST:int = -1, curHP:int = -1, curST:int = -1) {
			_ui = ui;
			if(isNew){
				_tempData = JobDB.getJobAt(jobIndex);
				_atk = _tempData.baseATK;
				_def = _tempData.baseDEF;
				_realMaxHP = _tempData.baseHP;
				_realMaxST = _tempData.baseST;
			} else {
				if(atk == -1 || def == -1 || maxHP == -1 || maxST == -1) throw new IllegalOperationError("status manager : 잘못된 초기값입니다.");
				_atk = atk;
				_def = def;
				
				_realMaxHP = maxHP;
				_realMaxST = maxST;
			}
			
			adjustSkill();
			
			if(curHP == -1)
				_curHP = _finalMaxHP;
			else
				_curHP = curHP;
			
			if(curST == -1)
				_curST = _finalMaxST;
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
					_realMaxHP += amount;
					break;
				case MAX_ST:
					_realMaxST += amount;
					break;
				case CUR_HP:
					_curHP += amount;
					break;
				case CUR_ST:
					_curST += amount;
					break;
			}
			
			adjustSkill();
			
			if( _curHP > _finalMaxHP ) _curHP = _finalMaxHP;
			if( _curST > _finalMaxST ) _curST = _finalMaxST;
			
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
					_realMaxHP -= amount;
					break;
				case MAX_ST:
					_realMaxST -= amount;
					break;
				case CUR_HP:
					_curHP -= amount;
					break;
				case CUR_ST:
					_curST -= amount;
					break;
			}
			
			adjustSkill();
			
			if( _finalMaxHP < 0 ) _finalMaxHP = 0;
			if( _finalMaxST < 0 ) _finalMaxST = 0;
			if( _curHP > _finalMaxHP ) _curHP = _finalMaxHP;
			if( _curST > _finalMaxST ) _curST = _finalMaxST;
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
					_realMaxHP = amount;
					break;
				case MAX_ST:
					_realMaxST = amount;
					break;
				case CUR_HP:
					_curHP = amount;
					break;
				case CUR_ST:
					_curST = amount;
					break;
			}
			
			adjustSkill();
			refresh();
		}
		
		public function getStatus(tar:String):int {
			var val:int = -1;
			switch(tar){
				case ATK:
					val = _atk;
					break;
				case DEF:
					val = _def;
					break;
				case MAX_HP:
					val = _finalMaxHP;
					break;
				case MAX_ST:
					val = _finalMaxST;
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
		
		private function adjustSkill():void {
			/*if(JobDB.getJobAt(Game.currentGame.character).skill.skillCode == 0) _finalMaxHP = int(_realMaxHP*1.1);
			else */_finalMaxHP = _realMaxHP;
			_finalMaxST = _realMaxST;
		}
		
		private function refresh():void {
			if(_tweenHP != null && _tweenHP.isPlaying) _tweenHP.stop();
			if(_tweenST != null && _tweenST.isPlaying) _tweenST.stop();
			_tweenHP = new Tween(_ui.hpBar, "scaleX", Regular.easeOut, _ui.hpBar.scaleX, _curHP/_finalMaxHP, 36);
			_tweenST = new Tween(_ui.stBar, "scaleX", Regular.easeOut, _ui.stBar.scaleX, _curST/_finalMaxST, 36);
			_ui.hpTxt = _curHP+"/"+_finalMaxHP;
			_ui.stTxt = _curST+"/"+_finalMaxST;
		}
		
		public function get statusForConsole():String {
			return "ATK : "+_atk+", DEF : "+_def+", realMaxHP : "+_realMaxHP+", finalMaxHP : "+_finalMaxHP+", curHP : "+_curHP+
				", realMaxST : "+_realMaxST+", finalMaxST : "+_finalMaxST+", curST : "+_curST;
		}
		
	}
	
}
