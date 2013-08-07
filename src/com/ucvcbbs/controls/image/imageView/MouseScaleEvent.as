package com.ucvcbbs.controls.image.imageView
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	/**
	 *　マウスでスケールやパンを扱うときに送出されるイベント。
	 * @author tngar
	 */	
	public class MouseScaleEvent extends MouseEvent
	{
		// パブリック・フィールド ////////////////////////////////////////////////////////////////
		
		/**
		 * ドラッグ移動が開始されたときに送出されます。 
		 */		
		public static const MOUSE_DRAG_START:String = "mouseDragStart";
		/**
		 *　ドラッグ移動が終了したときに送出されます。 
		 */		
		public static const MOUSE_DRAG_STOP:String = "mouseDragStop";
		/**
		 *　ドラッグ移動されたときに送出されます。 
		 */		
		public static const MOUSE_DRAG_MOVE:String = "mouseDragMove";
		/**
		 * マウスをクリックしてズームされたときに送出されます。  
		 */		
		public static const MOUSE_CLICK_ZOOM:String = "mouseClickZoom";
		/**
		 *　マウスホイールを使用してズームインしたときに送出されます。  
		 */		
		public static const MOUSE_WHEEL_ZOOM_IN:String = "mouseWheelZoomIn";
		/**
		 *　マウスホイールを使用してズームアウトしたときに送出されます。  
		 */		
		public static const MOUSE_WHEEL_ZOOM_OUT:String = "mouseWheelZoomOut";
		
		// 初期化関連処理 ////////////////////////////////////////////////////////////////
		
		/**
		 * コンストラクタ。
		 * @param type イベントのタイプです。
		 * @param bubbles Event オブジェクトがイベントフローのバブリング段階で処理されるかどうかを判断します。 
		 * @param cancelable Event オブジェクトがキャンセル可能かどうかを判断します。 
		 * @param localX スプライトを基準とするイベント発生位置の水平座標です。 
		 * @param localY スプライトを基準とするイベント発生位置の垂直座標です。 
		 * @param relatedObject イベントの影響を受ける補完的な InteractiveObject インスタンスです。例えば、mouseOut イベントが発生した場合、relatedObject はポインティングデバイスが現在指している表示リストオブジェクトを表します。
		 * @param ctrlKey Windows または Linux で、Ctrl キーがアクティブになっているかどうかを示します。Macintosh では、Ctrl キーと Command キーのいずれがアクティブになっているかどうかを示します。 
		 * @param altKey Alt キーがアクティブになっているかどうかを示します（Windows または Linux のみ）。 
		 * @param shiftKey Shift キーがアクティブになっているかどうかを示します。 
		 * @param buttonDown マウスの主ボタンが押されているか押されていないかを示します。 
		 * @param delta ユーザーがマウスホイールを 1 目盛り回すごとにスクロールする行数を示します。正の delta 値は上方向へのスクロールを表します。負の値は下方向へのスクロールを表します。一般的な値は 1 ～ 3 の範囲ですが、ホイールの回転が速くなると、delta の値は大きくなります。このパラメータは、MouseEvent.mouseWheel イベントのみで使用されます。 
		 */		
		public function MouseScaleEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=NaN, localY:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
	}
}