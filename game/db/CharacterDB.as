package game.db {
	
	public class CharacterDB {
		
		private static var characters:Vector.<CharacterData>;

		{
			characters = new Vector.<CharacterData>();
			
			addCharacter("Temp",
							"임시 캐릭터 입니다. 임시로 만들어 져서인지 왠지 슬픈 얼굴을 하고 있습니다. 능력치는 걍 내맘대로 설정한 수치이므로 이 수치가 좋은 것일수도, 안좋은 것일수도 있습니다. 뭐라도 써서 칸을 늘려서 줄바뀜 테스트를 해야 합니다.",
							5, 5, 100, 100, SkillDB.getSkill(SkillDB.TEMPSKILL));
			
			addCharacter("Temp2",
							"임시 캐릭터 그 두번째 입니다. 임시로 만들어 졌지만 기쁜 얼굴을 하고 있습니다. 능력치는 걍 내맘대로 설정한 수치이므로 이 수치가 좋은 것일수도, 안좋은 것일수도 있습니다. 또 그리기 귀찮아서 그냥 그대로 우려먹었습니다.",
							6, 4, 90, 110, SkillDB.getSkill(SkillDB.TEMPSKILL2));
		}
		
		private static function addCharacter(charName:String, description:String, baseATK:int, baseDEF:int, baseHP:int, baseST:int, skill:SkillData):void {
			var data:CharacterData = new CharacterData();
			data._name = charName;
			data._description = description;
			data._baseATK = baseATK;
			data._baseDEF = baseDEF;
			data._baseHP = baseHP;
			data._baseST = baseST;
			data._skill = skill;
			
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
