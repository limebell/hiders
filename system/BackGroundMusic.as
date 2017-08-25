package system {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.errors.IllegalOperationError;
	
	public class BackGroundMusic {
		private static var _sound:Sound;
		private static var _bgmChannel:SoundChannel;
		private static var _soundTransform:SoundTransform;

		public function BackGroundMusic() {
			_soundTransform = new SoundTransform(Settings.BGMVolume);
		}
		
		public static function play(tar:int):void {
			if(_bgmChannel != null) _bgmChannel.stop();
			switch(tar){
				case 0:
					_sound = new sound_waterflow();
					break;
				default:
					return;
			}
			
			if(_bgmChannel != null) _bgmChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_bgmChannel = _sound.play(0, 0, _soundTransform);
			_bgmChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		private static function soundCompleteHandler(e:Event):void {
			_bgmChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_bgmChannel = _sound.play(0, 0, _soundTransform);
			_bgmChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		public static function stop():void {
			if(_bgmChannel == null) return;
			_bgmChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_bgmChannel.stop();
		}
		
		public static function set volume(volume:Number):void {
			if(_soundTransform == null) throw new IllegalOperationError("BackGroundMusic : did not initiated");
			_soundTransform.volume = volume;
			if(_bgmChannel != null){
				_bgmChannel.soundTransform = _soundTransform;
			}
		}

	}
	
}
