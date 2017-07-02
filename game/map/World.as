package game.map {
	import flash.display.MovieClip;
	
	public class World extends MovieClip {
		private var _character:MovieClip;
		private var _backField:MovieClip;
		private var _frontField:MovieClip;

		public function World(character:MovieClip) {
			_character = character;
			
			initiate();
		}
		
		private function initiate():void {
			
		}

	}
	
}
