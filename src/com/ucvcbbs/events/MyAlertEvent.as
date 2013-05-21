package com.ucvcbbs.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class MyAlertEvent extends Event
	{
		public static const YES:String = "yes";
		public static const NO:String = "no";
		
		public var data:Object;
		public function MyAlertEvent(type:String,dispatchData:*=null) 
		{
			data = dispatchData;
			super(type);
		}
		
	}

}