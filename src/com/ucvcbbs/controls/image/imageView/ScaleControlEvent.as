package com.ucvcbbs.controls.image.imageView
{
	import flash.events.Event;
	
	/**
	 *　ScaleControl　で使用されるイベント。
	 * @author tngar
	 */	
	public class ScaleControlEvent extends Event
	{
		// パブリック・フィールド ////////////////////////////////////////////////////////////////
		
		/**
		 * コンテントが変更されたときに送出されます。
		 */		
		public static const CONTENT_CHANGE:String = "contentChange";
		/**
		 * contentOrigin プロパティが変更されたときに送出されます。
		 */		
		public static const CONTENT_ORIGIN_CHANGE:String = "contentOriginChange";
		/**
		 *　contentScale プロパティが変更されたときに送出されます。
		 */		
		public static const CONTENT_SCALE_CHANGE:String = "contentScaleChange";
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。 
		 * @param type イベントタイプ。イベントをトリガしたアクションを示します。
		 * @param bubbles イベントが表示リスト階層を上方にバブルできるかどうかを指定します。
		 * @param cancelable イベントに関連付けられた動作をキャンセルできるかどうかを指定します。
		 */	
		public function ScaleControlEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}