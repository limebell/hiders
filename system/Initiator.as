package system {
	import game.ui.Warning;
	import game.ui.Shade;
	
	import flash.display.MovieClip;
	
	public class Initiator {

		public function Initiator(root:MovieClip) {
			new Warning(root.warningDisp);
			new StageInfo(root);
			root.warningDisp.mouseEnabled = false;
			new Shade(root.shade);
			//세이브된 설정을 불러오는 부분이 필요
			new Settings(1, 1);
			new BackGroundMusic();
			new SoundEffect();
		}

	}
	
}
