﻿package com.ucvcbbs.downLoad 
{
	//import cn.eDoctor.Baraclude.events.AppEvent;
	//import com.ucvcbbs.controls.MyAlert;
	import com.ucvcbbs.data.SQLLite;
	import com.ucvcbbs.events.BreakPointDownLoadEvent;
	import com.ucvcbbs.utils.AppTools;
	import com.ucvcbbs.utils.FileTools;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	/**
	 * 只适用于air版，一次只能下载一个
	 * @author xiangshun
	 */
	public class BreakPointDownLoad extends EventDispatcher
	{
		private var laoddb:SQLLite;
		
		private var lod:URLLoader;
		private var re:URLRequest;
		private var fStream:FileStream;
		private var totalPoint:Number;
		private var curURL:String;
		
		private var curfile:File;
		private var tempfile:File;
		
		private var startPoint:Number;
		private var endPoint:Number;
		private var isStart:Boolean = false;//是否已开始下载
		
		private var _curProgress:Number;
		private var _curFileName:String;
		
		private var _totalCount:int=0;
		private var _curCount:int = 0;
		
		public function BreakPointDownLoad() 
		{
			init();
		}
		
		private function init():void {
			laoddb = new SQLLite("sqlLite/downLoad.db");
			var obj:Object = new Object();
			obj.url = "TEXT";
			laoddb.creatTable("unfinished", obj);
			
			//先检查本地数据库中有没有没下载完成的
			var ary:Array = laoddb.selectData("unfinished");
			if (ary && ary.length > 0) {
				_totalCount = ary.length;
				curURL = ary[0].url;
				loadURLTobreakPoint(curURL);
				isStart = true;
			}
		}
		
		private function loadURLTobreakPoint(url:String):void {
			if (!url) {
				//删除这一个
				laoddb.deleteData("unfinished", { url:url } );
				//下一个;
				continueDown();
				return;
			}
			
			//只下载图片,微博在用
			/*var tempstr:String = curURL.toLocaleLowerCase();
			tempstr = tempstr.substr(tempstr.length - 4);
			if (tempstr != ".jpg" && tempstr != ".png" && tempstr != ".gif") {
				//删除这一个
				laoddb.deleteData("unfinished", { url:curURL } );
				//下一个;
				continueDown();
				return;
			}*/
			
			_curCount++;
			trace("开始下载:" + curURL);
			curURL = url;
			lod = new URLLoader();
			lod.addEventListener(IOErrorEvent.IO_ERROR, lodError);
			lod.addEventListener(ProgressEvent.PROGRESS, getTotalByte);
			re = new URLRequest();
			re.url = url;
			fStream = new FileStream();
			lod.load(re);
		}
		
		
		private function lodError(e:IOErrorEvent):void 
		{
			//MyAlert
			//如果下载出错,不能删
			//Singleton.showAlert(curURL + "下载出错");
			
			lod.removeEventListener(IOErrorEvent.IO_ERROR, lodError);
			lod.removeEventListener(ProgressEvent.PROGRESS, getTotalByte);
			lod.removeEventListener(Event.COMPLETE, breakLoadComplete);
			lod = null;
			re = null;
			//删除这一个
			//laoddb.deleteData("unfinished", { url:curURL } );
			//下一个;
			continueDown();
		}
		
		/**
		 * 当前文件的总大小
		 * @param	e
		 */
		private function getTotalByte(e:ProgressEvent):void 
		{
			lod.removeEventListener(ProgressEvent.PROGRESS, getTotalByte);
			lod.removeEventListener(IOErrorEvent.IO_ERROR, lodError);
			lod.removeEventListener(Event.COMPLETE, breakLoadComplete);
			totalPoint = e.bytesTotal;
			lod.close();
			lod = null;
			re = null;
			trace(curURL+" , totalPoint:" + totalPoint);
			startDownLoad();
		}
		
		/**
		 * 下载前的准备活动
		 */
		private function startDownLoad():void {
			if (curURL == "") {
				//删除这一个
				laoddb.deleteData("unfinished", { url:curURL } );
				//下一个;
				continueDown();
				return;
			} 
			//先看本地有没有这个文件
			
			var num:int = curURL.lastIndexOf("/");
			if (num != -1) {
				_curFileName=curURL.substring(num + 1);
			}
			
			curfile = FileTools.getFileFromPath(FileTools.getPathFromURL(curURL));
			tempfile = FileTools.getFileFromPath(FileTools.getPathFromURL(curURL) + ".ucvcbbs");
			
			//trace("-------------:" + FileTools.getPathFromURL(curURL));
			//trace(tempfile,tempfile.exists)
			
			if (curfile.exists) {
				trace("文件已经有了,继续下一个.");
				//删除记录
				laoddb.deleteData("unfinished", { url:curURL } );
				continueDown();
				return;
			}
			if (tempfile.exists) {//临时文件存在,还没下完
				fStream.open(tempfile, FileMode.READ);
				startPoint = fStream.bytesAvailable;
				fStream.close();
			}else {
				startPoint = 0;
			}
			endPoint = startPoint;
			trace("开始啦,从 "+startPoint+" 开始");
			breakDownLoad();
		}
		
		/**
		 * 开始进行一个区间的内容下载
		 */
		private function breakDownLoad():void {
			if (startPoint >= totalPoint) {
				trace(curfile.url + "下载完成");
				continueDown();
				return;
			}
			endPoint += 100000;
			if (endPoint >= totalPoint) {
				endPoint = totalPoint;
			}
			lod = new URLLoader();
			lod.dataFormat = URLLoaderDataFormat.BINARY;
			re = new URLRequest();
			re.url = curURL;
			var h:URLRequestHeader = new URLRequestHeader("Range", "bytes=" + startPoint + "-" + endPoint);
			re.requestHeaders.push(h);
			lod.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			lod.addEventListener(Event.COMPLETE, breakLoadComplete);
			lod.addEventListener(IOErrorEvent.IO_ERROR,lodError);
			lod.load(re);
		}
		
		/**
		 * 一个区间的内容下载完成
		 * @param	evt
		 */
		private function breakLoadComplete(evt:Event):void {
			var bytes:ByteArray = lod.data as ByteArray;
			fStream.open(tempfile, FileMode.UPDATE);
			fStream.position = startPoint;
			fStream.writeBytes(bytes, 0, bytes.length);
			fStream.close();
			lod.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			lod.removeEventListener(Event.COMPLETE, breakLoadComplete);
			lod.removeEventListener(IOErrorEvent.IO_ERROR,lodError);
			lod = null;
			re = null;
			if (endPoint >= totalPoint) {
				endPoint = 0;
				trace(curfile.url + " 下载完成");
				dispatchEvent(new BreakPointDownLoadEvent(BreakPointDownLoadEvent.ONEITEMCOMPLETE,false,false,curURL,curfile.url));
				tempfile.moveTo(curfile, true);
				//删除数据库中这条记录
				laoddb.deleteData("unfinished", { url:curURL } );
				continueDown();//继续下载
				return;
			}
			
			startPoint += bytes.length;
			breakDownLoad();
		}
		
		/**
		 * 这是一个区间的下载进度
		 * @param	evt
		 */
		private function progressHandler(evt:ProgressEvent):void {
			//trace(evt.bytesLoaded, evt.bytesTotal);
			_curProgress = evt.bytesLoaded / evt.bytesTotal;
		}
		
		
		/**
		 * 继续下载
		 */
		private function continueDown():void {
			var ary:Array = laoddb.selectData("unfinished");
			if (ary && ary.length > 0) {
				curURL = ary[0].url;
				//继续开始下载
				loadURLTobreakPoint(curURL);
			}else {
				//已经没有了,所以文件都已经完成
				trace("所有文件下载完毕");
				isStart = false;
				dispatchEvent(new BreakPointDownLoadEvent(BreakPointDownLoadEvent.ALLCOMPLETE));//allFileLoadComplete
			}
		}
		
		//==================public==================================
		
		/**
		 * 添加一个URL加入下载队列
		 * @param	url
		 */
		public function addURLDownLoad(fileURL:String):void {
			laoddb.insert("unfinished", { url:fileURL } );
			_totalCount++;
			//trace("加入一个,", isStart);
			if (!isStart) {
				curURL = fileURL;
				loadURLTobreakPoint(curURL);
				isStart = true;
			}
			
		}
		
		/**
		 * 当前这个文件的URL
		 */
		public function  get curLoadURL():String {
			return curURL;
		}
		
		/**
		 * 当前这个文件的下载进度
		 */
		public function get curProgress():Number {
			//trace("endPoint:" + endPoint, totalPoint);
			return endPoint/totalPoint;
		}
		
		/**
		 * 当前文件的名称
		 */
		public function get curFileName():String {
			return _curFileName;
		}
		
		/**
		 * 需要下载的总个数
		 */
		public function get totalCount():int {
			return _totalCount;
		}
		
		/**
		 * 已经下载的个数
		 */
		public function get curCount():int {
			return _curCount;
		}
		
		/**
		 * 根据URL删除这条记录
		 * @param	url
		 */
		public function deleteItem(url:String):void {
			laoddb.deleteData("unfinished", { url:url } );
		}
		
		
	}

}