package com.ucvcbbs.utils 
{
	import com.ucvcbbs.events.NetworkEvent;
	import com.ucvcbbs.model.XSNetworkModel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class XSNetWork extends EventDispatcher
	{
		private static var instance:XSNetWork;
		private var loaderDic:Dictionary;
		private var loaderStatusDic:Dictionary;
		public function XSNetWork(pv:Pvclass) 
		{
			loaderDic = new Dictionary();
			loaderStatusDic = new Dictionary();
		}
		public static function getInstance():XSNetWork {
			if (!instance) {
				instance = new XSNetWork(new Pvclass());
			}
			return instance;
		}
		
		/**
		 * callBackFun必须要一个参数,参数类型是XSNetworkModel
		 * @param	urlRequest 
		 * @param	callBackFun 回调函数
		 */
		public function startByRequest(urlRequest:URLRequest, callBackFun:Function):void {
			
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderComplete);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, dataLoaderError);
			dataLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dataLoaderStatus);
			urlRequest.useCache = false;
			urlRequest.cacheResponse = false;
			trace("当前URL：" + urlRequest.url);
			loaderDic[dataLoader] = callBackFun;
			dataLoader.load(urlRequest);
		}
		
		private function dataLoaderStatus(e:HTTPStatusEvent):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			
			//loader.removeEventListener(Event.COMPLETE, dataLoaderComplete);
			//loader.removeEventListener(IOErrorEvent.IO_ERROR, dataLoaderError);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dataLoaderStatus);
			loaderStatusDic[loader] = e.status;
			
		}
		
		private function dataLoaderError(e:IOErrorEvent):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			
			loader.removeEventListener(Event.COMPLETE, dataLoaderComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, dataLoaderError);
			//loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dataLoaderStatus);
			var mode:XSNetworkModel = new XSNetworkModel();
			mode.type = NetworkEvent.ERROR
			mode.error_msg = e.text;
			mode.httpCode = loaderStatusDic[loader];
			
			var fun:Function = loaderDic[loader];
			fun(mode);
			delete loaderDic[loader];
			delete loaderStatusDic[loader];
			
			//this.dispatchEventWith(AppEvent.COMPLETE, false, mode);
		}
		
		private function dataLoaderComplete(e:Event):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			var fun:Function = loaderDic[loader];
			loader.removeEventListener(Event.COMPLETE, dataLoaderComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, dataLoaderError);
			//loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dataLoaderStatus);
			var mode:XSNetworkModel = new XSNetworkModel();
			var obj:Object;
			try{
				obj = JSON.parse(e.target.data);
			}catch (e:Error) {
				mode.type = NetworkEvent.ERROR;
				mode.error_msg = "解析数据出错";
				mode.httpCode = loaderStatusDic[loader];
				fun(mode);
				delete loaderDic[loader];
				return;
			}
			//obj.eee = dataLoader;
			mode.type = NetworkEvent.COMPLETE;
			mode.data = obj;
			mode.httpCode = loaderStatusDic[loader];
			fun(mode);
			delete loaderDic[loader];
			delete loaderStatusDic[loader];
		}
		
	}

}


class Pvclass{}