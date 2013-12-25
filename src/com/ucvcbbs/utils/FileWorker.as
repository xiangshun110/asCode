package com.ucvcbbs.utils 
{
	import com.ucvcbbs.model.FileWorkerModel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	/**
	 * 用这个类的时候一定要把D:\truma\GitHub\FileWorker\bin\FileWorker.swf放入程序根目录
	 * @author xiangshun
	 * @time 2013/12/17 15:41:50
	 */
	public class FileWorker extends EventDispatcher
	{
		
		[Embed(source="FileWorker.swf", mimeType="application/octet-stream")]
        private static var BackgroundWorker_ByteClass:Class;
		
		private var bgWorker:Worker;
		
		private var commandChannel:MessageChannel;
		private var resultChannel:MessageChannel;
		
		private static var _instance:FileWorker;
		
		public function FileWorker(haha:Haha) 
		{
			init();
		}
		
		private function init():void {
			registerClassAlias("com.ucvcbbs.model.FileWorkerModel", FileWorkerModel);
			bgWorker = WorkerDomain.current.createWorker(BackgroundWorker, true);
			
			this.commandChannel = Worker.current.createMessageChannel(bgWorker);
			bgWorker.setSharedProperty("commandChannel", this.commandChannel);
			
			this.resultChannel = bgWorker.createMessageChannel(Worker.current);
			bgWorker.setSharedProperty("resultChannel", this.resultChannel);
			this.resultChannel.addEventListener(Event.CHANNEL_MESSAGE, resultChannelHandler);
			
			bgWorker.start();
		}
		
		private function resultChannelHandler(e:Event):void 
		{
			var obj:Object = this.resultChannel.receive();
			trace("resultChannel.receive():" + obj);
			if (obj == Event.COMPLETE) {
				//写入完成
				dispatchEvent(new Event(Event.COMPLETE));
				//bgWorker.terminate();
				trace("写入完成");
			}
		}
		
		public function write(tagerFile:String, content:ByteArray, position:Number = 0, model:String = "append"):void {
			//bgWorker.start();
			content.shareable = true;
			var fmodel:FileWorkerModel = new FileWorkerModel(tagerFile, content, position, model);
			this.commandChannel.send(fmodel);
			trace("开始写入");
		}
		
		public static function get BackgroundWorker():ByteArray
        {
            return new BackgroundWorker_ByteClass();
        }
		
		static public function get instance():FileWorker 
		{
			if (!_instance) {
				_instance = new FileWorker(new Haha());
			}
			return _instance;
		}
		
	}

}

class Haha{}