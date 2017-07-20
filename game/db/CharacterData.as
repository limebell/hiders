﻿package game.db {
	import flash.display.MovieClip;
	
	public class CharacterData {
		
		internal var _name:String, _description:String, _baseATK:int, _baseDEF:int, _baseHP:int, _baseST:int, _skill:SkillData, _clip:MovieClip, _portrait:MovieClip;

		public function get charName():String {
			return _name;
		}
		
		public function get description():String {
			return _description;
		}

		public function get baseATK():int {
			return _baseATK;
		}
		
		public function get baseDEF():int {
			return _baseDEF;
		}
		
		public function get baseHP():int {
			return _baseHP;
		}
		
		public function get baseST():int {
			return _baseST;
		}
		
		public function get skill():SkillData {
			return _skill;
		}
		
		public function get clip():MovieClip {
			return _clip;
		}
		
		public function get portrait():MovieClip {
			return _portrait;
		}

	}
	
}
