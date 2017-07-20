package game.db {
	
	public class SkillDB {
		
		private static var skills:Vector.<SkillData>;

		{
			skills = new Vector.<SkillData>();
			
			addSkill(0, "강인한 체력",
						"최대 체력이 10퍼센트 증가합니다.");
			
			addSkill(1, "임시 스킬",
						"임시로 존재하는 스킬, 효과는 없습니다.");
		}
		
		private static function addSkill(skillCode:int, skillName:String, description:String):void {
			var data:SkillData = new SkillData();
			data._skillCode = skillCode;
			data._skillName = skillName;
			data._description = description;
			
			skills[skillCode] = data;
		}
		
		public static function getSkill(skillCode:int):SkillData {
			return skills[skillCode];
		}

	}
	
}
