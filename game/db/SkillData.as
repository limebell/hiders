package game.db {
	
	public class SkillData {
		
		internal var _skillCode:int, _skillName:String, _description:String;

		public function get skillCode():int {
			return _skillCode;
		}
		
		public function get skillName():String {
			return _skillName;
		}
		
		public function get description():String {
			return _description;
		}

	}
	
}
