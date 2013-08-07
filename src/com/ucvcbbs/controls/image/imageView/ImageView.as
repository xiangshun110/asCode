package com.ucvcbbs.controls.image.imageView 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	/**
	 * 单张，全屏查看图片，可以缩放
	 * @author xiangshun
	 */
	public class ImageView 
	{
		
		private static var stage:Stage;
		private static var _scaleControl:MouseSmoothScaleControl = null;
		private static var closeBtn:CloseButton;
		private static var scaleControl:MouseSmoothScaleControl;
		
		public function ImageView() 
		{
			
		}
		
		public static function show(url:String,_stage:Stage):void {
			stage = _stage;
			var load:Loader = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, lodComplte);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			load.load(new URLRequest(url));
		}
		
		static private function loadError(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(Event.COMPLETE, lodComplte);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			trace("ImageView loadError");
		}
		
		static private function lodComplte(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, lodComplte);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			
			scaleControl = new MouseSmoothScaleControl();
			scaleControl.width = stage.stageWidth;
			scaleControl.height = stage.stageHeight;
			
			
			scaleControl.content =  (e.target as LoaderInfo).content;
			scaleControl.content.width = stage.stageWidth;
			scaleControl.content.height = stage.stageHeight;
			stage.addChild(scaleControl);
			
			
			scaleControl.contentBounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			// 指定最大的放大值
			//scaleControl.maxContentScale = 100;
			
			// 指定最小缩放
			scaleControl.minContentScale = 1/100;
			
			// 更改动画的长度。默认值为24。 
			//scaleControl.frameCount = 12;
			
			// 更改为放大倍率单击时。默认值为1.5。 
			// scaleControl.clickScale = 2;
			
			// 改变放大倍率时，鼠标滚轮旋转。默认值是1 / 16。
			// scaleControl.mouseWheelScale = 1/8;
			
			// 更改背景色。默认值为0xFFFFFF。 
			 scaleControl.backgroundColor = 0x000000;
			
			// 更改背景色的透明度。默认值为0。
			 scaleControl.backgroundAlpha = 0.2;
			 _scaleControl = scaleControl;
			 stage.addEventListener(Event.RESIZE, onStageResize);
			 
			if(!closeBtn){
				 closeBtn = new CloseButton();
				 closeBtn.x = stage.stageWidth - closeBtn.width - 10;
				 closeBtn.y = closeBtn.height / 2 + 10;
				 closeBtn.addEventListener(MouseEvent.CLICK, clsoeHandler);
				 stage.addChild(closeBtn);
			}else {
				stage.addChild(closeBtn);
				
			}
		}
		
		static private function clsoeHandler(e:MouseEvent):void 
		{
			
			if (stage.contains(scaleControl)) {
				stage.removeChild(scaleControl);
				scaleControl.content = null;
				scaleControl.contentBounds = null;
				scaleControl = null;
				stage.removeEventListener(Event.RESIZE, onStageResize);
				stage.removeChild(closeBtn);
			}
		}
		
		static private function onStageResize(e:Event):void 
		{
			_scaleControl.width = stage.stageWidth;
			_scaleControl.height = stage.stageHeight;
		}
		
	}

}