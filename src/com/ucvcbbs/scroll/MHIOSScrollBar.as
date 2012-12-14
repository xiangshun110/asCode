package com.ucvcbbs.scroll
{
	import com.greensock.TweenLite;
	import com.ucvcbbs.events.ScrollEvent;
	import com.vsdevelop.system.CapabilitiesCore;
	import com.vsdevelop.utils.StringCore;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import com.greensock.easing.Quad;
	import mx.effects.easing.Quartic;
	import flash.display.DisplayObjectContainer;

	/**
	 * 滚动条主类
	 * 移动版 滚动条 竖向滚动条
	 * ...
	 * @author ScrollIndicator  by Ray
	 */
	public class MHIOSScrollBar extends ScrollIndicator
	{
		
		/**
		 * The difference between the scrollIndicator.height and _height.
		 */
		private var totalScrollAmount:Number;
		/**
		 * 头部间距
		 */
		private var scrollIndicatorTopPadding:Number;
		/**
		 * 底部间距
		 */
		private var scrollIndicatorBottomPadding:Number;
			/**
		 * The target scroll value when a user flicks.
		 */
		private var targetScrollY:Number;
		//
		private var itemYOffsetBottom:Number = 0;
		
	    private var scrollIndicator:ScrollSkin;
		
		//
		private var backgroundColor:Number;
		
		private var resetScrollY:Boolean = false;
		
		//
		private var maxScroll:Number;
		private var scrollIndicatorHeight:Number;
		//拖拽的y
		private var previousDragMouseY:Number;
		private var mouseYDown:Number;
		
		private var deltaMouseY:Number = 0;
		//初始化时间
		private var previousDragTime:uint;
		/**
		 * The scrollY when a user first starts to drag.
		 */
		private var beginDragScrollY:Number;
		private var enterFrameIndex:Number = 0;
		//
		public var isDragging:Boolean = false;
		/**
		 * Flag for whether or not the flick tween is still playing.
		 */
		private var isTweening:Boolean;
		/**
		 * The start scroll value when a user flicks.
		 */
		private var startScrollY:Number;
		/**
		 * The total amount to scroll when a user flicks.
		 */
		private var totalScrollY:Number;
		/**
		 * Properties for tweening a user flick.
		 */
		private var tweenCurrentCount:Number = 0;
		private var tweenTotalCount:Number = 0;
		
		/**
		 * MHScrollBar 移动版 竖向滚动条
		 * view			滚动的对象
		 * backgroundColor   背景颜色
		 * scrollIndicatorTopPadding  头部间距
		 * scrollIndicatorBottomPadding	 底部间距
		 * ...
		 * @author
		 */
		public function MHIOSScrollBar(
									view:DisplayObjectContainer,
									backgroundColor:Number = 0xffffff,
									scrollIndicatorTopPadding:Number=0,
									scrollIndicatorBottomPadding:Number=0)
		{
			if (view && view.name != MWHIOSScrollBar.SCROLLBARNAME) {
				viewContainer.addChild(view);
			}
			else {
				MWHScrollBarBOOL = true;
				viewContainer = view as Sprite;
			}
			
			if (!scrollIndicator)
			{
				scrollIndicator = new ScrollSkin("H");
				addChild(scrollIndicator);
				scrollIndicatorVisible = false;
			}
			//
			this.backgroundColor = backgroundColor;
			this.scrollIndicatorTopPadding = scrollIndicatorTopPadding;
			this.scrollIndicatorBottomPadding = scrollIndicatorBottomPadding;
		}
		
		public function refreshView(vole:Boolean):void
		{
			/*if (stage)
			stage.removeEventListener(Event.ENTER_FRAME, tween_enterFrameHandler_Y);*/
			
			resetScrollY = vole;
			
			this.updateX(width, height);
			
			resetScrollY = false;
			
			viewContainer.mouseChildren = viewContainer.mouseEnabled = true;
			
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARUPDATE));
		}
		
		//是否显示滚动条
		public function set IndicatorVisible(vole:Boolean):void
		{
			scrollIndicator.visible = vole;
		}
		
		//
		private function updateX(width:Number, height:Number):void
		{
			if (resetScrollY)
			{
				stopTween();
			}
			
			//trace(width, height);
			updateMaxScroll();
			//trace(width, height);
			
			if (resetScrollY || !viewContainer.scrollRect)
			{
				viewContainer.scrollRect = new Rectangle(0, 0, width, height);
			}
			else
			{
				//当前拖动到的y
				scrollY = Math.min(maxScroll, scrollY);
				//trace(scrollY, "-------------------------------------");
				viewContainer.scrollRect = new Rectangle(0, scrollY, width, height);
			}
			
			if (!MWHScrollBarBOOL)
			{
				graphics.clear();
				graphics.beginFill(backgroundColor,0);
				graphics.drawRect(0, 0, width, height);
			}
			//this.opaqueBackground = backgroundColor;
		}
		/**
		 * Stops the flick tween.
		 */
		public function stopTween():void
		{
			this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
			tweenCurrentCount = 0;			
			scrollIndicatorVisible = false;
		}
		
		private function updateMaxScroll():void
		{
			var getdisplayContact:DisplayObjectContainer = viewContainer.getChildAt(0) as DisplayObjectContainer;
			if (getdisplayContact&&getdisplayContact.height > 0)
			{
				maxScroll = Math.round(getdisplayContact.height - height) + itemYOffsetBottom;
				
				//trace("H",maxScroll);
				this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARBOOL, maxScroll > 0));
				if (maxScroll > 0)
				{
					//MoveVideo
					var availableHeight:Number = height - scrollIndicatorTopPadding - scrollIndicatorBottomPadding;
					////trace(availableHeight);
					scrollIndicatorHeight = Math.max(Math.round((availableHeight / getdisplayContact.height) * availableHeight), MIN_SCROLL_INDICATOR_HEIGHT);
					////trace(viewContainer.height,scrollIndicatorHeight);
					scrollIndicator.height = scrollIndicatorHeight;
					scrollIndicator.x = width - scrollIndicator.WIDTH - scrollIndicatorTopPadding;
					scrollIndicator.y = scrollIndicatorTopPadding;
					totalScrollAmount = availableHeight - scrollIndicatorHeight;
				}
				else
				{
					maxScroll = 0;
				}
			}
		}
		
		
		override protected function mouseDownHandler(evt:MouseEvent):void 
		{
			/*evt.stopImmediatePropagation();
			evt.stopPropagation();*/
			if (maxScroll.toString() == "NaN")
			{
				updateMaxScroll();
			}
			if (maxScroll == 0) return;
			
			isDragging = true;
			mouseYDown = previousDragMouseY = root.mouseY;
			tweenCurrentCount = 0;
			beginDragScrollY = scrollY;
			
			TweenLite.killTweensOf(this);
			
			this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_Y);
			stage.addEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_Y);
			
			
			this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
			
		}
		//放开事件
		private function drag_mouseUpHandler_Y(e:MouseEvent):void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_Y);
				stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_Y);
			}
			isDragging = false;		
			/*if (scrollY<0 || scrollY>maxScroll)
			{*/
				this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
			/*}*/
			
			if (StringCore.checkKeyWord(CapabilitiesCore.getOS, "Linux"))
			{
				ProhibitedDrag = true;
			}
		}
		//开始拖动
		private function detectDirection_mouseMoveHandler_Y(e:MouseEvent):void
		{
			//trace("H",maxScroll,Math.abs(mouseYDown - root.mouseY),START_TO_DRAG_THRESHOLD);
			//trace(MWHScrollBarBOOL);
			if (!MWHScrollBarBOOL) {
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
			
			if (StringCore.checkKeyWord(CapabilitiesCore.getOS, "Linux"))
			{
				if (Math.abs(root.mouseY - previousDragMouseY) > 50 && ProhibitedDrag)
				{
					mouseYDown = previousDragMouseY = root.mouseY;
					ProhibitedDrag = false;
				}
			}
			
			if (ProhibitedDrag) return;
			
			
			this.scrollIndicatorFadeout();
			
			/*if (!this.hasEventListener(Event.ENTER_FRAME)) 
			{
				this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
			}
			*/
			viewContainer.mouseChildren = viewContainer.mouseEnabled = false;
			
			var initDownY:Number = previousDragMouseY - root.mouseY;
			
			//trace(scrollY , (previousDragMouseY - root.mouseY) * (scrollY < 0?.5:scrollY>maxScroll?.5:1),(beginDragScrollY + (previousDragMouseY - root.mouseY)) * (scrollY < 0?.5:scrollY>maxScroll?.5:1));
			scrollY = (beginDragScrollY + initDownY * (scrollY < 0?.5:scrollY>maxScroll?.5:1));
			//scrollY = scrollY < -(height * .5)?-(height * .5):scrollY > maxScroll+height * .5?maxScroll+height * .5:scrollY;
		
			if (beginDragScrollY + initDownY <= 0 || beginDragScrollY + initDownY>=maxScroll) {
					beginDragScrollY = scrollY;
					previousDragMouseY = root.mouseY;
			}
			
			tweenCurrentCount += (mouseYDown - root.mouseY) * SPEED_SPRINGNESS;
			
			mouseYDown = root.mouseY;
			
			updateScrollIndicator();
			scrollIndicatorVisible = true;
		}
		
		override protected function mouseWheel(e:MouseEvent):void 
		{
			e.stopPropagation();
			if (tweenCurrentCount == 0 && visible && maxScroll > 0)
			{
				//trace(tweenCurrentCount);
				super.mouseWheel(e);
				
				scrollY -= e.delta * 10;
				scrollY = scrollY < 0?0:scrollY > maxScroll?maxScroll:scrollY;
				
				scrollIndicatorVisible = true;
				updateScrollIndicator();
			}
		}
		override protected function scrollIndicatorFadeout():void
		{
			super.scrollIndicatorFadeout();
			if (scrollIndicator.visible)addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
		}
		
		
		private function drag_mouseUpHandler_H(e:Event):void
		{
			if(isDragging) tweenCurrentCount *= MOUSE_DOWN_DECAY;
            else tweenCurrentCount *= DECAY;
			
            if (!isDragging)
            {
                var bouncing:Number = 0;
				
                if (scrollY < 0)
                {
                    bouncing = -scrollY * BOUNCING_SPRINGESS;
					
					//trace(scrollY,  BOUNCING_SPRINGESS,scrollY * BOUNCING_SPRINGESS);
                }else if ( scrollY > maxScroll) {
                    bouncing = (maxScroll-scrollY) * BOUNCING_SPRINGESS;
                }
                scrollY = scrollY + tweenCurrentCount + bouncing;
				//scrollY = scrollY < -(height * .5)?-(height * .5):scrollY > maxScroll+height * .5?maxScroll+height * .5:scrollY;
				updateScrollIndicator();
				
				if (scrollY >  maxScroll || scrollY < 0)
				{
					tweenCurrentCount *= .7;
				}
			///	trace(scrollY)
				if(Math.round(tweenCurrentCount) == Math.round(bouncing) || BOUNCING_SPRINGESS == Math.abs(bouncing))
				{
					tweenCurrentCount = 0;
					this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
					//////////////
					if (scrollIndicator.visible)addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
					viewContainer.mouseChildren = viewContainer.mouseEnabled = true;
					
					if (scrollY < 0)
                    {
                        TweenLite.to(this, 0.2, { scrollY:0, onComplete:ResizeScrollXY } );
                    }
                    else if (scrollY > this.maxScroll)
                    {
                        TweenLite.to(this, 0.2, { scrollY:maxScroll, onComplete:ResizeScrollXY } );
                    }
                    else
                    {
                        ResizeScrollXY();
                    }
				}
            }
		}	
		private function ResizeScrollXY() : void
        {
            if (parent)dispatchEvent(new ScrollEvent(ScrollEvent.COMPLETE));
        }
		/**
		 * 影藏滚动条
		 */
		private function scrollIndicatorFade_enterFrameHandler(e:Event):void
		{
			if (scrollIndicator.visible)
			{
				scrollIndicator.alpha -= scrollIndicatorAlphaDelta;
				if (scrollIndicator.alpha <= 0) {
					removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);				
					this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARCOMPLETE));
				}
			}
		}
		
		private function set scrollIndicatorVisible(value:Boolean):void
		{
			if (scrollIndicator)
			{
				removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
				scrollIndicator.alpha = value ? 1 : 0;
			}
		}
		
		private function updateScrollIndicator():void
		{
			
			var delta:Number = scrollY / maxScroll;
			var newHeight:Number;
			
			if (delta < 0)
			{
				scrollIndicator.y = Math.round(scrollIndicatorTopPadding);
				
				newHeight = scrollY + scrollIndicatorHeight;
				newHeight = Math.max(MIN_SCROLL_INDICATOR_HEIGHT, newHeight);
				scrollIndicator.height = Math.round(newHeight);
			}
			else if (delta < 1)
			{
				if (scrollIndicator.height != scrollIndicatorHeight)
					scrollIndicator.height = Math.round(scrollIndicatorHeight);
				
				var newY:Number = Math.round(delta * totalScrollAmount);
				newY = Math.min(_height - scrollIndicatorHeight - scrollIndicatorBottomPadding, newY);
				scrollIndicator.y = Math.round(newY + scrollIndicatorTopPadding);
			}
			else	// User dragged above the bottom edge.
			{
				// Shrink scrollIndicator.height by the amount a user has scrolled above the bottom edge.
				newHeight = scrollIndicatorHeight - (scrollY - maxScroll);
				newHeight = Math.max(MIN_SCROLL_INDICATOR_HEIGHT, newHeight);
				scrollIndicator.height = Math.round(newHeight);
				scrollIndicator.y = Math.round(_height - newHeight - scrollIndicatorBottomPadding);
			}
			
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARUPDATE));
		}
		//
		public function get MaxScrollHeight():Number
		{
			return maxScroll;
		}
		
		///////////////////
		override public function removeAt():void 
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_Y);
				this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);
				stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_Y);
				//stage.removeEventListener(Event.ENTER_FRAME, tween_enterFrameHandler_Y);
				removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
			}
			super.removeAt();			
		}
		
	}

}