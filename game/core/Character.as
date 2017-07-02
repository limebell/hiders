package game.core {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.db.CharacterDB;
	import game.db.CharacterData;
	import game.db.ClipDB;
	
	public class Character extends MovieClip {
		private var _clip:MovieClip;
		
		private var footPoint:Point;
		
		private var _info:CharacterData;
		
		public function Character(index:int){
			footPoint = new Point(0, 0);
			_info = CharacterDB.getCharacterAt(index);
			_clip = ClipDB.getClip(_info.charName);
			this.addChild(_clip);
		}
		
		public function get charName():String {
			return _info.charName;
		}
		
		public function get description():String {
			return _info.description;
		}
		
		public function get baseATK():int {
			return _info.baseATK;
		}
		
		public function get baseDEF():int {
			return _info.baseDEF;
		}
		
		public function get baseHP():int {
			return _info.baseHP;
		}
		
		public function get baseST():int {
			return _info.baseST;
		}
	}
}