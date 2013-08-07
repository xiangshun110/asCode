package com.ucvcbbs.controls.image.imageView
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[Event(name="mouseDragStart", type="MouseScaleEvent")]
	[Event(name="mouseDragStop", type="MouseScaleEvent")]
	[Event(name="mouseDragMove", type="MouseScaleEvent")]
	[Event(name="mouseClickZoom", type="MouseScaleEvent")]
	[Event(name="mouseWheelZoomIn", type="MouseScaleEvent")]
	[Event(name="mouseWheelZoomOut", type="MouseScaleEvent")]
	/**
	 * マウスを使用してズームやパンに対応したコンテンツを表示するためのオブジェクトです。   
	 * @author tngar
	 */	
	public class MouseSmoothScaleControl extends SmoothScaleControl
	{
		// プライベート・フィールド ////////////////////////////////////////////////////////////////
		
		// 背景を描画するコンテナ。
		private var _backgroundContainer:Sprite;
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。 
		 */
		public function MouseSmoothScaleControl()
		{
			super();
			
			this.initialize();
		}
		
		/**
		 * 初期化します。
		 */		
		private function initialize():void
		{
			// 背景を初期化します。
			this.initializeBackground();
			// イベントハンドラを追加します。
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
			this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
		}
		
		// 背景関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * 背景を初期化します。 
		 */		
		private function initializeBackground():void
		{
			var hitGraphics:Sprite = new Sprite();
			this._backgroundContainer = hitGraphics;
			this.addChildAt(hitGraphics, 0);
		}
		
		protected var _backgroundColor:uint = 0xFFFFFF;
		/**
		 * 背景色。
		 */		
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}
		public function set backgroundColor(value:uint):void
		{
			var oldValue:uint = this._backgroundColor;
			if(value != oldValue)
			{
				this._backgroundColor = value;
				this.onBackgroundColorChange(value, oldValue);
			}
		}
		
		/**
		 *　背景色が変更されたときに呼び出されます。
		 * @param newValue　新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onBackgroundColorChange(newValue:uint, oldValue:uint):void
		{
			this.refleshBackground();
		}
		
		private var _backgroundAlpha:Number = 0.0;
		/**
		 * 背景色の透明度。
		 */		
		public function get backgroundAlpha():Number
		{
			return this._backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void
		{
			var oldValue:Number = this._backgroundAlpha;
			if(value != oldValue)
			{
				this._backgroundAlpha = value;
				this.onBackgroundAlphaChange(value, oldValue);
			}
		}
		
		/**
		 * 背景色の透明度が変更されたときに呼び出されます。
		 * @param newValue　新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onBackgroundAlphaChange(newValue:Number, oldValue:Number):void
		{
			this.refleshBackground();
		}
		
		/**
		 * 背景を更新します。 
		 */		
		protected function refleshBackground():void
		{
			// ヒットエリアを更新します。
			if(this._backgroundContainer != null)
			{
				this._backgroundContainer.graphics.clear();
				this._backgroundContainer.graphics.beginFill(this.backgroundColor, this.backgroundAlpha);
				this._backgroundContainer.graphics.drawRect(0,0,width,height);
			}
		}
		
		// マウス関連処理 ////////////////////////////////////////////////////////////////
		
		private var _clickScale:Number = 1.5;
		/**
		 * クリックされたときにズームする倍率。
		 */		
		public function get clickScale():Number
		{
			return this._clickScale;
		}
		public function set clickScale(value:Number):void
		{
			this._clickScale = value;
		}
		
		private var _mouseWheelScale:Number = 1/16;
		/**
		 * マウスホイールが回転されたときにズームする倍率。
		 */		
		public function get mouseWheelScale():Number
		{
			return this._mouseWheelScale;
		}
		public function set mouseWheelScale(value:Number):void
		{
			this._mouseWheelScale = value;
		}
		
		// イベント関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * MouseScaleEvent イベントをイベントフローに送出します。
		 * @param type イベントの種類。
		 * @param mouseEvent 元となる mouseEvent 。
		 */
		protected function dispatchMouseScaleEvent(type:String, mouseEvent:MouseEvent):void
		{
			var localPoint:Point = this.globalToLocal(new Point(mouseEvent.stageX, mouseEvent.stageY));
			var event:MouseScaleEvent = new MouseScaleEvent
			(
				type,
				mouseEvent.bubbles,
				mouseEvent.cancelable,
				this.mouseX,
				this.mouseY,
				mouseEvent.relatedObject,
				mouseEvent.ctrlKey,
				mouseEvent.altKey,
				mouseEvent.shiftKey,
				mouseEvent.buttonDown,
				mouseEvent.delta
			);
			this.dispatchEvent(event);
		}
		
		private var _isMouseDown:Boolean = false;
		/**
		 * このコントロール上でポインティングデバイスを押されたかどうかを示すブール値。
		 */		
		protected function get isMouseDown():Boolean
		{
			return this._isMouseDown;
		}
		
		private var _isDrag:Boolean = false;
		/**
		 * ドラッグ中かどうかを示すブール値。
		 */		
		protected function get isDrag():Boolean
		{
			return this._isDrag;
		}
		
		private var _preMousePosition:Point = null;
		/**
		 * 前回のマウスの位置。 
		 */		
		protected function get preMousePosition():Point
		{
			return this._preMousePosition;
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンス上でポインティングデバイスのボタンを押したときに呼び出されます。
		 * @param event イベントデータ。
		 */		
		private function onMouseDown(event:MouseEvent):void
		{
			var localPoint:Point = new Point(this.mouseX, this.mouseY);
			this._preMousePosition = localPoint;
			this._isDrag = false;
			this._isMouseDown = true;
		}
		
		/**
		 * ユーザーがポインティングデバイスを移動させたときに呼び出されます。
		 * @param event イベントデータ。
		 */		
		private function onMouseMove(event:MouseEvent):void
		{
			var oldIsDrag:Boolean = this.isDrag;
			if(this.isMouseDown)
			{
				this._isDrag = true;
			}
			if(this.isDrag)
			{
				var pre:Point = this.preMousePosition;
				var current:Point = new Point(this.mouseX, this.mouseY);
				if(pre != null)
				{
					var vector:Point = new Point(current.x-pre.x, current.y-pre.y);
					this.moveBy(vector);
				}
				this._preMousePosition = current;
				if(!oldIsDrag)
				{
					this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_DRAG_START, event);
				}
				else
				{
					this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_DRAG_MOVE, event);
				}
			}
		}
		
		/**
		 * ユーザーがポインティングデバイスを離したときに呼び出されます。
		 * @param event イベントデータ。
		 */		
		private function onRollOut(event:MouseEvent):void
		{
			var oldIsDrag:Boolean = this.isDrag;
			this._isDrag = false;
			this._isMouseDown = false;
			this._preMousePosition = null;
			if(oldIsDrag)
			{
				this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_DRAG_STOP, event);
			}
		}
		
		/**
		 * ユーザーがポインティングデバイスのボタンを離したときに呼び出されます。
		 * @param event イベントデータ。
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			// ドラッグ中でない場合
			if(this.isMouseDown && !this.isDrag)
			{
				var scale:Number = this.contentScale * this.clickScale;
				var position:Point = new Point(this.mouseX, this.mouseY);
				this.zoomAt(scale, position);
				this._isMouseDown = false;
				this._isDrag = false;
				this._preMousePosition = null;
				
				this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_CLICK_ZOOM, event);
			}
			// ドラッグ中の場合
			else
			{
				this._isMouseDown = false;
				this._isDrag = false;
				this._preMousePosition = null;
				this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_DRAG_STOP, event);
			}
		}
		
		/**
		 * マウスホイールが動かされたときに呼び出されるイベントハンドラ。
		 * このハンドラをマウスホイールイベントに関連付けます。
		 * @param event イベントデータ。
		 */			
		private function onMouseWheel(event:MouseEvent):void
		{
			var delta:Number = Number(event.delta) * this.mouseWheelScale;
			var current:Number = this.contentScale;
			var scale:Number = 1.0;
			var position:Point = new Point(this.mouseX, this.mouseY);
			if(delta<0)
			{
				scale = current / (1 - delta);
				this.zoomAt(scale, position);
				this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_WHEEL_ZOOM_OUT, event);
			}
			else(delta>0)
			{
				scale = current * (1 + delta);
				this.zoomAt(scale, position);
				this.dispatchMouseScaleEvent(MouseScaleEvent.MOUSE_WHEEL_ZOOM_IN, event);
			}
		}
		
		/**
		 * @inheritDoc 
		 */	
		override protected function onResize():void
		{
			super.onResize();
			
			// 背景を更新します。
			this.refleshBackground();
		}
	}
}