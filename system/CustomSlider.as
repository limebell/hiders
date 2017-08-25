package system {
	import system.event.SliderEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.errors.IllegalOperationError;
	
	public class CustomSlider extends MovieClip {
		private var _clip:MovieClip;

		public function CustomSlider(initValue:Number = 1) {
			_clip = new customSlider();
			this.value = initValue;
			this.addChild(_clip);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			StageInfo.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			StageInfo.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			refreshSliderLocation();
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			refreshSliderLocation();
		}
		
		private function refreshSliderLocation():void {
			if(this.mouseX > 100) _clip.slider.x = 100;
			else if(this.mouseX < 0) _clip.slider.x = 0;
			else _clip.slider.x = this.mouseX;
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDER_MOVED));
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			StageInfo.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			StageInfo.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		public function get value():Number {
			return Number(_clip.slider.x/100);
		}
		
		public function set value(val:Number):void {
			if(val <= 1 && val >= 0) _clip.slider.x = val*100;
			else throw new IllegalOperationError("CustomSlider : 설정값이 0보다 작거나 1보다 큽니다.");
		}

	}
	
}
