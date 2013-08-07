package com.ucvcbbs.controls.image.imageView
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ScaleControl クラスの content プロパティに
	 * 指定された DisplayObject を格納するクラス。 
	 * @author tngar
	 */	
	public class ScaleControlContentContainer extends Sprite
	{
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。 
		 */		
		public function ScaleControlContentContainer()
		{
			super();
		}
		
		// content 関連処理  ////////////////////////////////////////////////////////////////
		
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
			}
		}
		
		/**
		 * content の値が変更されたときに呼び出されます。
		 * @param newValue 新しい値。
		 * @param oldValue 古い値。
		 */		
		protected function onContentChange(newValue:DisplayObject, oldValue:DisplayObject):void
		{
			//trace(flash.utils.getQualifiedClassName(this), "onContentChanged():: ");
			
			if(oldValue != null)
			{
				this.removeChild(oldValue);
			}
			if(newValue != null)
			{
				this.addChild(newValue);
			}
		}
	}
}