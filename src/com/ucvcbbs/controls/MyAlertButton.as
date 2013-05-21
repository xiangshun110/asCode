package com.ucvcbbs.controls   
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class MyAlertButton extends Sprite
	{
		private var bg:Sprite;
		private var txt:TextField;
		private var format:TextFormat;
		public function MyAlertButton() 
		{
			init();
		}
		
		private function init():void {
			bg = new Sprite();
			txt = new TextField();
			txt.textColor = 0xffffff;
			txt.mouseEnabled = false;
			txt.selectable = false;
			txt.maxChars = 5;
			txt.autoSize = TextFieldAutoSize.CENTER;
			
			format = new TextFormat();
			format.bold = true;
			format.size = 14;
			
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x94BAD7, .5);
			bg.graphics.drawRoundRect(0, 0, 100, 40, 8, 8);
			bg.graphics.endFill();
			addChild(bg);
			addChild(txt);
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			if (stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				//0x437EAA
				var ary:Array = convertRGB(0x348DD2);
				setbgColor(ary[0],ary[1],ary[2])
			}
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			//0x94BAD7
			var ary:Array = convertRGB(0x94BAD7);
			setbgColor(ary[0], ary[1], ary[2]);
		}
		
		private function setbgColor(r:int, g:int, b:int):void {
			bg.transform.colorTransform = new ColorTransform(0, 0, 0, 1, r, g, b);
		}
		
		/**
		 * 一个颜色值
		 * @param	num
		 * @return
		 */
		private function convertRGB(num:int):Array {
			var r:int = (num >> 16);
			var g:int = (num - (r << 16)) >> 8;
			var b:int = num - (r << 16) - (g << 8);
			return [r, g, b];
		}
		
		/**
		 * 设置按钮文字
		 * @param	str
		 */
		public function setTxt(str:String):void {
			txt.text = str;
			txt.setTextFormat(format);
			txt.x = (bg.width - txt.width) / 2;
			txt.y = (bg.height - txt.height) / 2;
		}
		
		/**
		 * 设置背景的宽
		 * @param	bgwidth
		 */
		public function setBgWidth(bgwidth:Number):void {
			bg.graphics.clear();
			bg.graphics.beginFill(0x94BAD7, .5);
			bg.graphics.drawRoundRect(0, 0, bgwidth, 40, 8, 8);
			bg.graphics.endFill();
			txt.x = (bg.width - txt.width) / 2;
			txt.y = (bg.height - txt.height) / 2;
		}
		
	}

}