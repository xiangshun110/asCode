package com.ucvcbbs.controls.image.imageView
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	[Event(name="actualContentOriginChange", type="SmoothScaleControlEvent")]
	[Event(name="actualContentScaleChange", type="SmoothScaleControlEvent")]
	/**
	 * アニメーションを使用したズームやパンに対応したコンテンツを表示するためのオブジェクトです。  
	 * @author tngar
	 */	
	public class SmoothScaleControl extends ScaleControl
	{
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。 
		 * 
		 */		
		public function SmoothScaleControl()
		{
			super();
		}
		
		// actualContentOrigin 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _actualContentOrigin:Point = null;
		/**
		 * 表示されるコンテンツの領域の左上隅の座標の実際の値。
		 * アニメーション中は contentOrigin の値と
		 * 実際に表示されるコンテンツの座標が異なる場合があります。
		 */
		public function get actualContentOrigin():Point
		{
			return this._actualContentOrigin;
		}
		
		/**
		 * actualContentOrigin　の値を設定します。
		 * @param value 設定する値。
		 */		
		protected function setActualContentOrigin(value:Point):void
		{
			var oldValue:Point = this._actualContentOrigin;
			if(value != oldValue)
			{
				this._actualContentOrigin = value;
				this.onActualContentOriginChange(value, oldValue);
				this.dispatchSmoothScaleControlEventEvent(SmoothScaleControlEvent.ACTUAL_CONTENT_ORIGIN_CHANGE);
			}
		}
		/**
		 * actualContentOrigin の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onActualContentOriginChange(newValue:Point, oldValue:Point):void
		{
			this.refleshContent();
		}
		
		// actualContentScale 関連処理 ////////////////////////////////////////////////////////////////

		private var _actualContentScale:Number = 1.0;
		/**
		 * 表示されるコンテンツの倍率。
		 * アニメーション中は contentScale の値と
		 * 実際に表示されるコンテンツの倍率が異なる場合があります。
		 */
		public function get actualContentScale():Number
		{
			return this._actualContentScale;
		}
		
		/**
		 * actualContentScale　の値を設定します。
		 * @param value 設定する値。
		 */		
		protected function setActualContentScale(value:Number):void
		{
			value = Math.min(Math.max(value, this.minContentScale), this.maxContentScale);
			
			var oldValue:Number = this._actualContentScale;
			if(value != oldValue)
			{
				value = this.coerceContentScale(value);
				this._actualContentScale = value;
				this.onActualContentScaleChange(value, oldValue);
				this.dispatchSmoothScaleControlEventEvent(SmoothScaleControlEvent.ACTUAL_CONTENT_SCALE_CHANGE);
			}
		}
		
		/**
		 * actualContentScale の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onActualContentScaleChange(newValue:Number, oldValue:Number):void
		{
			this.refleshContent();
		}
		
		// アニメーション関連処理 ////////////////////////////////////////////////////////////////
		
		private var _frameCount:int = 24;
		/**
		 * アニメーションの総フレーム数。 
		 */		
		public function get frameCount():int
		{
			return this._frameCount;
		}
		
		public function set frameCount(value:int):void
		{
			if(value<0)
			{
				throw new Error("\"frameCount\" は 0 以上である必要があります。");
			}
			var oldValue:int = this._frameCount;
			if(value != oldValue)
			{
				this._frameCount = value;
				this.onFrameCountChange(value, oldValue);
			}
		}
		
		/**
		 * animationFrameCount の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onFrameCountChange(newValue:int, oldValue:int):void
		{
			this.setCurrentFrame(Math.min(this.currentFrame, newValue));
		}
		
		private var _currentFrame:int = 0;
		/**
		 * 現在のフレーム数。 
		 */		
		public function get currentFrame():int
		{
			return this._currentFrame;
		}
		
		/**
		 * currentFrame の値を設定します。
		 * @param value 設定する値。
		 */		
		protected function setCurrentFrame(value:int):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "setCurrentFrame():: ");
			
			var oldValue:int = this._currentFrame;
			if(value != oldValue)
			{
				this._currentFrame = value;
				this.onCurrentFrameChange(value, oldValue);
			}
		}
		
		/**
		 * currentFrame の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onCurrentFrameChange(newValue:Number, oldValue:Number):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onCurrentFrameChange():: ");
			
			if(newValue <= 0)
			{
				// フレームが 0 以下の場合は何もしません。
			}
			else if(newValue <= this.frameCount)
			{
				var origin:Point = this.getCurrentOrigin(this._actualContentOriginOrigin, this.contentOrigin, this.currentFrame, this.frameCount);
				var scale:Number = this.getCurrentScale(this._actualContentScaleOrigin, this.contentScale, this.currentFrame, this.frameCount);
				this.setActualContentOrigin(origin);
				this.setActualContentScale(scale);
			}
			else
			{
				this.setActualContentOrigin(this.contentOrigin);
				this.setActualContentScale(this.contentScale);
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
				this.setCurrentFrame(0);
			}
		}
		
		// actualContentOrigin の開始値。アニメーションで使用されます。
		private var _actualContentOriginOrigin:Point = null;
		// actualContentScaleOrigin の開始値。アニメーションで使用されます。
		private var _actualContentScaleOrigin:Number = 1;
		
		/**
		 *　アニメーションを開始します。 
		 */		
		protected function beginSmoothAnimation():void
		{
			// trace(flash.utils.getQualifiedClassName(this), "beginSmoothAnimation():: ");
			
			if(this.frameCount > 0)
			{
				if(this.currentFrame <= 0)
				{
					this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
				}
				this._actualContentOriginOrigin = this.actualContentOrigin;
				this._actualContentScaleOrigin = this.actualContentScale;
				this.setCurrentFrame(0);
			}
			else
			{
				this.setActualContentOrigin(this.contentOrigin);
				this.setActualContentScale(this.contentScale);
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}
		}
		
		/**
		 * 再生ヘッドが新しいフレームに入るときに呼び出されます。
		 * @param event イベントデータ。
		 */		
		private function onEnterFrame(event:Event):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onEnterFrame():: ");
			
			if(this.content == null)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}
			else
			{
				this.setCurrentFrame(this.currentFrame + 1);
			}
		}
		
		/**
		 * パラメータで指定された値を元に現在の contentOrigin の値を取得します。 
		 * アニメーションの挙動を変更する場合はこのメソッドをオーバーライドします。
		 * @param origin 開始値。
		 * @param destination 終了値。
		 * @param currentFrame 現在のフレーム数。
		 * @param frameCount 総フレーム数。
		 * @return 現在の値。
		 */	
		protected function getCurrentOrigin(origin:Point, destination:Point, currentFrame:int, frameCount:int):Point
		{
			var result:Point = new Point();
			result.x = this.getCurrentValue(origin.x, destination.x, currentFrame, frameCount);
			result.y = this.getCurrentValue(origin.y, destination.y, currentFrame, frameCount);
			
			return result;
		}
		
		/**
		 * パラメータで指定された値を元に現在の contentScale の値を取得します。 
		 * アニメーションの挙動を変更する場合はこのメソッドをオーバーライドします。
		 * @param origin 開始値。
		 * @param destination 終了値。
		 * @param currentFrame 現在のフレーム数。
		 * @param frameCount 総フレーム数。
		 * @return 現在の値。
		 */	
		protected function getCurrentScale(origin:Number, destination:Number, currentFrame:int, frameCount:int):Number
		{
			var result:Number = this.getCurrentValue(origin, destination, currentFrame, frameCount);
			result = this.coerceContentScale(result);
			
			return result;
		}
		
		/**
		 * パラメータで指定された値を元に現在の値を取得します。 
		 * アニメーションの挙動を変更する場合はこのメソッドをオーバーライドします。
		 * @param origin 開始値。
		 * @param destination 終了値。
		 * @param currentFrame 現在のフレーム数。
		 * @param frameCount 総フレーム数。
		 * @return 現在の値。
		 */		
		protected function getCurrentValue(origin:Number, destination:Number, currentFrame:int, frameCount:int):Number
		{
			var result:Number = destination;
			
			// 現在のフレーム位置の割合を計算します。
			var frameRate:Number = Number(currentFrame)/Number(frameCount);
			// 差分の割合を計算します。
			var deltaRate:Number = -Math.pow(frameRate-1, 4) + 1;
			// 結果を計算します。
			result = origin +  ((destination - origin) * deltaRate);
			
			return result;
		}
		
		// イベント関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * プロパティが変更されたときに呼び出されます。 
		 * @param type イベントの種類。
		 */		
		protected function dispatchSmoothScaleControlEventEvent(type:String):void
		{
			var event:SmoothScaleControlEvent = new SmoothScaleControlEvent(type);
			this.dispatchEvent(event);
		}
		
		// ScaleControl 関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */		
		override protected function onContentOriginChange(newValue:Point, oldValue:Point):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onContentOriginChanged():: ");
			
			if(this.frameCount > 0)
			{
				this.beginSmoothAnimation();
			}
			else
			{
				this.setActualContentOrigin(newValue);
			}
		}
		/**
		 * @inheritDoc
		 */
		override protected function onContentScaleChange(newValue:Number, oldValue:Number):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onContentScaleChanged():: ");
			
			if(this.frameCount > 0)
			{
				this.beginSmoothAnimation();
			}
			else
			{
				this.setActualContentScale(newValue);
			}
		}
		/**
		 * @inheritDoc
		 */	
		override protected function onContentChange(newValue:DisplayObject, oldValue:DisplayObject):void
		{
			// コンテンツを変更する間、アニメーションを適用しないように設定します。
			var animationFrameCount:int = this.frameCount;
			this.frameCount = 0;
			// コンテンツを更新します。
			super.onContentChange(newValue, oldValue);
			// アニメーション設定を元に戻します。
			this.frameCount = animationFrameCount;
		}
		/**
		 * @inheritDoc
		 */	
		override protected function refleshContent():void
		{
			// trace(flash.utils.getQualifiedClassName(this), "refleshContent():: ");
			
			if(this.content != null)
			{
				// スケール。
				var scale:Number = this.actualContentScale;
				this.container.scaleX = scale;
				this.container.scaleY = scale;
				// 位置。
				var position:Point = this.actualContentOrigin;
				if(position != null)
				{
					this.container.x = position.x;
					this.container.y = position.y;
				}
			}
		}
	}
}