package com.jiqian.widget.date.model 
{
	
	import com.jiqian.widget.date.events.DateChooseEvent;
	import com.jiqian.widget.date.skin.IButtonSkin;
	import com.jiqian.widget.date.view.MotionComponent;
	import com.jiqian.widget.date.view.TextAlign;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class YearChooseModel extends MotionComponent
	{
		
		private var _fullYear:Number;
		
		public function YearChooseModel() 
		{
			this.init();
		}
		
		
		private function init():void
		{
			this.createButtons(3, 4);
		}
		
		override protected function onChoose(e:MouseEvent):void
		{
			_fullYear = new Date(IButtonSkin(e.currentTarget).getData(), 1, 0).getFullYear();
			this.dispatchEvent(new DateChooseEvent(DateChooseEvent.CHOOSE_YEAR, new Date(IButtonSkin(e.currentTarget).getData(), 1, 0)));
		}
		
		
		
		public function getFullYear():Number
		{
			return _fullYear;
		}
		
		
		
		
		/**
		 * 取得动画中点点
		 * @param	year
		 * @return
		 */
		public function getPointByYear(year:Number):Point
		{
			for each(var tb:IButtonSkin in buttonAry)
			{
				if (Number(tb.getData()) == year)
				return new Point(tb.x + tb.width / 2, tb.y + tb.height / 2);
			}
			return new Point(getWidth() / 2, getHeight() / 2);
		}
		
		
		
		/**
		 * 要距焦的年
		 * @param	v
		 */
		public function setFocusYear(v:Number):void
		{
			setStartYear(v);
			for each(var tb:IButtonSkin in buttonAry)
			{
				tb.setSelected(tb.getData() == v);
			}
		}
		
		
		
		
		/**
		 * 起始年
		 * @param	v
		 */
		public function setStartYear(v:Number):void
		{
			v = Math.max(1900, Math.min(2099, v));
			v = Math.floor((v - 1900) / 10) * 10 + 1900;
			v = v - 1;
			_fullYear = v;
			for (var i:Number = 0; i < 12; i++ )
			{
				var va:Number = v + i;
				var tb:IButtonSkin = buttonAry[i] as IButtonSkin;
				tb.setText(String(va));
				tb.setData(Number(va));
				tb.setAlign(TextAlign.CENTER);
				tb.setTextVisible(va >= 1900 && va <= 2099);
			}
			buttonAry[00].setAshColor(true);
			buttonAry[11].setAshColor(true);
		}
		public function getStartYear():Number
		{
			return buttonAry[1].getData() as Number;
		}
		
		
		
		override public function getCanL():Boolean 
		{
			return getStartYear() > 1900;
		}
		
		override public function getCanR():Boolean 
		{
			return getEndYear() < 2099;
		}
		
		
		
		/**
		 * 终了年
		 * @return
		 */
		public function getEndYear():Number
		{
			return getStartYear() + 9;
		}
		
		
		
		override public function moveLR(direction:Number):void 
		{
			super.moveLR(direction);
			var nextStartYear:Number = this.getStartYear() - direction * 10;
			this.setFocusYear(nextStartYear);
		}
		
		
		
	}
	
}