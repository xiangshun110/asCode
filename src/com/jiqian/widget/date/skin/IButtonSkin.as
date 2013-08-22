package com.jiqian.widget.date.skin 
{
	import com.jiqian.interFace.IDisplayObject;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public interface IButtonSkin extends IDisplayObject
	{
		
		/**
		 * 被选中时
		 * @param	b
		 */
		function setSelected (b:Boolean) : void;

		function getSelected () : Boolean;
		
		
		/**
		 * 设置为今日
		 * @param	v
		 */
		function setIsToday(v:Boolean):void;
		
		
		/**
		 * 设宽
		 * @param	v
		 */
		function setWidth (v:Number) : void;

		function getWidth () : Number;

		/**
		 * 设高
		 * @param	v
		 */
		function setHeight (v:Number) : void;

		function getHeight () : Number;

		
		/**
		 * 设为灰色的
		 * @param	b
		 */
		function setAshColor (b:Boolean) : void;

		
		/**
		 * 设置按钮的文字
		 * @param	str
		 */
		function setText (str:String) : void;

		
		/**
		 * 显示
		 * @param	b
		 */
		function setTextVisible (b:Boolean) : void;

		
		/**
		 * 设置文本对齐方式
		 * TextAlign.LEFT
		 * TextAlign.CENTER
		 * TextAlign.RIGHT
		 * @param	v
		 */
		function setAlign (v:String) : void;

		
		/**
		 * 带一点数据吧
		 * @param	v
		 */
		function setData (v:Object) : void;

		function getData () : Object;
		
	}
	
}