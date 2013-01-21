package com.ucvcbbs.utils 
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
			f.deleteFile();
		}
		
		/**
		 * 根据URL获取文件的路径(包括文件名),比如
		 * @param	url
		 * @return
		 */
		public static function getPathFromURL(url:String):String {
			var num:int = url.indexOf("http://");
			var str:String;
			if (num != -1) {
				str = AppTools.getAppPath() + "/downLoad/" + url.substring(7);
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
		
	}

}