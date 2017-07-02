package game.db {
	
	public class SkillData {
		
		internal var _identifier:String, _name:String, _description:String;

		public function get skillName():String {
			return _name;
		}
		
		public function get description():String {
			return _description;
		}

	}
	
}
