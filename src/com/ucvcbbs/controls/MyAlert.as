package com.ucvcbbs.controls 
{
	import com.ucvcbbs.events.MyAlertEvent;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * AIR版
	 * ...
	 * @author xiangshun
	 */
	public class MyAlert 
	{
		private static var container:Sprite;
		private static var bg:Sprite;
		private static var centerBg:Sprite;
		private static var titleTf:TextField;
		private static var contentTf:TextField;
		private static var titleFormat:TextFormat;
		private static var contentFormat:TextFormat;
		
		private static const TITLE:String = "title";
		private static const CONTENT:String = "content";
		
		private static var stage:Stage;
		
		private static var btn1:MyAlertButton;
		private static var btn2:MyAlertButton;
		
		private static var _eventObject:EventDispatcher
		
		public function MyAlert() 
		{
			
		}
		
		private static function creatFormat(style:String):TextFormat {
			var format:TextFormat = new TextFormat("Arial");
			format.color = 0xFFFFFF;
			switch(style) {
				case TITLE:
					format.align = TextFormatAlign.LEFT;
					format.size = 20;
					format.bold = true;
					break;
				case CONTENT:
					format.align = TextFormatAlign.CENTER;
					format.size = 14;
					break;
			}
			return format;
		}
		
		private static function creatBg():Sprite {
			var sp:Sprite = new Sprite();
			var mat:Matrix = new Matrix();
			mat.tx = 10;
			mat.ty = 10;
			sp.graphics.clear();
			sp.graphics.beginGradientFill(GradientType.RADIAL, [0xECF0F3, 0x647A8A], [.6, .8], [0, 255],mat);
			//trace(stage.stageWidth, stage.stageHeight, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			sp.graphics.drawRect(-stage.stageWidth/2, -stage.stageHeight/2,stage.stageWidth, stage.stageHeight);
			sp.graphics.endFill();
			
			sp.x = stage.stageWidth / 2;
			sp.y = stage.stageHeight / 2;
			return sp;
		}
		
		private static function updateCenterBg():void {
			centerBg.graphics.clear();
			centerBg.graphics.lineStyle(3, 0xF8FCFB);
			centerBg.graphics.beginFill(0x2E3D66,.8);
			centerBg.graphics.drawRoundRect(0, 0, contentTf.width + 100, contentTf.height + 100, 10, 10);
			centerBg.graphics.endFill();
			
			centerBg.graphics.lineStyle();
			centerBg.graphics.beginFill(0xA4B3D4, .5);
			centerBg.graphics.moveTo(2, 2);
			centerBg.graphics.lineTo(2, 20);
			centerBg.graphics.curveTo(centerBg.width / 2-2, 45, centerBg.width-4, 20);
			centerBg.graphics.lineTo(centerBg.width-4, 2);
			centerBg.graphics.endFill();
			
			contentTf.x = (centerBg.width - contentTf.width) / 2;
			contentTf.y = (centerBg.height - contentTf.height) / 2-8;
			
			centerBg.x = (container.width - centerBg.width) / 2;
			centerBg.y = (container.height - centerBg.height) / 2;
			
			titleTf.x = (centerBg.width - titleTf.width) / 2;
			titleTf.y = 13;
		}
		
		
		static private function orientationHandler(e:StageOrientationEvent):void 
		{
			if (bg) {
				var mat:Matrix = new Matrix();
				mat.tx = 10;
				mat.ty = 10;
				bg.graphics.clear();
				bg.graphics.beginGradientFill(GradientType.RADIAL, [0xECF0F3, 0x647A8A], [.6, .8], [0, 255],mat);
				bg.graphics.drawRect(-stage.stageWidth/2, -stage.stageHeight/2,stage.stageWidth, stage.stageHeight);
				bg.graphics.endFill();
				bg.x = stage.stageWidth / 2;
				bg.y = stage.stageHeight / 2;
				
				centerBg.x = (container.width - centerBg.width) / 2;
				centerBg.y = (container.height - centerBg.height) / 2;
			}
		}
		
		private static function btnClikHandler(evt:MouseEvent):void {
			stage.removeChild(container);
			stage = null;
			//trace(evt.target.name);
			//trace(evt.currentTarget.name)
			switch(evt.currentTarget.name) {
				case "btn1":
					eventObject.dispatchEvent(new MyAlertEvent(MyAlertEvent.YES));
					break;
				case "btn2":
					eventObject.dispatchEvent(new MyAlertEvent(MyAlertEvent.NO));
					break;
			}
		}
		
		public static function show(stage1:Stage,title:String, content:String, btnName1:String="确定", btnName2:String = ""):void {
			stage = stage1;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationHandler);
			if (!container) {
				container = new Sprite();
			}
			if (!bg) {
				bg = creatBg();
				container.addChild(bg);
			}
			if (!titleTf) {
				titleTf = new TextField();
				titleTf.mouseEnabled = false;
				titleTf.selectable = false;
				titleTf.autoSize = TextFieldAutoSize.LEFT;
				titleTf.embedFonts = false;
				titleFormat = creatFormat(TITLE);
			}
			titleTf.text = title;
			titleTf.setTextFormat(titleFormat);
			
			if (!contentTf) {
				contentTf = new TextField();
				contentTf.mouseEnabled = false;
				contentTf.width = 220;
				//contentTf.selectable = false;
				contentTf.autoSize = TextFieldAutoSize.LEFT;
				contentTf.multiline = true;
				contentTf.wordWrap = true;
				contentTf.embedFonts = false;
				contentFormat = creatFormat(CONTENT);
			}
			contentTf.text = content;
			contentTf.setTextFormat(contentFormat);
			
			if (contentTf.width < 100) {
				contentTf.width = 100;
			}
			
			if (contentTf.width > 250) {
				contentTf.width = 250;
			}
			//trace(contentTf.width);
			if (!centerBg) {
				centerBg = new Sprite();
				
				centerBg.addChild(titleTf);
				centerBg.addChild(contentTf);
				
				var dsFilter:DropShadowFilter = new DropShadowFilter();
				dsFilter.alpha = .4;
				dsFilter.angle = 90;
				//dsFilter.blurY = 6;
				//dsFilter.distance = 6;
				
				centerBg.filters = [dsFilter];
				container.addChild(centerBg);
			}
			updateCenterBg();
			
			if (btnName1 == "") {
				btnName1 = "确定";
			}
			if (!btn1) {
				btn1 = new MyAlertButton();
				btn1.name = "btn1";
				btn1.addEventListener(MouseEvent.CLICK, btnClikHandler);
				centerBg.addChild(btn1);
			}
			btn1.setTxt(btnName1);
			btn1.setBgWidth(centerBg.width - 20);
			btn1.x = (centerBg.width - btn1.width) / 2-1.5;
			btn1.y = centerBg.height - btn1.height - 10;
			
			if (!btn2) {
				btn2 = new MyAlertButton();
				btn2.name = "btn2";
				btn2.addEventListener(MouseEvent.CLICK, btnClikHandler);
				centerBg.addChild(btn2);
			}
			btn2.visible = false;
			
			if (btnName2 != "") {
				btn2.visible = true;
				btn2.setTxt(btnName2);
				btn2.setBgWidth((centerBg.width - 20) / 2);
				btn2.y = centerBg.height - btn2.height - 10;
				btn1.setBgWidth((centerBg.width - 20) / 2);
				
				btn1.x = (centerBg.width - btn1.width * 2 - 4) / 2-1.5;
				btn2.x = btn1.x + btn1.width + 4;
			}
			
			stage.addChild(container);
			stage.setChildIndex(container,stage.numChildren - 1);
		}
		
		static public function get eventObject():EventDispatcher 
		{
			if (!_eventObject) {
				_eventObject = new EventDispatcher();
			}
			return _eventObject;
		}
	}

}