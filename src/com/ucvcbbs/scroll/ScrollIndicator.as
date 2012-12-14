package com.ucvcbbs.scroll
{
	import com.ucvcbbs.utils.AppTools;
	import com.ucvcbbs.utils.SystemName;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**
	 * 滚动条主类
	 * 移动版 滚动条
	 * ...
	 * @author ScrollIndicator  by Ray
	 */
	public class ScrollIndicator extends Sprite
	{
		//ios scroll
		protected static var DECAY:Number = 0.95;
        protected static var MOUSE_DOWN_DECAY:Number = 0.6;
		protected static var BOUNCING_SPRINGESS:Number = 0.3;
		protected static var SPEED_SPRINGNESS:Number = 0.6;
		//
		protected static const ANIMATION_DURATION:Number = 1.25;
		protected static const MIN_SCROLL_INDICATOR_HEIGHT:Number = 10;
		protected static const MIN_SCROLL_INDICATOR_WIDTH:Number = 10;
		protected static const SCROLL_FADE_TWEEN_DURATION:Number = .2;
		//最大超出加速距离
		protected static const MAX_TWEEN:Number = 200;
		/**
		 * The amount the mouse must move horizontally to trigger a HorizontalSwipeEvent.
		 */
		protected static const HORIZONTAL_DRAG_THRESHOLD:Number = 40;
		
		//加速度最大滚动距离
		protected static const MAX_PIXEL_MOVE:Number = 200;
		/**
		 * 滚动的速度
		 */
		protected static const NUM_FRAMES_TO_MEASURE_SPEED:Number = 2;
		/**
		 * 拖拽 多少 才 开始 移动
		 */
		protected static const START_TO_DRAG_THRESHOLD:Number = 4;
		
		protected var viewContainer:Sprite = null;
		
		//滚动条消失速度
		protected var scrollIndicatorAlphaDelta:Number;
		
		//
		protected var _width:Number;
		protected var _height:Number;
		
		private var mWHScrollBarBOOL:Boolean = false;
		
		/**
		 * 最大缓冲值
		 */
		protected static const MAXTWEEN:Number = 60;
		//是否禁止拖动
		public var ProhibitedDrag:Boolean = false;
		
		protected var mouseWheeloutTime:uint;
		
		public function ScrollIndicator() 
		{
			//滚动的主体
			viewContainer = new Sprite();
			addChild(viewContainer);
			//
			if (AppTools.getSystemName() == SystemName.LINUX) {
				ProhibitedDrag = true;
			}
			
			if (stage) {
				init()
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(evt:Event=null):void 
		{
			//super.addTostage(evt);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			scrollIndicatorAlphaDelta = 1 / (SCROLL_FADE_TWEEN_DURATION * stage.frameRate);
			//			
			if (!MWHScrollBarBOOL) {
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			}else
			{
				parent.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
				parent.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			}
		}
		
		protected function mouseWheel(e:MouseEvent):void 
		{
			clearTimeout(mouseWheeloutTime);
			mouseWheeloutTime = setTimeout(scrollIndicatorFadeout, 2000);
		}
		protected function scrollIndicatorFadeout():void
		{
			clearTimeout(mouseWheeloutTime);
			//addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
		}
		
		protected function mouseDownHandler(evt:MouseEvent):void
		{
			
		}
		
		override public function set width(vole:Number):void
		{
			_width = vole;
		}
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			// Only trigger validation if the height changed.
			if (value != _height)
			{
				_height = value;
			}
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function get scrollY():Number
		{
			return viewContainer.scrollRect.y;
		}
		
		public function set scrollY(value:Number):void
		{
			var rect:Rectangle = viewContainer.scrollRect;
			rect.y = value;
			viewContainer.scrollRect = rect;
		}
		
		public function get scrollX():Number
		{
			return viewContainer.scrollRect.x;
		}
		
		public function set scrollX(value:Number):void
		{
			var rect:Rectangle = viewContainer.scrollRect;
			rect.x = value;
			viewContainer.scrollRect = rect;
		}
		
		//获取滚动对象
		public function get ScrollViewContainer():Sprite
		{
			return viewContainer;
		}
		
		
		public function get MWHScrollBarBOOL():Boolean 
		{
			return mWHScrollBarBOOL;
		}
		
		public function set MWHScrollBarBOOL(value:Boolean):void 
		{
			mWHScrollBarBOOL = value;
		}
		
		
		public function removeAt():void 
		{
			parent.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			parent.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			//super.removeAt();
		}
	}

}