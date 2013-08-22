package com.jiqian.widget.date.view
{
	import com.jiqian.display.Pen;
	import com.jiqian.tween.gs.easing.Strong;
	import com.jiqian.tween.gs.TweenMax;
	import com.jiqian.widget.date.skin.DefaultButtonSkin;
	import com.jiqian.widget.date.skin.IButtonSkin;
	import com.jiqian.widget.date.TDateChooser;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class MotionComponent extends Sprite
	{
		public static function getSkinClass():Class
		{
			return TDateChooser.skinClassRef || DefaultButtonSkin;
		}
		
		public static const ZOOM_IN:Number = 0;
		public static const ZOOM_OUT:Number = 1;
		
		public static const LEFT:Number = -1;
		public static const RIGHT:Number = 1;
		
		
		protected var _pen:Pen;
		protected var _content:Sprite;
		
		
		
		
		
		public function MotionComponent() 
		{
			_content = new Sprite;
			_pen = new Pen(_content.graphics);
			super.addChild(_content);
			//画边框
			this.drawBase(getWidth(), getHeight(), NaN, 0xDAF7FC, 0);
		}
		
		
		
		/**
		 * 画底
		 * @param	nW
		 * @param	nH
		 * @param	nLineColor
		 * @param	nFillColor
		 * @param	nFillAlpha
		 */
		public function drawBase(nW:Number, nH:Number, nLineColor:Number = NaN, nFillColor:Number = 0x0, nFillAlpha:Number = 1):void
		{
			_pen.clear();
			
			if (nLineColor) _pen.lineStyle(1, nLineColor);
			else _pen.lineStyle(1, 0, 0);
			
			_pen.beginFill(nFillColor, nFillAlpha);
			_pen.drawRect(0, 0, nW, nH);
			_pen.endFill();
		}
		
		
		
		/**
		 * 取得画笔
		 * @return
		 */
		public function getPen():Pen
		{
			return _pen;
		}
		
		
		/**
		 * 真正的容器
		 * @return
		 */
		public function getContent():Sprite
		{
			return _content;
		}
		
		
		
		protected var buttonAry:Array;
		protected var oX:int;
		protected var oY:int;
		/**
		 * 生成按钮
		 * @param	nI
		 * @param	nJ
		 */
		public function createButtons(nI:Number = 3, nJ:Number = 4):void
		{
			buttonAry = [];
			oX = this.getWidth() / 4;
			oY = this.getHeight() / 3;
			
			var ref:Class = getSkinClass();
			
			for (var i:Number = 0; i < nI; i++)
			{
				for (var j:Number = 0; j < nJ; j++)
				{
					var tb:IButtonSkin = new ref() as IButtonSkin;
					tb.x = oX * j + 1;
					tb.y = oY * i;
					tb.setWidth(oX);
					tb.setHeight(oY);
					tb.addEventListener(MouseEvent.CLICK, onChoose);
					this.addChild(tb.getDisplay());
					this.buttonAry.push(tb);
				}
			}
		}
		protected function onChoose(e:MouseEvent):void
		{
			
		}
		
		
		
		
		
		
		
		private var _motionTW:TweenMax;
		private var _motionRef:Bitmap;
		/**
		 * 动画入
		 */
		public function motionIn(zoom:Number = NaN, pos:Point = null):void
		{
			if (_motionTW) {
				_motionTW.pause();
				_motionTW.complete();
			}
			
			getContent().visible = false;
			pos = pos || new Point(0, 0);
			zoom = zoom || ZOOM_IN;
			
			//动画参数
			var arg0:Array = [[ -pos.x, -pos.y, getContent().width * 2.0, getContent().height * 2.0, 0]];
			var arg1:Array = [[pos.x - getContent().width * 0.2 / 2, pos.y - getContent().height * 0.2 / 2, getContent().width * 0.2, getContent().height * 0.2, 0]];
			var args:Array = zoom == ZOOM_IN ? arg0 : arg1;
			
			//描画content
			var _bmp:BitmapData = new BitmapData(getContent().width, getContent().height, true, 0x00FFFFFF);
			_bmp.draw(getContent());
			_motionRef = new Bitmap(_bmp, 'auto', true);
			_motionRef.x		= args[0][0];
			_motionRef.y		= args[0][1];
			_motionRef.width 	= args[0][2];
			_motionRef.height 	= args[0][3];
			_motionRef.alpha 	= args[0][4];
			
			super.addChild(_motionRef);
			
			//动画效果
			_motionTW = TweenMax.to(_motionRef, 0.4, { alpha:1, x:0, y:0, width:getContent().width, height:getContent().height, onComplete:onMotionInComplete, ease:Strong.easeIn } );
		}
		protected function onMotionInComplete():void
		{
			getContent().visible = true;
			x = y = 0;
			super.removeChild(_motionRef);
			_motionRef.bitmapData.dispose();
			_motionTW = null;
		}
		
		
		
		
		
		
		
		/**
		 * 动画出
		 */
		public function motionOut(zoom:Number = NaN, pos:Point = null):void
		{
			if (_motionTW) {
				_motionTW.pause();
				_motionTW.complete();
			}
			
			pos = pos || new Point(getContent().width / 2, getContent().height / 2);
			getContent().visible = false;
			
			var _cWidth:Number = getContent().width;
			var _cHeight:Number = getContent().height;
			//动画参数
			var arg1:Array = [[ -pos.x, -pos.y, width * 2, height * 2]];
			var arg0:Array = [[pos.x * 4 / 5, pos.y * 4 / 5, _cHeight / 5, _cHeight / 5]];
			var args:Array = (zoom == ZOOM_IN ? arg0 : arg1);
			
			//描画content
			var _bmp:BitmapData = new BitmapData(_cWidth, _cHeight, true, 0x00FFFFFF);
			_bmp.draw(getContent());
			_motionRef = new Bitmap(_bmp, 'auto', true);
			
			super.addChild(_motionRef);
			//动画效果
			_motionTW = TweenMax.to(_motionRef, 0.4, { alpha:0, ease:Strong.easeIn, x:args[0][0], y:args[0][1], width:args[0][2], height:args[0][3], onComplete:onMotionOutComplete } );
		}
		
		protected function onMotionOutComplete():void
		{
			getContent().visible = false;
			x = y = 0;
			super.removeChild(_motionRef);
			_motionRef.bitmapData.dispose();
			_motionRef = null;
			_motionTW = null;
		}
		
		
		
		
		
		protected var moveTW:TweenMax;
		//移动
		public function moveTo(pos:Point, motion:Boolean = true, delay:Number = 0.5):void
		{
			moveTW && moveTW.pause();
			delay = motion ? delay : 0;
			moveTW = TweenMax.to(this, delay, { x:pos.x, y:pos.y, onComplete:onMoveComplete} );
			
		}
		protected function onMoveComplete():void
		{
			if (_lrmotionRef)_lrmotionRef.bitmapData.dispose();
		}
		
		
		
		private var _lrmotionRef:Bitmap;
		/**
		 * 左右移动过渡效果
		 * @param	direction
		 */
		public function moveLR(direction:Number):void
		{
			var _cWidth:Number = getContent().width;
			var _cHeight:Number = getContent().height;
			//描画content
			var _bmp:BitmapData = new BitmapData(_cWidth, _cHeight, true, 0x00FFFFFF);
			_bmp.draw(getContent());
			
			_lrmotionRef && removeChild(_lrmotionRef);;
			_lrmotionRef = new Bitmap(_bmp, 'auto', true);
			_lrmotionRef.x = direction * this.getWidth();
			x = -_lrmotionRef.x;
			
			this.addChild(_lrmotionRef);
			this.moveTo(new Point(0, 0));
		}
		
		
		
		/**
		 * 能向左移？
		 * @return boolean
		 */
		public function getCanL():Boolean
		{
			return true;
		}
		
		
		
		/**
		 * 能向右移？
		 * @return boolean
		 */
		public function getCanR():Boolean
		{
			return true;
		}
		
		
		
		public function getWidth():Number
		{
			return 197;
		}
		
		public function getHeight():Number
		{
			return 150;
		}
		
		
		public function setVisible(b:Boolean):void
		{
			_content.visible = b;
		}
		
		
		
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return _content.addChild(child);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			return _content.addChildAt(child, index);
		}
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			return _content.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject 
		{
			return _content.removeChildAt(index);
		}
		
		override public function get width():Number { return _content.width; }
		
		override public function set width(value:Number):void 
		{
			_content.width = value;
		}
		override public function get height():Number { return _content.height; }
		
		override public function set height(value:Number):void 
		{
			_content.height = value;
		}
		
		
		
		
	}
	
}