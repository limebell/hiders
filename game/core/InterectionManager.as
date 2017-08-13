package game.core {
	import flash.errors.IllegalOperationError;
	
	public class InterectionManager {

		public function InterectionManager() {
			// constructor code
		}
		
		public function interect(objectCode:int):Boolean {
			switch(objectCode){
				case 0:
					return true;
					break;
				case 1:
					return true;
					break;
				default:
					return false;
					throw new IllegalOperationError("interectionManager, 잘못된 인터렉션입니다");
			}
		}
		
		private function achieveItem():void {
			
		}
		
		private function removeStone():void {
			
		}

	}
	
}
