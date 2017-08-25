package system {
	import flash.media.SoundTransform;
	import flash.media.Sound;
	import flash.errors.IllegalOperationError;
	
	public class SoundEffect {
		private static var _sound:Sound;
		private static var _soundTransform:SoundTransform;

		public function SoundEffect() {
			_soundTransform = new SoundTransform(Settings.SFXVolume);
		}
		
		public static function play(tar:int):void {
			switch(tar){
				case 0:
					_sound = new sound_switch();
					break;
				case 1:
					_sound = new sound_paperflip();
					break;
				default:
					return;
			}
			
			_sound.play(0, 0, _soundTransform);
		}
		
		public static function set volume(volume:Number):void {
			if(_soundTransform == null) throw new IllegalOperationError("SoundEffect : did not initiated");
			_soundTransform.volume = volume;
			trace(1313);
		}

	}
	
}
