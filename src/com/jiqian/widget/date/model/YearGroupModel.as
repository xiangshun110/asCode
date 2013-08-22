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
	public class YearGroupModel extends MotionComponent
	{
		
		public function YearGroupModel() 
		{
			this.init();
		}
		
		private function init():void
		{
			this.createButtons(3, 4);
		}
		
		
		
		
		/**
		 * 要距焦的年
		 * @param	v
		 */
		public function setFocusYear(v:Number):void
		{
			v = Math.max(1900, Math.min(2099, v));
			var fv:Number = v;
			v = Math.floor((v / 100)) * 100;
			
			this.setStartYear(v);
			for each(var tb:IButtonSkin in buttonAry)
			{
				tb.setSelected((tb.getData() <= fv ) && (Number(tb.getData() + 9) >= fv));
			}
		}
		
		
		
		private function setStartYear(year:Number):void
		{
			var v:Number = year;
			year = year - 10;
			for (var i:Number = 0; i < buttonAry.length; i++)
			{
				var tb:IButtonSkin = buttonAry[i] as IButtonSkin;
				tb.setText(year + "-\n" + (year + 9));
				tb.setData(year);
				tb.setAshColor(year < v || year > (v + 90));
				tb.setTextVisible(!(year < 1900 || year > 2099));
				tb.setAlign(TextAlign.CENTER);
				year += 10;
			}
		}
		
		
		
		public function getStartYear():Number
		{
			return Number(IButtonSkin(buttonAry[1]).getData());
		}
		public function getEndYear():Number
		{
			return Number(IButtonSkin(buttonAry[10]).getData() + 9);
		}
		
		
		
		override public function getCanL():Boolean 
		{
			return getStartYear() > 1900;
		}
		
		override public function getCanR():Boolean 
		{
			return getEndYear() < 2099;
		}
		
		
		
		
		public function getPointByYear(v:Number):Point
		{
			for each(var tb:IButtonSkin in buttonAry)
			{
				if ((tb.getData() <= v ) && (Number(tb.getData() + 9) >= v))
				{
					return new Point(tb.x + tb.width / 2, tb.y + tb.height / 2);
				}
			}
			return null;
		}
		
		
		
		
		
		
		override protected function onChoose(e:MouseEvent):void
		{
			this.dispatchEvent(new DateChooseEvent(DateChooseEvent.CHOOSE_YEAR, new Date(IButtonSkin(e.currentTarget).getData(), 1, 0)));
		}
		
		
		
		override public function moveLR(direction:Number):void 
		{
			super.moveLR(direction);
			this.setFocusYear(this.getStartYear() - direction * 100);
		}
		
		
		
	}
	
}