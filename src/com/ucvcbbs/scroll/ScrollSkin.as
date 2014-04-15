package com.ucvcbbs.scroll
{
	import flash.display.DisplayObject;
	import com.ucvcbbs.utils.CapabilitiesCore;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Main
	 */
	public class ScrollSkin extends Sprite 
	{
		public var WIDTH:Number = 0;
		public var HEIGHT:Number = 0;
		
		[Embed(source="scroll_indicator_top.png")]
		private var topSkinClass:Class;
		[Embed(source="scroll_indicator_middle.png")]
		private var middleSkinClass:Class;
		[Embed(source="scroll_indicator_bottom.png")]
		private var bottomSkinClass:Class;
		
		[Embed(source="scroll_indicator_top_200.png")]
		private var topSkinClass_200:Class;
		[Embed(source="scroll_indicator_middle_200.png")]
		private var middleSkinClass_200:Class;
		[Embed(source="scroll_indicator_bottom_200.png")]
		private var bottomSkinClass_200:Class;
		
		
		[Embed(source="wscroll_indicator_top.png")]
		private var wtopSkinClass:Class;
		[Embed(source="wscroll_indicator_middle.png")]
		private var wmiddleSkinClass:Class;
		[Embed(source="wscroll_indicator_bottom.png")]
		private var wbottomSkinClass:Class;
		
		[Embed(source="wscroll_indicator_top_200.png")]
		private var wleftSkinClass_200:Class;
		[Embed(source="wscroll_indicator_middle_200.png")]
		private var wmiddleSkinClass_200:Class;
		[Embed(source="wscroll_indicator_bottom_200.png")]
		private var wrightSkinClass_200:Class;
		
		
		private var topSkin:DisplayObject;
		private var middleSkin:DisplayObject;
		private var bottomSkin:DisplayObject;
		private var _height:Number;
		private var _width:Number;
		
		public function ScrollSkin(vole:String) 
		{
			init(vole);
			WIDTH = width;
			HEIGHT = height;
		}
		private function init(vole:String):void
		{
			if (vole == "H")
			{
				topSkin = CapabilitiesCore.DPI > 300?new topSkinClass() : new topSkinClass_200() ;
				//topSkin = new topSkinClass();
				
				addChild(topSkin);
				
				middleSkin = CapabilitiesCore.DPI > 300?new middleSkinClass() :new middleSkinClass_200() ;
				//middleSkin = new middleSkinClass();
				middleSkin.y = topSkin.height;
				trace(middleSkin.y);
				addChild(middleSkin);
				
				bottomSkin = CapabilitiesCore.DPI > 300?new bottomSkinClass() :new bottomSkinClass_200() ;
				//bottomSkin = new bottomSkinClass();
				addChild(bottomSkin);
				
			}
			else {
				
				topSkin = CapabilitiesCore.DPI > 300?new wtopSkinClass() : new wleftSkinClass_200() ;
				//topSkin = new topSkinClass();
				addChild(topSkin);
				
				middleSkin = CapabilitiesCore.DPI > 300?new wmiddleSkinClass() :new wmiddleSkinClass_200() ;
				//middleSkin = new middleSkinClass();
				middleSkin.x = topSkin.width;
				addChild(middleSkin);
				
				bottomSkin = CapabilitiesCore.DPI > 300?new wbottomSkinClass() :new wrightSkinClass_200() ;
				//bottomSkin = new bottomSkinClass();
				addChild(bottomSkin);
				
			}
			
		}
		
		override public function set height(value:Number):void
		{
			if (!isNaN(value) && value != _height)
			{
				middleSkin.height = Math.floor(value - topSkin.height - bottomSkin.height);
				bottomSkin.y = Math.round(middleSkin.height + topSkin.height);
			}
			_height = value;
		}
		
		override public function set width(value:Number):void
		{
			if (!isNaN(value) && value != _width)
			{
				middleSkin.width = Math.floor(value - topSkin.width - bottomSkin.width);
				bottomSkin.x = Math.round(middleSkin.width + topSkin.width);
			}
			_width = value;
		}
	}

}