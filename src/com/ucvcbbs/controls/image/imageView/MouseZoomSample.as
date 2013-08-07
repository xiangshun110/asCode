package com.ucvcbbs.controls.image.imageView
{
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	public class MouseZoomSample extends Sprite
	{
		
		private var _scaleControl:MouseSmoothScaleControl = null;
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。
		 * 
		 */		
		public function MouseZoomSample()
		{
			super();
			trace(flash.utils.getQualifiedClassName(this), "MouseZoomSample():: ");
			
			// 使い方：導入 ////////////////////////////////////////////////////////////////
			
			//  MouseSmoothScaleControl のインスタンスを生成します。
			var scaleControl:MouseSmoothScaleControl = new MouseSmoothScaleControl();
			// サイズを設定します。
			scaleControl.width = this.stage.stageWidth;
			scaleControl.height = this.stage.stageHeight;
			// ズームやパンの対象となるコンテンツを MouseSmoothScaleControl.content に設定します。
			//scaleControl.content =  new MouseZoomContent();
			//  MouseSmoothScaleControl のインスタンスをステージに配置します。
			this.addChild(scaleControl);
			// これだけ。
			
			// 使い方：オプション ////////////////////////////////////////////////////////////////
			
			// 指定移动范围
			 scaleControl.contentBounds = new Rectangle(0,0,1024,768);
			
			// 指定最大的放大值
			//scaleControl.maxContentScale = 100;
			
			// 指定最小缩放
			//scaleControl.minContentScale = 1/100;
			
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
			
			
			
			this._scaleControl = scaleControl;
			
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			// ステージサイズが変更されたときのハンドラを設定します。
			this.stage.addEventListener(Event.RESIZE, this.onStageResize);
		}

		/**
		 * ステージサイズが変更されたときに呼び出されます。 
		 * @param event イベントデータ。
		 */
		private function onStageResize(event:Event):void
		{
			trace(flash.utils.getQualifiedClassName(this), "onStageResize():: ");
			// MouseSmoothScaleControl のインスタンスをリサイズします。
			this._scaleControl.width = this.stage.stageWidth;
			this._scaleControl.height = this.stage.stageHeight;
		}
	}
}