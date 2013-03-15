package com.ucvcbbs.utils 
{
	//import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
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
			var FileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
			return FileClass.applicationDirectory.nativePath;	
		}
		
		/**
		 * 应用程序所在的目录URL
		 * @return
		 */
		public static function getAppURL():String {
			var FileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
			return FileClass.applicationDirectory.url;
		}
		
		/**
		 * 用户桌面路径
		 * @return
		 */
		public static function getDesktopPath():String {
			var FileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
			return FileClass.desktopDirectory.nativePath;
		}
		
		/**
		 * 用户文档路径
		 * @return
		 */
		public static function getDocmentPath():String {
			var FileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
			return FileClass.documentsDirectory.nativePath;
		}
		
		/**
		 * 应用程序的专用存储目录
		 * @return
		 */
		public static function getStoragePath():String {
			var FileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
			return FileClass.applicationStorageDirectory.nativePath;
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
		
		/**
		 * 获取IOS上的library路径
		 * @return
		 */
		public static function getIOSLibraryPath():String {
			var pstr:String;
			switch(AppTools.getSystemName()) {
				case SystemName.WINDOWS:
					pstr = AppTools.getAppPath();
					break;
				case SystemName.IOS:
					pstr = AppTools.getAppPath();
					pstr = AppTools.getParentURL(pstr);
					pstr += "/Library";
					break;
			}
			return pstr;
		}
		
		/**
		 * 获取IOS上的Documents路径
		 * @return
		 */
		public static function getIOSDocumentsPath():String {
			var pstr:String;
			switch(AppTools.getSystemName()) {
				case SystemName.WINDOWS:
					pstr = AppTools.getAppPath();
					break;
				case SystemName.IOS:
					pstr = AppTools.getAppPath();
					pstr = AppTools.getParentURL(pstr);
					pstr += "/Documents";
					break;
			}
			return pstr;
		}
		
		
		//GPS
	}

}