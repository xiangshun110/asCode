package com.jiqian.widget.date.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class DateChooseEvent extends Event 
	{
		public static const CHOOSE_YEAR:String 	= 'year';
		public static const CHOOSE_MONTH:String = 'month';
		public static const CHOOSE_DAY:String 	= 'day';
		
		
		public var date:Date;
		public function DateChooseEvent(type:String, date:Date, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			this.date = date;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DateChooseEvent(type, date, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DateChooseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}