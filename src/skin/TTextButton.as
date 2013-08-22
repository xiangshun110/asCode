package skin 
{
	import com.jiqian.widget.date.skin.IButtonSkin;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class TTextButton extends SimpleButton implements IButtonSkin
	{
		private var _uS:BSprite;
		private var _oS:BSprite;
		private var _dS:BSprite;
		
		//.
		private var _tS:BSprite;
		
		public function TTextButton() 
		{
			_uS = new BSprite(0);
			_oS = new BSprite(0.5, 0x0000FF);
			_dS = new BSprite(1.0);
			_tS = new BSprite(1, 0x0000FF);
			_tS.filters = [new GlowFilter(0x0000FF, 0.7, 3, 3)];
			
			this.upState = _uS;
			this.overState = _oS;
			this.downState = _dS;
			this.hitTestState = _uS;
			
			this.useHandCursor = false;
		}
		
		public function setSelected (b:Boolean) : void
		{
			//if (isToday) return;
			this.upState = b ? _dS : _uS;
			if (!b)
			{
				setIsToday(isToday);
			}
		}

		public function getSelected () : Boolean
		{
			return this.upState == _oS;
		}

		
		private var isToday:Boolean;
		/**
		 * 设置是否为今天
		 * @param	b
		 */
		public function setIsToday (b:Boolean) : void
		{
			isToday = b;
			_uS.filters = b ? [new GlowFilter(0x0000FF, 0.7, 2, 2)] : [];
			//this.upState = b ? _tS : _uS;
		}

		public function getDisplay () : DisplayObject
		{
			return this as DisplayObject
		}

		/**
		 * 设宽
		 * @param	v
		 */
		public function setWidth (v:Number) : void
		{
			_oS.width = _uS.width = _dS.width = _tS.width = v;
		}

		public function getWidth () : Number
		{
			return _oS.width;
		}

		/**
		 * 高
		 * @param	v
		 */
		public function setHeight (v:Number) : void
		{
			_oS.height = _uS.height = _dS.height = _tS.height = v;
		}

		public function getHeight () : Number
		{
			return _oS.height;
		}

		/**
		 * 灰色的
		 * @param	b
		 */
		public function setAshColor (b:Boolean) : void
		{
			_uS.setColor(b ? 0x999999 : 0x000000);
		}

		private var text:String;
		/**
		 * 设置按钮的文字
		 * @param	str
		 */
		public function setText (str:String) : void
		{
			text = str;
			_uS.setText(str);
			_oS.setText(str);
			_dS.setText(str);
			_tS.setText(str);
		}

		public function setTextVisible (b:Boolean) : void
		{
			this.mouseEnabled = b;
			_uS.setText(b ? text : '');
		}

		/**
		 * 设置文本对齐方式
		 * @param	v
		 */
		public function setAlign (v:String) : void
		{
			_uS.setAlign(v);
			_oS.setAlign(v);
			_dS.setAlign(v);
		}

		
		private var data:Object;
		/**
		 * 带一点数据吧
		 * @param	v
		 */
		public function setData (v:Object) : void
		{
			data = v;
		}

		public function getData () : Object
		{
			return data;
		}
	}
	
}