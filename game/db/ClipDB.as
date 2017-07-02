package game.db {
	import game.asset.clip.*;
	import flash.display.MovieClip;
	
	public class ClipDB {
		private static var clips:Object;

		{
			clips = new Object();
			
			newClip("Temp", new testCharacter());
			newClip("Temp2", new testCharacter2());
		}
		
		private static function newClip(clipName:String, tar:MovieClip):void {
			clips[clipName] = tar;
		}
		
		public static function getClip(clipName):MovieClip {
			return clips[clipName];
		}

	}
	
}
