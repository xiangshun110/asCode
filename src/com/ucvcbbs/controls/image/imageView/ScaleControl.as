package com.ucvcbbs.controls.image.imageView
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="contentChange", type="ScaleControlEvent")]
	[Event(name="contentOriginChange", type="ScaleControlEvent")]
	[Event(name="contentScaleChange", type="ScaleControlEvent")]
	/**
	 * ズームやパンに対応したコンテンツを表示するためのオブジェクトです。 
	 * @author tngar
	 * 
	 */
	public class ScaleControl extends Sprite
	{
		// プライベート・フィールド ////////////////////////////////////////////////////////////////
		
		// コンテンツを格納するコンテナ。
		protected var container:ScaleControlContentContainer;
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。
		 */		
		public function ScaleControl()
		{
			super();
			
			this.initialize();
		}
		
		/**
		 * 初期化します。
		 */		
		private function initialize():void
		{
			// コンテナを生成してビューツリーに追加します。
			var container:ScaleControlContentContainer = new ScaleControlContentContainer();
			this.addChild(container);
			this.container = container;
			
			// マスクを初期化します。
			this.initializeMask();
		}
		
		// content 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _content:DisplayObject = null;
		/**
		 * ズームやパンの対象となるコンテンツ。
		 */
		public function get content():DisplayObject
		{
			return this._content;
		}
		public function set content(value:DisplayObject):void
		{
			var oldValue:DisplayObject = this._content;
			if(value != oldValue)
			{
				this._content = value;
				this.onContentChange(value, oldValue);
				this.dispatchScaleControlEventEvent(ScaleControlEvent.CONTENT_CHANGE);
			}
		}
		
		/**
		 * content の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onContentChange(newValue:DisplayObject, oldValue:DisplayObject):void
		{
			this.container.content = newValue;
			if(newValue == null)
			{
				this.setContentOrigin(null);
			}
			else
			{
				this.setContentOrigin(new Point(0,0));
			}
			this.refleshContent();
		}
		
		/**
		 *  コンテンツを更新します。
		 */		
		protected function refleshContent():void
		{
			// trace(flash.utils.getQualifiedClassName(this), "refleshContent():: ");
			
			if(this.content != null)
			{
				// スケール。
				var scale:Number = this.contentScale;
				this.container.scaleX = scale;
				this.container.scaleY = scale;
				// 位置。
				var position:Point = this.contentOrigin;
				if(position != null)
				{
					this.container.x = position.x;
					this.container.y = position.y;
				}
			}
		}
		
		// contentBounds 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _contentBounds:Rectangle = null;
		/**
		 * ズームやパンによるコンテンツの移動範囲を制限する矩形。
		 * contentBounds よりも表示領域のほうが大きい場合はセンターに表示されます。
		 * 値を設定していない場合は制限されません。
		 */
		public function get contentBounds():Rectangle
		{
			return this._contentBounds;
		}
		public function set contentBounds(value:Rectangle):void
		{
			var oldValue:Rectangle = this._contentBounds;
			if(value != oldValue)
			{
				this._contentBounds = value;
				this.onContentBoundsChange(value, oldValue);
			}
		}
		
		/**
		 * contentBounds の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onContentBoundsChange(newValue:Rectangle, oldValue:Rectangle):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onContentBoundsChange():: ");
			
			if(newValue != null)
			{
				this.setContentOrigin(this.coerceContentOrigin(this.contentOrigin));
			}
		}
		
		// contentOrigin 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _contentOrigin:Point = null;
		/**
		 * 表示されるコンテンツの領域の原点座標。 
		 */
		public function get contentOrigin():Point
		{
			return this._contentOrigin;
		}
		
		/**
		 *　 contentOrigin　プロパティに値を設定します。
		 * @param value 設定する値。
		 */		
		protected function setContentOrigin(value:Point):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "setContentOrigin():: ");
			
			var oldValue:Point = this._contentOrigin;
			
			if(value != oldValue)
			{
				if(value != null && oldValue != null && value.equals(oldValue))
				{
					return;
				}
				value = this.coerceContentOrigin(value);
				this._contentOrigin = value;
				this.onContentOriginChange(value, oldValue);
				this.dispatchScaleControlEventEvent(ScaleControlEvent.CONTENT_ORIGIN_CHANGE);
			}
		}
		
		/**
		 * contentOrigin の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onContentOriginChange(newValue:Point, oldValue:Point):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "onContentOriginChange():: ");
			
			this.refleshContent();
		}
		
		/**
		 * contentOrigin の値を強制します。
		 * @param value 強制する値。
		 * @return 強制された値。
		 */
		protected function coerceContentOrigin(value:Point):Point
		{
			// trace(flash.utils.getQualifiedClassName(this), "coerceContentOrigin():: ");
			
			var result:Point = null;
			if(value != null)
			{
				result = new Point();
				
				var bounds:Rectangle = this.contentBounds;
				if(bounds == null)
				{
					result.x = value.x;
					result.y = value.y;
				}
				else
				{
					var scale:Number = this.contentScale;
					// 領域が限定されている場合。
					if(bounds.width*scale < this.width)
					{
						// コントロールの幅がコンテンツの領域より大きい場合はセンターに配置します。
						result.x = this.width/2 - bounds.width/2*scale - bounds.x*scale;
					}
					else
					{
						result.x = Math.min(Math.max(value.x, this.width - (bounds.x + bounds.width) * scale), -bounds.x*scale);
					}
					if(bounds.height*scale < this.height)
					{
						// コントロールの幅がコンテンツの領域より大きい場合はセンターに配置します。
						result.y = this.height/2 - bounds.height/2*scale - bounds.y*scale;
					}
					else
					{
						result.y = Math.min(Math.max(value.y, this.height - (bounds.y + bounds.height) * scale), -bounds.y*scale);
					}
				}
			}
			return result;
		}
		
		// contentScale 関連処理 ////////////////////////////////////////////////////////////////

		private var _contentScale:Number = 1.0;
		/**
		 * 表示されるコンテンツの倍率。
		 */
		public function get contentScale():Number
		{
			return this._contentScale;
		}
		public function set contentScale(value:Number):void
		{
			var oldValue:Number = this._contentScale;
			if(value != oldValue)
			{
				value = this.coerceContentScale(value);
				this._contentScale = value;
				this.onContentScaleChange(value, oldValue);
				this.dispatchScaleControlEventEvent(ScaleControlEvent.CONTENT_SCALE_CHANGE);
			}
		}
		
		/**
		 * contentScale の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onContentScaleChange(newValue:Number, oldValue:Number):void
		{
			this.refleshContent();
		}
		
		/**
		 * contentScale の値を強制します。
		 * @param value 強制する値。
		 * @return 強制された値。
		 */		
		protected function coerceContentScale(value:Number):Number
		{
			var result:Number = Math.min(Math.max(value, this.minContentScale), this.maxContentScale);
			
			return result;
		}
		
		// maxContentScale 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _maxContentScale:Number = Number.POSITIVE_INFINITY;
		/**
		 * ズームの最大値。
		 */
		public function get maxContentScale():Number
		{
			return this._maxContentScale;
		}
		public function set maxContentScale(value:Number):void
		{
			if(value < this.minContentScale)
			{
				throw new Error("\"maxContentScale\" は \"minContentScale\" 以上の値である必要があります。");
			}
			var oldValue:Number = this._maxContentScale;
			if(value != oldValue)
			{
				this._maxContentScale = value;
				this.onMaxContentScaleChange(value, oldValue);
			}
		}
		
		/**
		 * maxZoom の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onMaxContentScaleChange(newValue:Number, oldValue:Number):void
		{
			this._contentScale = this.coerceContentScale(this.contentScale);
			this.refleshContent();
		}
		
		// minContentScale 関連処理 ////////////////////////////////////////////////////////////////
		
		private var _minContentScale:Number = 1 / Number.POSITIVE_INFINITY;
		/**
		 * ズームの最小値。
		 */
		public function get minContentScale():Number
		{
			return this._minContentScale;
		}
		public function set minContentScale(value:Number):void
		{
			if(value <= 0 || this.maxContentScale < value)
			{
				throw new Error("\"minContentScale\" は 0 より大きく、\"maxContentScale\" 以下の値である必要があります。");
			}
			var oldValue:Number = this._minContentScale;
			if(value != oldValue)
			{
				this._minContentScale = value;
				this.onMinContentScaleChange(value, oldValue);
			}
		}
		/**
		 * minZoom の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onMinContentScaleChange(newValue:Number, oldValue:Number):void
		{
			this._contentScale = this.coerceContentScale(this.contentScale);
			this.refleshContent();
		}
		
		// マスク関連処理 ////////////////////////////////////////////////////////////////
		
		private function initializeMask():void
		{
			this.mask = new Sprite;
			this.addChild(this.mask);
		}
		
		/**
		 * マスクをリサイズします。 
		 */		
		protected function resizeMask():void
		{
			var mask:Sprite = this.mask as Sprite;
			if(this.mask != null)
			{
				mask.graphics.clear();
				mask.graphics.beginFill(0x000000, 1.0);
				mask.graphics.drawRect(0,0,this.width,this.height);
			}
		}
		
		// パブリック・メソッド ////////////////////////////////////////////////////////////////
		
		/**
		 * パラメータで指定されたベクトルだけ移動します。 
		 * @param vector 移動ベクトルの座標。
		 */		
		public function moveBy(vector:Point):void
		{
			if(this.content!=null)
			{
				var position:Point = this.contentOrigin;
				var x:Number = position.x + vector.x;
				var y:Number = position.y + vector.y;
				this.setContentOrigin(new Point(x, y));
			}
		}
		
		/**
		 * パラメータで指定した位置に移動します。 
		 * @param position 移動先の座標。
		 */		
		public function moveTo(position:Point):void
		{
			if(this.content!=null)
			{
				this.setContentOrigin(position);
			}
		}
		
		/**
		 * 現在表示中の領域を中心にズームします。 
		 * @param scale 倍率。
		 * 
		 */		
		public function zoom(scale:Number):void
		{
			if(this.content!=null)
			{
				var position:Point = new Point(this.width/2, this.height/2);
				this.zoomAt(scale, position);
			}
		}
		
		/**
		 * パラメータで指定された位置を中心にズームします。 
		 * @param scale ズームするスケール。
		 * @param position ズームの中心となる位置。
		 */		
		public function zoomAt(scale:Number, position:Point):void
		{
			// trace(flash.utils.getQualifiedClassName(this), "zoomAt():: ");
			
			if(this.content != null)
			{
				scale = this.coerceContentScale(scale);
				var currentScale:Number = this.contentScale;
				var currentOrigin:Point = this.contentOrigin;
				if(currentOrigin != null)
				{
					var x:Number = position.x - ((position.x - currentOrigin.x) * scale / currentScale);
					var y:Number = position.y - ((position.y - currentOrigin.y) * scale / currentScale);
					var origin:Point = new Point(x,y);
					
					this.contentScale = scale;
					this.setContentOrigin(origin);
				}
			}
		}
		
		// イベント関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * プロパティが変更されたときに呼び出されます。 
		 * @param type イベントの種類。
		 */		
		protected function dispatchScaleControlEventEvent(type:String):void
		{
			var event:ScaleControlEvent = new ScaleControlEvent(type);
			this.dispatchEvent(event);
		}
		
		// サイズ関連処理 ////////////////////////////////////////////////////////////////
		
		private var _height:Number = 0;
		/**
		 * @inheritDoc 
		 */
		override public function get height():Number
		{
			return this._height;
		}
		override public function set height(value:Number):void
		{
			var oldValue:Number = this._height;
			if(value<0)
			{
				throw new Error("\"height\" は 0 以上である必要があります。");
			}
			if(value != oldValue)
			{
				this._height = value;
				this.onHeightChange(value, oldValue);
			}
		}
		
		private var _width:Number = 0;
		/**
		 * @inheritDoc 
		 */
		override public function get width():Number
		{
			return this._width;
		}
		override public function set width(value:Number):void
		{
			var oldValue:Number = this._width;
			if(value<0)
			{
				throw new Error("\"width\" は 0 以上である必要があります。");
			}
			if(value != oldValue)
			{
				this._width = value;
				this.onWidthChange(value, oldValue);
			}
		}
		
		/**
		 * height の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onHeightChange(newValue:Number, oldValue:Number):void
		{
			this.onResize();
		}
		
		/**
		 * width の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onWidthChange(newValue:Number, oldValue:Number):void
		{
			this.onResize();
		}
		
		/**
		 * サイズが変更されたときに呼び出されます。 
		 */		
		protected function onResize():void
		{
			// マスクをリサイズします。
			this.resizeMask();
			// コンテンツの位置を強制します。
			this.setContentOrigin(this.coerceContentOrigin(this.contentOrigin));
		}
	}
}