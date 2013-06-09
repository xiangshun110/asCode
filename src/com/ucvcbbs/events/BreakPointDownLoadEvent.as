package com.ucvcbbs.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class BreakPointDownLoadEvent extends Event
	{
		
		public static const ONEITEMCOMPLETE:String = "oneItemComplete";
		public static const ALLCOMPLETE:String = "allComplete";
		
		public var netURL:String;
		public var localURL:String;
		
		public function BreakPointDownLoadEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,netUrl:String="",localUrl:String="") 
		{
			this.netURL = netUrl;
			this.localURL = localUrl;
			super(type, bubbles, cancelable);
		}
		
	}

}