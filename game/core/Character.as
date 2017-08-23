package game.core {
	import game.db.JobDB;
	import game.db.JobData;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Character extends MovieClip {
		private const
		STAY:String = "stay",
		WALK:String = "walk",
		CLIMB:String = "climb",
		RIDE:String = "ride";
		
		/*
		STAY_HURT:String = "stay_hurt",
		WALK_HURT:String = "walk_hurt",
		CLIMB_HURT:String = "climb_hurt",
		RIDE_HURT:String = "ride_hurt";
		STAY_TIRED:String = "stay_tired",
		WALK_TIRED:String = "walk_tired",
		CLIMB_TIRED:String = "climb_tired",
		RIDE_TIRED:String = "ride_tired";
		*/
		
		private var _clip:MovieClip;
		private var _info:JobData;
		private var _state:String;
		private var _lastState:String;
		
		public function Character(index:int){
			_info = JobDB.getJobAt(index);
			_clip = new characterMC();
			this.addChild(_clip);
			this.state = STAY;
		}
		
		public function getState():String {
			return _state;
		}
		
		private function get state():String {
			return _state;
		}
		
		private function set state(t:String):void {
			_clip.gotoAndPlay(t);
			_lastState = _state;
			_state = t;
		}
		
		public function goLeft():void {
			_clip.scaleX = -1;
			this.state = WALK;
		}
		
		public function goRight():void {
			_clip.scaleX = 1;
			this.state = WALK;
		}
		
		public function climb():void {
			this.state = CLIMB;
		}
		
		public function standStill():void {
			this.state = STAY;
		}
	}
}