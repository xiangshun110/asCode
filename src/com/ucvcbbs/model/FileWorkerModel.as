package com.ucvcbbs.model 
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author xiangshun
	 * @time 2013/12/17 15:54:46
	 */
	public class FileWorkerModel 
	{
		
		public var targetFilePath:String;
		public var fileMode:String;
		public var position:Number;
		public var content:ByteArray;
		
		/**
		 * 
		 * @param	targetFile 要写入的文件
		 * @param	content 要写入的内容
		 * @param	position  写入位置
		 * @param	fileMode FileMode
		 */
		public function FileWorkerModel(targetFilePath:String="",content:ByteArray=null,position:Number=0,fileMode:String="append") 
		{
			this.targetFilePath = targetFilePath;
			this.fileMode = fileMode;
			this.position = position;
			this.content = content;
		}
		
	}

}