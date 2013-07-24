package com.ucvcbbs.utils 
{
	/**
	 * ...
	 * @author xiangshun
	 */
	public class NetworkToolsForWeb 
	{
		
		public function NetworkToolsForWeb() 
		{
			
		}
		
		/**
		 * 获取SWF所在站点的根URL，比如:http://www.test.com/das/da.swf就得到http://www.test.com
		 * @param	stage
		 */
		public static function getRemoteRootURL(stage:Stage):String {
			var str:String = stage.loaderInfo.loaderURL;
			var num1:int = str.indexOf("://");
			if(num1!=-1){
				var str2:String = str.substr(num1 + 3);
				var num2:int = str2.indexOf("/");
				var url:String = str.substring(0, num1 + 3 + num2);
			}else {
				url = "";
			}
			return url;
		}
		
	}

}