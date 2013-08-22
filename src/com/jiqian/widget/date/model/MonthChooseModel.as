package com.jiqian.widget.date.model
{
	import com.jiqian.widget.date.events.DateChooseEvent;
	import com.jiqian.widget.date.skin.IButtonSkin;
	import com.jiqian.widget.date.TDateChooser;
	import com.jiqian.widget.date.view.MotionComponent;
	import com.jiqian.widget.date.view.TextAlign;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class MonthChooseModel extends MotionComponent
	{
		private var monthNames:Array;
		
		
		public function MonthChooseModel() 
		{
			this.init();
		}
		
		private function init():void
		{
			this.createButtons(3, 4);
			this.setMonthNames(TDateChooser.CN_MONTH_NAMES);
		}
		
		
		
		public function setMonthNames(names:Array):void
		{
			monthNames = names;
			
			for (var i:Number = 0; i < monthNames.length; i++ )
			{
				var tb:IButtonSkin = buttonAry[i] as IButtonSkin;
				tb.setText(monthNames[i]);
				tb.setAlign(TextAlign.CENTER);
				tb.setData(i);
			}
		}
		public function getMonthNames():Array
		{
			return monthNames;
		}
		
		
		
		
		/**
		 * 距焦月
		 * @param	v
		 */
		public function setFocusMonth(v:Number = 0):void
		{
			for each(var tb:IButtonSkin in buttonAry)
			{
				tb.setSelected(tb.getData() == v);
			}
		}
		
		
		
		protected var _year:Number;
		/**
		 * 所的年
		 */
		public function setFullYear(v:Number ):void
		{
			_year = v;
		}
		public function getFullYear():Number
		{
			return _year;
		}
		
		
		override public function moveLR(direction:Number):void 
		{
			super.moveLR(direction);
			this.setFullYear(this.getFullYear() - direction);
		}
		
		
		
		override protected function onChoose(e:MouseEvent):void
		{
			this.dispatchEvent(new DateChooseEvent(DateChooseEvent.CHOOSE_MONTH, new Date(this.getFullYear(), buttonAry.indexOf(e.currentTarget), 1)));
		}
		
		
		public function getPointByMonth(v:Number):Point
		{
			var tb:IButtonSkin = buttonAry[v];
			return new Point(tb.x + tb.getWidth() / 2, tb.y + tb.getHeight() / 2);
		}
		
		
	}
	
}