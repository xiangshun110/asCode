﻿package com.ucvcbbs.utils 
{
	import flash.filesystem.File;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class FileTools 
	{
		
		public function FileTools() 
		{
			
		}
		
		/**
		 * 根据路径获取一个文件，或者新建一个文件
		 * @param	path
		 * @return
		 */
		public static function getFileFromPath(path:String):File {
			var f:File = new File();
			return f.resolvePath(path);
		}
		
		/**
		 * 根据路径删除这个文件(同步)
		 * @param	path
		 */
		public static function deleteFromPath(path:String):void {
			var f:File = getFileFromPath(path);
			if(f.exists){
				f.deleteFile();
			}
		}
		
		/**
		 * 根据URL获取文件的路径(包括文件名),(downLoad专用)
		 * @param	url
		 * @return
		 */
		public static function getPathFromURL(url:String):String {
			var num:int = url.indexOf("http://");
			var str:String;
			if (num != -1) {
				str =  url.substring(7);
			}else {
				return "";
			}
			
			num = str.indexOf("/");
			if (num != -1) {
				var pstr:String="";
				switch(AppTools.getSystemName()) {
					case SystemName.WINDOWS:
						pstr = AppTools.getAppPath();
						break;
					case SystemName.IOS:
						pstr = AppTools.getAppPath();
						pstr = AppTools.getParentURL(pstr);
						pstr += "/Library";
						break;
					case SystemName.LINUX:
						pstr = AppTools.getStoragePath();
						break;
				}
				return pstr + "/downLoad/" + str.substring(num + 1);
			}else {
				return "";
			}
		}
		
		/**
		 * 获取http://后第一个斜杠后的内容
		 * @param	url
		 * @return
		 */
		public static function getPathFormURL2(url:String):String {
			var num:int = url.indexOf("http://");
			var str:String;
			if (num != -1) {
				str =  url.substring(7);
			}else {
				return "";
			}
			
			num = str.indexOf("/");
			if (num != -1) {
				return str.substring(num + 1);
			}else {
				return "";
			}
		}
		
		/**
		 * 同步删除文件夹
		 * @param	path
		 */
		public static function deleteDirctoryFromPath(path:String):void {
			var f:File = FileTools.getFileFromPath(path);
			if(f.exists){
				f.deleteDirectory(true);
			}else {
				trace("删除文件夹失败: " + path);
			}
		}
		
	}

}