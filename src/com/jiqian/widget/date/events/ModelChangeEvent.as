package com.jiqian.widget.date.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class ModelChangeEvent extends Event 
	{
		public static const CHANGE:String = 'change';
		
		
		public function ModelChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ModelChangeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModelChangeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}