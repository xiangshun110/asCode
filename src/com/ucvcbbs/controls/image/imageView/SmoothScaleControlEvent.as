package com.ucvcbbs.controls.image.imageView
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *　SmoothScaleControl　で使用されるイベント。
	 * @author tngar
	 * 
	 */	
	public class SmoothScaleControlEvent extends Event
	{
		// パブリック・フィールド ////////////////////////////////////////////////////////////////
		
		/**
		 *　actualContentOrigin　プロパティが変更されたときに送出されます。
		 */		
		public static const ACTUAL_CONTENT_ORIGIN_CHANGE:String = "actualContentOriginChange";
		/**
		 *　actualContentScale　プロパティが変更されたときに送出されます。
		 */		
		public static const ACTUAL_CONTENT_SCALE_CHANGE:String = "actualContentScaleChange";
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。 
		 * @param type イベントタイプ。イベントをトリガしたアクションを示します。
		 * @param bubbles イベントが表示リスト階層を上方にバブルできるかどうかを指定します。
		 * @param cancelable イベントに関連付けられた動作をキャンセルできるかどうかを指定します。
		 */	
		public function SmoothScaleControlEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}