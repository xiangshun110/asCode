package com.jiqian.widget.date.skin 
{
	import com.jiqian.widget.date.skin.IButtonSkin;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class DefaultButtonSkin extends SimpleButton implements IButtonSkin
	{
		
		public static const UP_COLOR:Array 			= [0xFFFFFF, 0xFFFFFF, 0x000000];
		public static const OVER_COLOR:Array 		= [0x017A22, 0x96FEB3, 0x017A22];
		public static const DOWN_COLOR:Array 		= [0x017A22, 0x96FEB3, 0x017A22];
		public static const SELECTED_COLOR:Array 	= [0x460046, 0x68F968, 0x460046];
		
		
		protected var _upState:TextSprite;
		protected var _overState:TextSprite;
		protected var _downState:TextSprite;
		
		
		public function DefaultButtonSkin() 
		{
			this.init();
			this.useHandCursor = false;
		}
		
		protected function init():void
		{
			_upState = new TextSprite;
			_upState.drawBorder(0, UP_COLOR);
			_upState.setColor(SELECTED_COLOR[2]);
			_overState = new TextSprite;
			_overState.drawBorder(1, OVER_COLOR);
			_overState.setColor(OVER_COLOR[2]);
			_downState = new TextSprite;
			_downState.drawBorder(1, DOWN_COLOR);
			_downState.setColor(DOWN_COLOR[2]);
			
			this.upState = _upState;
			this.overState = _overState;
			this.downState = _downState;
			this.hitTestState = this.upState;
			
		}
		
		
		
		protected var _selected:Boolean;
		//被选中状态
		public function setSelected(b:Boolean):void
		{
			_selected = b;
			if (_isToday) return;
			_upState.drawBorder(b ? 1 : 0, b ? SELECTED_COLOR : UP_COLOR);
		}
		public function getSelected():Boolean
		{
			return _selected;
		}
		
		
		
		
		
		
		
		private var _isToday:Boolean;
		/**
		 * 设置是否为今天
		 * @param	b
		 */
		public  function setIsToday(b:Boolean):void
		{
			_isToday = b;
			if (_isToday)
			{
				_upState.drawBorder(1, SELECTED_COLOR);
				_upState.setColor(SELECTED_COLOR[2]);
			}
			else
			{
				_upState.drawBorder(0, UP_COLOR);
			}
		}
		
		
		
		
		
		
		public function getDisplay():DisplayObject
		{
			return this as DisplayObject;
		}
		
		
		
		/**
		 * 设宽
		 * @param	v
		 */
		public function setWidth(v:Number):void
		{
			_upState.setWidth(v);
			_overState.setWidth(v);
			_downState.setWidth(v);
		}
		public function getWidth():Number
		{
			return _upState.getWidth();
		}
		
		
		/**
		 * 高
		 * @param	v
		 */
		public function setHeight(v:Number):void
		{
			_upState.setHeight(v);
			_overState.setHeight(v);
			_downState.setHeight(v);
		}
		public function getHeight():Number
		{
			return _upState.getHeight();
		}
		
		
		/**
		 * 灰色的
		 * @param	b
		 */
		public function setAshColor(b:Boolean):void
		{
			alpha = b ? 0.3 : 1;
			_upState.setColor(b ? 0x777777 : UP_COLOR[2]);
		}
		
		
		/**
		 * 设置按钮的文字
		 * @param	str
		 */
		public function setText(str:String):void
		{
			_upState.setText(str);
			_overState.setText(str);
			_downState.setText(str);
		}
		public function setTextVisible(b:Boolean):void
		{
			this.upState = b ? _upState : null;
			this.mouseEnabled = b;
		}
		
		
		/**
		 * 设置文本对齐方式
		 * @param	v
		 */
		public function setAlign(v:String):void
		{
			_upState.setAlign(v);
			_overState.setAlign(v);
			_downState.setAlign(v);
		}
		
		
		private var _data:Object;
		/**
		 * 带一点数据吧
		 * @param	v
		 */
		public function setData(v:Object):void {
			_data = v;
		}
		public function getData():Object {
			return _data;
		}
		
		
	}
	
}

/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	import com.jiqian.display.Pen;
	import com.jiqian.widget.date.view.TextAlign;
	import com.jiqian.widget.date.skin.DefaultButtonSkin;
	import flash.display.JointStyle;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	class TextSprite extends Sprite
	{
		private var _number:Number;
		private var _textfield:TextField;
		
		private var _pen:Pen;
		private var _base:Shape;
		
		private var _width:Number = 20;
		private var _height:Number = 20;
		
		public function TextSprite(v:Number = NaN)
		{
			_number = v || 0;
			this.init();
		}
		
		
		
		private function init():void
		{
			_base = new Shape;
			_pen = new Pen(_base.graphics);
			
			_textfield = new TextField;
			_textfield.autoSize = 'left';
			_textfield.filters = [new GlowFilter(0,0)];
			addChild(_base);
			addChild(_textfield);
			
			this.mouseChildren = false;
		}
		
		
		private var dAlpha:Number;
		private var dColors:Array;
		public function drawBorder(nAlpha:Number = 0.3, aColors:Array = null):void
		{
			dAlpha = nAlpha;
			aColors = aColors || DefaultButtonSkin.UP_COLOR;
			dColors = aColors.concat();
			
			_pen.clear();
			_pen.lineStyle(0, aColors[0], nAlpha, true);
			_pen.beginFill(aColors[1], nAlpha);
			_pen.drawRect(0, 0, _width - 2, _height - 2);
			_pen.endFill();
			
		}
		
		
		public function setWidth(v:Number):void
		{
			_width = v;
			this.drawBorder(dAlpha, dColors);
			this.align();
		}
		public function getWidth():Number { return _width; }
		
		
		public function setHeight(v:Number):void
		{
			_height = v;
			this.drawBorder(dAlpha, dColors);
			this.align();
		}
		public function getHeight():Number { return _height; }
		
		
		
		public function setColor(c:Number):void
		{
			var tf:TextFormat = _textfield.getTextFormat();
			tf.color = c;
			dColors && (dColors[2] = c);
			
			_textfield.setTextFormat(tf);
			_textfield.defaultTextFormat = tf;
		}
		
		public function setText(v:String):void
		{
			_textfield.text = v;
			this.align();
		}
		
		
		public function setAlign(v:String):void
		{
			alignType = v;
			this.align();
		}
		
		
		private var alignType:String = "right";
		/**
		 * 对齐方式
		 */
		public function align():void
		{
			switch(alignType)
			{
				case TextAlign.LEFT:
				_textfield.x = 0;
				break;
				case TextAlign.CENTER:
				_textfield.x = Math.floor((_width - _textfield.width) / 2);
				break;
				case TextAlign.RIGHT:
				_textfield.x = _width - _textfield.width - 2;
				break;
			}
			_textfield.y = (_height - _textfield.height) / 2;
		}
		
	}
