﻿package com.ucvcbbs.scroll{	import com.greensock.TweenLite;	import com.ucvcbbs.events.ScrollEvent;	import com.ucvcbbs.utils.AppTools;	import com.ucvcbbs.utils.SystemName;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.MouseEvent;	import flash.geom.Rectangle;	import flash.events.Event;	import flash.utils.getTimer;	import com.greensock.easing.Quad;	//import mx.effects.easing.Quartic;	import flash.display.DisplayObjectContainer;	/**	 * 滚动条主类	 * 移动版 滚动条 横向滚动条	 * ...	 * @author ScrollIndicator  by Ray	 */	public class MWIOSScrollBar extends ScrollIndicator	{				/**		 * The difference between the scrollIndicator.height and _height.		 */		private var totalScrollAmount:Number;		/**		 * 头部间距		 */		private var scrollIndicatorLeftPadding:Number;		/**		 * 底部间距		 */		private var scrollIndicatorRightPadding:Number;			/**		 * The target scroll value when a user flicks.		 */		private var targetScrollX:Number;		//		private var itemYOffsetBottom:Number = 0;			    private var scrollIndicator:ScrollSkin;				//		private var backgroundColor:Number;				private var resetScrollX:Boolean = false;				//		private var maxScroll:Number;		private var scrollIndicatorWidth:Number;		//拖拽的y		private var previousDragMouseX:Number;		private var mouseXDown:Number;				private var deltaMouseX:Number = 0;		//初始化时间		private var previousDragTime:uint;		/**		 * The scrollY when a user first starts to drag.		 */		private var beginDragScrollX:Number;		private var enterFrameIndex:Number = 0;		//		public var isDragging:Boolean = false;		/**		 * Flag for whether or not the flick tween is still playing.		 */		private var isTweening:Boolean;		/**		 * The start scroll value when a user flicks.		 */		private var startScrollX:Number;		/**		 * The total amount to scroll when a user flicks.		 */		private var totalScrollX:Number;		/**		 * Properties for tweening a user flick.		 */		private var tweenCurrentCount:Number = 0;		private var tweenTotalCount:Number = 0;						/**		 * MWScrollBar 移动版 横向滚动条		 * view			滚动的对象		 * backgroundColor   背景颜色		 * scrollIndicatorLeftPadding  左边间距		 * scrollIndicatorRightPadding	 右边间距		 * ...		 * @author		 */		public function MWIOSScrollBar(									view:DisplayObjectContainer,									backgroundColor:Number = 0xffffff,									scrollIndicatorLeftPadding:Number=0,									scrollIndicatorRightPadding:Number=0)		{			if (view && view.name != MWHIOSScrollBar.SCROLLBARNAME) {				viewContainer.addChild(view);			}			else {				MWHScrollBarBOOL = true;				viewContainer = view as Sprite;			}						if (!scrollIndicator)			{				scrollIndicator = new ScrollSkin("W");				addChild(scrollIndicator);				scrollIndicatorVisible = false;			}			//			this.backgroundColor = backgroundColor;			this.scrollIndicatorLeftPadding = scrollIndicatorLeftPadding;			this.scrollIndicatorRightPadding = scrollIndicatorRightPadding;		}				public function refreshView(vole:Boolean):void		{			/*if (stage)			stage.removeEventListener(Event.ENTER_FRAME, tween_enterFrameHandler_W);*/						resetScrollX = vole;						this.updateX(width, height);						resetScrollX = false;						viewContainer.mouseChildren = viewContainer.mouseEnabled = true;						this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARUPDATE));		}				//是否显示滚动条		public function set IndicatorVisible(vole:Boolean):void		{			scrollIndicator.visible = vole;		}				//		private function updateX(width:Number, height:Number):void		{						if (resetScrollX)			{				stopTween();			}						updateMaxScroll();						if (resetScrollX || !viewContainer.scrollRect)			{				viewContainer.scrollRect = new Rectangle(0, 0, width, height);			}			else			{				//当前拖动到的y				scrollX = Math.min(maxScroll, scrollX);				viewContainer.scrollRect = new Rectangle(scrollX, 0, width, height);			}						if (!MWHScrollBarBOOL)			{				graphics.clear();				graphics.beginFill(backgroundColor,0);				graphics.drawRect(0, 0, width, height);			}		}		/**		 * Stops the flick tween.		 */		private function stopTween():void		{						this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);			tweenCurrentCount = 0;						scrollIndicatorVisible = false;		}				private function updateMaxScroll():void		{			var getdisplayContact:DisplayObjectContainer = viewContainer.getChildAt(0) as DisplayObjectContainer;			if (getdisplayContact.width > 0)			{				maxScroll = Math.round(getdisplayContact.width - width) + itemYOffsetBottom;				//trace("W",maxScroll);				if (maxScroll > 0)				{					var availableWidth:Number = width - scrollIndicatorLeftPadding - scrollIndicatorRightPadding;					////trace(availableWidth);					scrollIndicatorWidth = Math.max(Math.round((availableWidth / getdisplayContact.width) * availableWidth), MIN_SCROLL_INDICATOR_HEIGHT);					////trace(viewContainer.height,scrollIndicatorWidth);					scrollIndicator.width = scrollIndicatorWidth;										scrollIndicator.x = scrollIndicatorLeftPadding;					scrollIndicator.y = height - scrollIndicator.HEIGHT - scrollIndicatorLeftPadding;					totalScrollAmount = availableWidth - scrollIndicatorWidth;									}				else				{					maxScroll = 0;				}			}		}						override protected function mouseDownHandler(evt:MouseEvent):void 		{			//super.mouseDownHandler(evt);									if (maxScroll.toString() == "NaN")			{				updateMaxScroll();			}			if (maxScroll == 0) return;						isDragging = true;			mouseXDown = previousDragMouseX = root.mouseX;			tweenCurrentCount = 0;			beginDragScrollX = scrollX;						TweenLite.killTweensOf(this);						this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);						stage.addEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_W);			stage.addEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_X);									this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);		}		//放开事件		private function drag_mouseUpHandler_X(e:MouseEvent):void		{			if (stage)			{				stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_W);				stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_X);			}			isDragging = false;					/*if (scrollY<0 || scrollY>maxScroll)			{*/				this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);			/*}*/						if (AppTools.getSystemName() == SystemName.LINUX) {				ProhibitedDrag = true;			}								}		private function detectDirection_mouseMoveHandler_W(e:Event):void		{			if (!MWHScrollBarBOOL) {					e.stopImmediatePropagation();					e.stopPropagation();							}						if (AppTools.getSystemName() == SystemName.LINUX) {				if (Math.abs(root.mouseX - previousDragMouseX) > 50 && ProhibitedDrag)				{					mouseXDown = previousDragMouseX = root.mouseX;					ProhibitedDrag = false;				}							}												if (ProhibitedDrag) return;									this.scrollIndicatorFadeout();						/*if (!this.hasEventListener(Event.ENTER_FRAME)) 			{				this.addEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_H);			}			*/			viewContainer.mouseChildren = viewContainer.mouseEnabled = false;						var initDownX:Number =previousDragMouseX - root.mouseX;						//trace(scrollY , (previousDragMouseY - root.mouseY) * (scrollY < 0?.5:scrollY>maxScroll?.5:1),(beginDragScrollY + (previousDragMouseY - root.mouseY)) * (scrollY < 0?.5:scrollY>maxScroll?.5:1));			scrollX = (beginDragScrollX + initDownX * (scrollX < 0?.5:scrollX>maxScroll?.5:1));			//scrollY = scrollY < -(height * .5)?-(height * .5):scrollY > maxScroll+height * .5?maxScroll+height * .5:scrollY;						if (beginDragScrollX + initDownX <= 0 || beginDragScrollX + initDownX>=maxScroll) {					beginDragScrollX = scrollX;					previousDragMouseX = root.mouseX;			}						tweenCurrentCount += (mouseXDown - root.mouseX) * SPEED_SPRINGNESS;						mouseXDown = root.mouseX;						updateScrollIndicator();			scrollIndicatorVisible = true;						//////////////		}		override protected function mouseWheel(e:MouseEvent):void 		{			e.stopPropagation();			if (tweenCurrentCount == 0 && visible && maxScroll > 0)			{				//trace(tweenCurrentCount);				super.mouseWheel(e);								scrollX -= e.delta * 10;				scrollX = scrollX < 0?0:scrollX > maxScroll?maxScroll:scrollX;								scrollIndicatorVisible = true;				updateScrollIndicator();			}		}		override protected function scrollIndicatorFadeout():void		{			super.scrollIndicatorFadeout();			if (scrollIndicator.visible)addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);		}						private function drag_mouseUpHandler_W(e:Event):void		{			//			if(isDragging) tweenCurrentCount *= MOUSE_DOWN_DECAY;            else tweenCurrentCount *= DECAY;			            if (!isDragging)            {                var bouncing:Number = 0;				                if (scrollX < 0)                {                    bouncing = -scrollX * BOUNCING_SPRINGESS;										//trace(scrollY,  BOUNCING_SPRINGESS,scrollY * BOUNCING_SPRINGESS);                }else if ( scrollX > maxScroll) {                    bouncing = (maxScroll-scrollX) * BOUNCING_SPRINGESS;                }                scrollX = scrollX + tweenCurrentCount + bouncing;				//scrollY = scrollY < -(height * .5)?-(height * .5):scrollY > maxScroll+height * .5?maxScroll+height * .5:scrollY;				updateScrollIndicator();								if (scrollX >  maxScroll || scrollX < 0)				{					tweenCurrentCount *= .7;				}								if(Math.round(tweenCurrentCount) == Math.round(bouncing) || BOUNCING_SPRINGESS == Math.abs(bouncing))				{					tweenCurrentCount = 0;					this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);					//////////////					if (scrollIndicator.visible)addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);					viewContainer.mouseChildren = viewContainer.mouseEnabled = true;										if (scrollX < 0)                    {                        TweenLite.to(this, 0.2, {scrollX:0, onComplete:ResizeScrollXY});                    }                    else if (scrollX > this.maxScroll)                    {                        TweenLite.to(this, 0.2, {scrollX:maxScroll, onComplete:ResizeScrollXY});                    }                    else                    {                        ResizeScrollXY();                    }				}            }		}		private function ResizeScrollXY() : void        {            if (parent) dispatchEvent(new ScrollEvent(ScrollEvent.COMPLETE));        }		/**		 * 影藏滚动条		 */		private function scrollIndicatorFade_enterFrameHandler(e:Event):void		{			scrollIndicator.alpha -= scrollIndicatorAlphaDelta;			if (scrollIndicator.alpha <= 0) {				viewContainer.mouseChildren = viewContainer.mouseEnabled = true;				removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);								this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARCOMPLETE));			}		}				private function set scrollIndicatorVisible(value:Boolean):void		{			if (scrollIndicator)			{				removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);				scrollIndicator.alpha = value ? 1 : 0;			}		}				private function updateScrollIndicator():void		{			var delta:Number = scrollX / maxScroll;			var newWidth:Number;			if (delta < 0)			{				scrollIndicator.x = Math.round(scrollIndicatorLeftPadding);								newWidth = scrollX + scrollIndicatorWidth;				newWidth = Math.max(MIN_SCROLL_INDICATOR_HEIGHT, newWidth);				scrollIndicator.width = Math.round(newWidth);			}			else if (delta < 1)			{				if (scrollIndicator.width != scrollIndicatorWidth)					scrollIndicator.width = Math.round(scrollIndicatorWidth);								var newY:Number = Math.round(delta * totalScrollAmount);				newY = Math.min(_width - scrollIndicatorWidth - scrollIndicatorRightPadding, newY);				scrollIndicator.x = Math.round(newY + scrollIndicatorLeftPadding);			}			else	// User dragged above the bottom edge.			{				// Shrink scrollIndicator.height by the amount a user has scrolled above the bottom edge.				newWidth = scrollIndicatorWidth - (scrollX - maxScroll);				newWidth = Math.max(MIN_SCROLL_INDICATOR_WIDTH, newWidth);				scrollIndicator.width = Math.round(newWidth);				scrollIndicator.x = Math.round(_width - newWidth - scrollIndicatorRightPadding);			}			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARUPDATE));		}		//		public function get MaxScrollWidth():Number		{			return maxScroll;		}						///////////////////		override public function removeAt():void 		{			if (stage)			{				stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler_W);				this.removeEventListener(Event.ENTER_FRAME, drag_mouseUpHandler_W);				stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler_X);				//stage.removeEventListener(Event.ENTER_FRAME, tween_enterFrameHandler_Y);				removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);			}			super.removeAt();					}			}}