package system {
	
	public class Settings {
		private static var _BGMVolume:Number;
		private static var _SFXVolume:Number;

		public function Settings(BGMVolume:Number, SFXVolume:Number) {
			// constructor code
			_BGMVolume = BGMVolume;
			_SFXVolume = SFXVolume;
		}
		
		public static function set BGMVolume(volume:Number):void {
			_BGMVolume = volume;
			BackGroundMusic.volume = _BGMVolume;
		}
		
		public static function set SFXVolume(volume:Number):void {
			_SFXVolume = volume;
			SoundEffect.volume = _SFXVolume;
		}
		
		public static function get BGMVolume():Number {
			return _BGMVolume;
		}
		
		public static function get SFXVolume():Number {
			return _SFXVolume;
		}

	}
	
}
