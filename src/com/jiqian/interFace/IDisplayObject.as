package com.jiqian.interFace 
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public interface IDisplayObject extends IEventDispatcher
	{
		function getDisplay():DisplayObject;
		/*{
			return this as DisplayObject
		}*/
		function set x(v:Number):void;
		function get x():Number;
		
		function set y(v:Number):void;
		function get y():Number;
		
		
		function set width(v:Number):void;
		function get width():Number;
		
		function set height(v:Number):void;
		function get height():Number;
		
		
	}
	
}