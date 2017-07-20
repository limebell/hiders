package game.db {
	import flash.display.MovieClip;
	
	public class CharacterDB {
		
		private static var characters:Vector.<CharacterData>;

		{
			characters = new Vector.<CharacterData>();
			
			addCharacter("Temp",
							"임시 캐릭터 입니다. 임시로 만들어 져서인지 왠지 슬픈 얼굴을 하고 있습니다. 능력치는 걍 내맘대로 설정한 수치이므로 이 수치가 좋은 것일수도, 안좋은 것일수도 있습니다. 뭐라도 써서 칸을 늘려서 줄바뀜 테스트를 해야 합니다.",
							5, 5, 100, 100, SkillDB.getSkill(0), new testCharacter(), new testCharacter());
			
			addCharacter("Temp2",
							"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
							6, 4, 90, 110, SkillDB.getSkill(1), new testCharacter2(), new testCharacter2());
		}
		
		private static function addCharacter(charName:String, description:String, baseATK:int, baseDEF:int, baseHP:int, baseST:int, skill:SkillData, clip:MovieClip, portrait:MovieClip):void {
			var data:CharacterData = new CharacterData();
			data._name = charName;
			data._description = description;
			data._baseATK = baseATK;
			data._baseDEF = baseDEF;
			data._baseHP = baseHP;
			data._baseST = baseST;
			data._skill = skill;
			data._clip = clip;
			data._portrait = portrait;
			
			characters.push(data);
		}
		
		public static function getCharacterAt(index:int):CharacterData {
			return characters[index];
		}
		
		public static function getNumChars():uint {
			return characters.length;
		}

	}
	
}
