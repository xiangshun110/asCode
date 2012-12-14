package com.ucvcbbs.utils 
{
	import flash.filesystem.File;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class AppTools 
	{
		
		public function AppTools() 
		{
			
		}
		
		/**
		 * 应用程序所在的目录
		 * @return
		 */
		public static function getAppPath():String {
			return File.applicationDirectory.nativePath;	
		}
		
		/**
		 * 应用程序所在的目录URL
		 * @return
		 */
		public static function getAppURL():String {
			return File.applicationDirectory.url;
		}
		
		/**
		 * 用户桌面路径
		 * @return
		 */
		public static function getDesktopPath():String {
			return File.desktopDirectory.nativePath;
		}
		
		/**
		 * 用户文档路径
		 * @return
		 */
		public static function getDocmentPath():String {
			return File.documentsDirectory.nativePath;
		}
		
		/**
		 * 应用程序的专用存储目录
		 * @return
		 */
		public static function getStoragePath():String {
			return File.applicationStorageDirectory.nativePath;
		}
		
		/**
		 * 系统类型:windows,mac,ios,linux,android
		 * @return
		 */
		public static function getSystemName():String {
			var str:String = Capabilities.os;
			if (str.indexOf("Windows") != -1) {
				return SystemName.WINDOWS;
			}
			if (str.indexOf("Mac") != -1) {
				return SystemName.MAC;
			}
			if (str.indexOf("iPhone") != -1) {
				return SystemName.IOS;
			}
			if (str.indexOf("iPad") != -1) {
				return SystemName.IOS;
			}
			if (str.indexOf("Linux") != -1) {
				return SystemName.LINUX;
			}
			return str;
		}
		
		/**
		 * 系统全称
		 * @return
		 */
		public static function getSystemAllName():String {
			return Capabilities.os;
		}
		
		/**
		 * 返回参数的上一级目录
		 * @param	url
		 * @return
		 */
		public static function getParentURL(url:String):String {
			var n:int = url.lastIndexOf("/");
			if (n == -1) return url;
			return url.substring(0, n);
		}
		
		
		//GPS
	}

}