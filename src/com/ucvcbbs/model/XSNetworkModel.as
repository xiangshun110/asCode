package com.ucvcbbs.model 
{
	/**
	 * ...
	 * @author xiangshun
	 */
	public class XSNetworkModel 
	{
		
		/**
		 * 事件类型
		 */
		public var type:String;
		
		/**
		 * 错误信息
		 */
		public var error_msg:String;
		
		/**
		 * 数据
		 */
		public var data:Object;
		
		/**
		 * 由服务器返回的 HTTP 状态代码。
		 */
		public var httpCode:int;
		
		public function XSNetworkModel() 
		{
			
		}
		
	}

}