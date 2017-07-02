package game.core {
	
	public class StatusManager {
		public static const
		ATK:String = "atk",
		DEF:String = "def",
		MAX_HP:String = "maxHP",
		MAX_ST:String = "maxST",
		CUR_HP:String = "curHP",
		CUR_ST:String = "curST";
		//ST for stamina
		
		private var _atk:int;
		private var _def:int;

		private var _maxHP:int;
		private var _maxST:int;
		private var _curHP:int;
		private var _curST:int;
		
		
		public function StatusManager(atk:int, def:int, maxHP:int, maxST:int, curHP:int = -1, curST:int = -1) {
			_atk = atk;
			_def = def;
			
			_maxHP = maxHP;
			_maxST = maxST;
			
			if(curHP == -1)
				_curHP = _maxHP;
			else
				_curHP = curHP;
			
			if(curST = -1)
				_curST = maxST;
			else
				_curST = curST;
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
			if( _curHP <= 0 ); //gameOver
			if( _curST <= 0 ); //gameOver
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
		}
	}
	
}
