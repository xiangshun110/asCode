package com.ucvcbbs.downLoad 
{
	import com.ucvcbbs.data.SQLLite;
	import com.ucvcbbs.events.BreakPointDownLoadEvent;
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
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class BreakPointDownMulti extends EventDispatcher
	{
		
		private var db:SQLLite;
		private const TB_UNFINISH:String = "tb_unfinish";
		private var _maxCount:int;//最大下载数
		private var curCount:int=0;//当前下载数
		private var urlDict:Dictionary;
		private var loadDict:Dictionary;
		
		public function BreakPointDownMulti(countMax:int=3) 
		{
			_maxCount = countMax;
			init();
		}
		
		private function init():void {
			db = new SQLLite("database/download.db");
			var obj:Object = new Object();
			obj.url = "TEXT";
			obj.autoLoad = "TEXT";//false:不自动下载，true:进入下载队列
			obj.isLoading = "TEXT";//是否下载中,false:没有  true:在
			db.creatTable(TB_UNFINISH, obj);
			
			urlDict = new Dictionary();//key是URL，value是loadModel
			loadDict = new Dictionary();//key是load，value是load的url
			
			//检查没下载完的
			var ary:Array = db.selectData(TB_UNFINISH, null, { autoLoad:"true",isLoading:"true" },"AND" );
			if (ary && ary.length) {
				for (var i:int = 0; i < ary.length; i++ ) {
					addDownload(ary[i].url, true);
				}
			}
		}
		
		private function lodError(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, lodError);
			e.target.removeEventListener(ProgressEvent.PROGRESS, getTotalByte);
		}
		
		/**
		 * 文件的总大小
		 * @param	e
		 */
		private function getTotalByte(e:ProgressEvent):void 
		{
			e.target.removeEventListener(ProgressEvent.PROGRESS, getTotalByte);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, lodError);
			var m:LoadModel = urlDict[loadDict[e.target]] as LoadModel;
			m.total = e.bytesTotal;
			e.target.close();
			//trace(m.request.url+" , totalPoint:" + m.total);
			startDownLoad(m);
		}
		
		/**
		 * 下载前的准备活动
		 */
		private function startDownLoad(loadmodel:LoadModel):void {
			//先看本地有没有这个文件
			var tempurl:String = loadmodel.request.url;
			var num:int = tempurl.lastIndexOf("/");
			if (num != -1) {
				loadmodel.fileName=tempurl.substring(num + 1);
			}
			
			loadmodel.curFile = FileTools.getFileFromPath(FileTools.getPathFromURL(tempurl));
			loadmodel.tempFile = FileTools.getFileFromPath(FileTools.getPathFromURL(tempurl) + ".ucvcbbs");
			
			//trace("-------------:" + FileTools.getPathFromURL(tempurl));
			//trace(loadmodel.url,loadmodel.tempFile,loadmodel.tempFile.exists)
			
			if (loadmodel.curFile.exists) {
				trace("文件已经有了。。");
				//删除记录
				db.deleteData(TB_UNFINISH, { url:tempurl } );
				//删掉urlDic,loadDict对应的key
				deleteLoadModel(loadmodel);
				
				continueDown();//下一个
				return;
			}
			var fStream:FileStream = new FileStream();;
			if (loadmodel.tempFile.exists) {//临时文件存在,还没下完
				fStream.open(loadmodel.tempFile, FileMode.READ);
				loadmodel.startPoint = fStream.bytesAvailable;
				fStream.close();
				fStream = null;
			}else {
				loadmodel.startPoint = 0;
			}
			loadmodel.endPoint = loadmodel.startPoint;
			//trace("开始啦,"+tempurl+"从 "+loadmodel.startPoint+" 开始");
			breakDownLoad(loadmodel);
		}
		
		/**
		 * 下一个
		 */
		private function continueDown():void {
			var ary:Array = db.selectData(TB_UNFINISH,null,{autoLoad:"true",isLoading:"false"},"AND");
			if (ary && ary.length > 0) {
				addDownload(ary[0].url, true);
			}else {
				//已经没有了
				//trace("已经没有是下载状态的了");
				//dispatchEvent(new BreakPointDownLoadEvent(BreakPointDownLoadEvent.ALLCOMPLETE));//allFileLoadComplete
			}
		}
		
		/**
		 * 开始进行一个区间的内容下载
		 */
		private function breakDownLoad(loadmodel:LoadModel):void {
			if (loadmodel.startPoint >= loadmodel.total) {
				trace(loadmodel.request.url + "下载完成");
				//删掉urlDic,loadDict对应的key
				deleteLoadModel(loadmodel);
				
				
				continueDown();//下一个
				return;
			}
			loadmodel.endPoint += 10000;
			if (loadmodel.endPoint >= loadmodel.total) {
				loadmodel.endPoint = loadmodel.total;
			}
			loadmodel.load.dataFormat = URLLoaderDataFormat.BINARY;
			loadmodel.request = new URLRequest();
			loadmodel.request.url = loadmodel.url;
			var h:URLRequestHeader = new URLRequestHeader("Range", "bytes=" + loadmodel.startPoint + "-" + loadmodel.endPoint);
			loadmodel.request.requestHeaders.push(h);
			//loadmodel.load.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loadmodel.load.addEventListener(Event.COMPLETE, breakLoadComplete);
			loadmodel.load.load(loadmodel.request);
		}
		
		/**
		 * 一个区间下载完成
		 * @param	e
		 */
		private function breakLoadComplete(e:Event):void 
		{
			var loadmodel:LoadModel = urlDict[loadDict[e.target]] as LoadModel;
			if (!loadmodel||!loadmodel.load||!loadmodel.tempFile) return;
			var bytes:ByteArray = e.target.data as ByteArray;
			var fStream:FileStream = new FileStream();
			//trace("loadmodel:" + loadmodel.url);
			fStream.open(loadmodel.tempFile, FileMode.UPDATE);
			fStream.position = loadmodel.startPoint;
			fStream.writeBytes(bytes, 0, bytes.length);
			fStream.close();
			//loadmodel.load.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loadmodel.load.removeEventListener(Event.COMPLETE, breakLoadComplete);
			
			urlDict[loadDict[e.target]].progress = loadmodel.endPoint / loadmodel.total;
			
			//一个文件下载完成
			if (loadmodel.endPoint >= loadmodel.total) {
				loadmodel.endPoint = 0;
				trace(loadmodel.url + " 下载完成");
				loadmodel.tempFile.moveTo(loadmodel.curFile, true);
				//删除数据库中这条记录
				db.deleteData(TB_UNFINISH, { url:loadmodel.url } );
				dispatchEvent(new BreakPointDownLoadEvent(BreakPointDownLoadEvent.ONEITEMCOMPLETE,false,false,loadmodel.url,loadmodel.curFile.url));
				//删掉urlDic,loadDict对应的key
				deleteLoadModel(loadmodel);
				
				continueDown();//下一个
				return;
			}
			loadmodel.startPoint += bytes.length;
			breakDownLoad(loadmodel);//继续下载
		}
		
		/**
		 * 区间进度
		 * @param	e
		 */
		/*private function progressHandler(e:ProgressEvent):void 
		{
			urlDict[loadDict[e.target]].progress = e.bytesLoaded / e.bytesTotal;
		}*/
		
		private function deleteLoadModel(loadmodel:LoadModel):void {
			delete urlDict[loadmodel.url];
			delete loadDict[loadmodel.load];
			loadmodel.load = null;
			loadmodel.request = null;
			loadmodel.tempFile = null;
			loadmodel.curFile = null;
			loadmodel = null;
			curCount--;
		}
		
		/**
		 * 加入下载队列
		 * @param	url 文件URL
		 * @param	autoDownLoad 是否自动下载(加入下载队列)
		 */
		public function addDownload(url:String, autoDownLoad:Boolean = false):void {
			if (!url) {
				trace(url, "url没有值");
				return;
			}
			var ary:Array=db.selectData(TB_UNFINISH, null, { url:url } );
			if (ary && ary.length) {
				db.update(TB_UNFINISH, { autoLoad:String(autoDownLoad) }, { url:url } );
			}else{
				db.insert(TB_UNFINISH, { url:url, autoLoad:String(autoDownLoad),isLoading:"false" } );
			}
			//trace("curCount:" + curCount);
			if (autoDownLoad && (curCount < this._maxCount)) {
				
				/*if (ary && ary.length && autoDownLoad) {
					trace("继续:" + url);
				}*/
				
				db.update(TB_UNFINISH, { isLoading:"true" }, { url:url } );
				
				
				var load:URLLoader = new URLLoader();
				var re:URLRequest = new URLRequest();
				re.url = url;
				var loadmodel:LoadModel = new LoadModel();
				loadmodel.load = load;
				loadmodel.request = re;
				loadmodel.url = url;
				urlDict[url] = loadmodel;
				loadDict[load] = url;
				curCount++;
				load.addEventListener(IOErrorEvent.IO_ERROR, lodError);
				load.addEventListener(ProgressEvent.PROGRESS, getTotalByte);
				load.load(re);
			}
		}
		
		/**
		 * 暂停这个url的下载
		 * @param	url
		 */
		public function pauseToURL(url:String):void {
			var loadmodel:LoadModel = urlDict[url] as LoadModel;
			if (!loadmodel) {
				trace("它没有在下载中");
				return;
			} 
			
			//loadmodel.load.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loadmodel.load.removeEventListener(Event.COMPLETE, breakLoadComplete);
			loadmodel.load.removeEventListener(ProgressEvent.PROGRESS, getTotalByte);
			loadmodel.load.removeEventListener(IOErrorEvent.IO_ERROR, lodError);
			loadmodel.load.close();
			
			db.update(TB_UNFINISH, { autoLoad:"false",isLoading:"false"}, { url:loadmodel.url } );
			
			deleteLoadModel(loadmodel);
			
			continueDown();//下一个
		}
		
		/**
		 * 继续这个URL的下载
		 * @param	url
		 */
		public function continueToURL(url:String):void {
			addDownload(url, true);
		}
		
		/**
		 * 获取这个URL的进度
		 * @param	url
		 * @return  -1表示没有开始下载
		 */
		public function getProgress(url:String):Number {
			if(urlDict[url]){
				return urlDict[url].progress;
			}else {
				return -1;
			}
		}
		
		/**
		 * 根据URL得到它的Loadmodel
		 * @param	url
		 */
		public function getLoadmodelFormURL(url:String):LoadModel{
			return urlDict[url];
		}
		
		/**
		 * 最大下载数
		 */
		public function get maxCount():int 
		{
			return _maxCount;
		}
		/**
		 * 最大下载数
		 */
		public function set maxCount(value:int):void 
		{
			_maxCount = value;
		}
		
	}

}