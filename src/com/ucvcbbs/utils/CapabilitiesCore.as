package com.ucvcbbs.utils
{
	//import com.vsdevelop.air.filesystem.FileCore;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	
	//import com.vsdevelop.utils.StringCore;

	/**
	 * ...
	 * @author CameraGame
	 */
	public class CapabilitiesCore 
	{
		private static var IOSNAME:Array = ["iPhone", "iPad", "iPod"];
		public static var Library:String = "Library";
		public static var Documents:String = "Documents";
		
		
		/*public static function get APPDocuments():String
		{
			var APPURL:String = FileCore.getAppURL;
			//针对IOS特殊对待
			if (IOS(getOS))
			{
				APPURL = APPURL.substring(0, APPURL.lastIndexOf("/"))  +"/" +Documents;
			}
			
			return APPURL;
		}*/
		
		/*public static function get APPLibrary():String
		{
			var APPURL:String = FileCore.getAppURL;
			//针对IOS特殊对待
			if (IOS(getOS))
			{
				APPURL = APPURL.substring(0, APPURL.lastIndexOf("/"))  +"/" +Library;
			}			
			return APPURL;
		}
		
		public static function get APPDirectory():String
		{
			var APPURL:String = FileCore.getAppURL;
			return APPURL;
		}*/
		/*
		 * 获取系统名称
		 * Windows 7	"Windows 7"
			Windows Vista			"Windows Vista"
			Windows Server 2008 R2			"Windows Server 2008 R2"
			Windows Server 2008			"Windows Server 2008"
			Windows Home Server			"Windows Home Server"
			Windows Server 2003 R2			"Windows Server 2003 R2"
			Windows Server 2003			"Windows Server 2003"
			Windows XP 64			"Windows Server XP 64"
			Windows XP			"Windows XP"
			Windows 98			"Windows 98"
			Windows 95			"Windows 95"
			Windows NT			"Windows NT"
			Windows 2000			"Windows 2000"
			Windows ME			"Windows ME"
			Windows CE			"Windows CE"
			Windows SmartPhone			"Windows SmartPhone"
			Windows PocketPC			"Windows PocketPC"
			Windows CEPC			"Windows CEPC"
			Windows Mobile			"Windows Mobile"
			Mac OS			"Mac OS X.Y.Z"（其中 X.Y.Z 为版本号，例如 "Mac OS 10.5.2"）
			Linux			"Linux"（Flash Player 连接 Linux 版本，如 "Linux 2.6.15-1.2054_FC5smp"
			iPhone OS 4.1			"iPhone3,1"
		*/
		public static  function get isAIR():Boolean
		{
			try{
				//AIR版本
				var myClass:Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
				myClass = null;
				return true;
			}catch(e:Error){
				//浏览器版本
			}
			return false;
		}
		
		
		
		
		public static function get getOS():String
		{
			return Capabilities.os;
		}
		//获取设备的 分辨率
		public static function get DPI():int 
		{
			return Capabilities.screenDPI;
		}
		//对比是不是 IOS 平台
		public static function IOS(vole:String):Boolean
		{
			for each(var type:String in IOSNAME)
			{
				if (vole.indexOf(type) != -1) return true;
			}
			return false;
		}
		//获取播放平台以及播放器版本号
		public static function get version():String
		{
			return Capabilities.version;
		}
		//获取播放器版本号
		/*public static function get NumberVersion():int 
		{
			var numberString:String  = StringCore.SplitString(version, " ")[1];
			var vInt:int = StringCore.SplitString(numberString, ",")[0];
			return vInt;
		}*/
	}

}