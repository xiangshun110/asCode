package com.ucvcbbs.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author xiangshun
	 * @time 2013/9/27 18:00:02
	 */
	public class NetworkEvent extends Event
	{
		public static const NETINFO:String = "netInfo";
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public var data:Object;
		public function NetworkEvent(type:String,dispatchData:*=null) 
		{
			data = dispatchData;
			super(type);
		}
		
	}

}