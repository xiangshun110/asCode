package com.ucvcbbs.utils
{
	import com.vsdevelop.events.Events;
	import com.vsdevelop.ios.IOSFrameWork;
	import com.vsdevelop.ios.IOSFWEvents;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ...
	 */
	public class ManageExtension extends EventDispatcher
	{
		//单列
		private static var _instance:ManageExtension;
		
		public var ExtensionFrameWork:IOSFrameWork = null;
		
		public function ManageExtension(cl:inert)
		{
			if (!cl) throw Error("无法初始化" + this);
			
			try{
				//AIR版本
				var StatusEvent:Class = getDefinitionByName("flash.events.StatusEvent") as Class;
				ExtensionFrameWork = new IOSFrameWork();
				ExtensionFrameWork.addEventListener(StatusEvent.STATUS, StatusEventComplete);
			}catch(e:Error){
				//浏览器版本
				trace(e);
			}
		}
		
		private function StatusEventComplete(evt:*):void 
		{
			this.dispatchEvent(new IOSFWEvents(evt.code, evt.level));
		}
		
		
		//单列初始化
		public static function getInstance():ManageExtension
		{
            if (_instance == null)
			{
				_instance= new ManageExtension(new inert());
			}
            return _instance;
        }
		
	}

}
class inert{}