package com.jiqian.widget.date.view
{
	import com.jiqian.display.Pen;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class ArrowButton extends SimpleButton
	{
		public static function createLeft():ArrowButton
		{
			var b:ArrowButton = new ArrowButton;
			b.toLeft();
			return b;
		}
		public static function createRight():ArrowButton
		{
			var b:ArrowButton = new ArrowButton;
			b.toRight();
			return b;
		}
		
		
		
		//-------------------------------
		private var up:Sprite;
		private var over:Sprite;
		private var down:Sprite;
		private var hit:Sprite;
		
		public function ArrowButton()
		{
			up = create3(0);
			over = create3(0x10A8C2);
			down = create3(0x8FE7F5);
			hitTestState = Pen.createShape(up.width, up.height);
			this.useHandCursor = false;
		}
		
		public function toLeft():void
		{
			upState = up;
			overState = over;
			downState = downState;
		}
		public function toRight():void
		{
			up.scaleX = -1;
			over.scaleX = -1;
			down.scaleX = -1;
			
			upState = up;
			overState = over;
			downState = downState;
			hitTestState.scaleX = -1;
		}
		
		
		public function moveTo(p:Point):void
		{
			x = p.x;
			y = p.y;
		}
		
		
		public function create3(nColor:Number):Sprite
		{
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(nColor);
			sp.graphics.moveTo(5, 0);
			sp.graphics.lineTo(0, 5);
			sp.graphics.lineTo(5, 10);
			sp.graphics.lineTo(5, 0);
			sp.graphics.endFill();
			return sp;
		}
		
		
		public function setEnabled(v:Boolean):void
		{
			alpha = v ? 1 : 0.5;
			mouseEnabled = v;
		}
		
		
	}
	
}