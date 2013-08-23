package com.ucvcbbs.downLoad 
{
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class LoadModel 
	{
		public var load:URLLoader;
		public var total:Number;
		public var endPoint:Number;
		public var startPoint:Number;
		public var fileName:String;
		public var progress:Number=0;
		public var request:URLRequest;
		public var url:String;
		public var tempFile:File;
		public var curFile:File;
		
		public function LoadModel() 
		{
			
		}
		
	}

}