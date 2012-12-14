﻿package com.ucvcbbs.scroll{	import com.ucvcbbs.events.ScrollEvent;	import flash.display.DisplayObjectContainer;	import flash.display.Sprite;	/**	 * ...	 * @author CameraGame	 */	public class MWHScrollBar extends Sprite	{		private var viewContainer:Sprite;		private var mHScrollBar:MHScrollBar;		private var mWScrollBar:MWScrollBar;		private var backgroundColor:Number;		protected var _width:Number;		protected var _height:Number;				public static const SCROLLBARNAME:String = "Ray_MWHScrollBar";				/**		 * MWHScrollBar  移动版 横竖向滚动条		 * view				滚动的对象		 * backgroundColor   背景颜色		 * scrollIndicatorTopPadding  竖向头部间距		 * scrollIndicatorBottomPadding		竖向底部间距		 * scrollIndicatorLeftPadding  横向左边间距		 * scrollIndicatorRightPadding	 横向右边间距		 * ...		 * @author		 */		public function MWHScrollBar(view:DisplayObjectContainer, backgroundColor:Number = 0xffffff,									scrollIndicatorTopPadding:Number=0,									scrollIndicatorBottomPadding:Number=0,									scrollIndicatorLeftPadding:Number=0,									scrollIndicatorRightPadding:Number=0) 		{			//super(true);			viewContainer = new Sprite();			viewContainer.name =  MWHScrollBar.SCROLLBARNAME;			addChild(viewContainer);			viewContainer.addChild(view);						backgroundColor = backgroundColor;			//			mHScrollBar = new MHScrollBar(viewContainer, backgroundColor, scrollIndicatorTopPadding, scrollIndicatorBottomPadding);			addChild(mHScrollBar);			mWScrollBar = new MWScrollBar(viewContainer, backgroundColor, scrollIndicatorLeftPadding, scrollIndicatorRightPadding);			addChild(mWScrollBar);						mHScrollBar.addEventListener(ScrollEvent.SCROLLBARUPDATE,updateScrollbar);			mWScrollBar.addEventListener(ScrollEvent.SCROLLBARUPDATE,updateScrollbar);		}		private function updateScrollbar(evt:ScrollEvent):void		{			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLLBARUPDATE));		}				public function refreshView(vole:Boolean):void		{			mHScrollBar.height = _height;			mHScrollBar.width = _width;			mHScrollBar.refreshView(vole);			mWScrollBar.height = _height;			mWScrollBar.width = _width;			mWScrollBar.refreshView(vole);						graphics.clear();			graphics.beginFill(backgroundColor,0);			graphics.drawRect(0, 0, width, height);		}				//获取滚动对象		public function get ScrollViewContainer():Sprite		{			return viewContainer;		}				override public function set height(value:Number):void		{			if (value != _height)			{				_height = value;			}		}				override public function get height():Number		{			return _height;		}				override public function set width(vole:Number):void		{			if (vole != _width)			{				_width = vole;			}		}		override public function get width():Number		{			return _width;		}	}}