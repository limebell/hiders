package game.db {
	
	public class SkillDB {
		public static const
		TEMPSKILL:String = "TempSkill",
		TEMPSKILL2:String = "TempSkill2";
		
		private static var skills:Object;

		{
			skills = new Object();
			
			addSkill("TempSkill", "임시 스킬",
						"임시로 존재하는 스킬, 효과는 없습니다.");
			
			addSkill("TempSkill2", "임시 스킬2",
						"임시로 존재하는 스킬 두 번째, 효과는 없습니다.");
		}
		
		private static function addSkill(identifier:String, skillName:String, description:String):void {
			var data:SkillData = new SkillData();
			data._identifier = identifier;
			data._name = skillName;
			data._description = description;
			
			skills[identifier] = data;
		}
		
		public static function getSkill(identifier:String):SkillData {
			return skills[identifier];
		}

	}
	
}
