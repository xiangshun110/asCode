package com.ucvcbbs.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class ScrollEvent extends Event
	{
		public static const SCROLLBARUPDATE:String = "scrollBarUpdate";
		public static const SCROLLBARBOOL:String = "scrollBarBool";
		public static const COMPLETE:String = "complete";
		public static const SCROLLBARCOMPLETE:String = "scrollBarComplete";
		
		public var data:Object;
		public function ScrollEvent(type:String,dispatchData:*=null) 
		{
			data = dispatchData;
			super(type);
		}
		
	}

}