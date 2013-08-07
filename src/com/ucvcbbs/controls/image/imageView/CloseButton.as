package com.ucvcbbs.controls.image.imageView 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class CloseButton extends Sprite 
	{
		private var r:int;
		public function CloseButton() 
		{
			init();
		}
		
		private function init():void {
			r = 20;
			this.useHandCursor = true;
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(1, 0x999999);
			this.graphics.drawCircle(0, 0,r);
			this.graphics.endFill();
			this.graphics.lineStyle(3, 0xcccccc);
			this.graphics.moveTo(Math.cos(45 * 180 / Math.PI) * r, Math.sin(45 * 180 / Math.PI) * r);
			this.graphics.lineTo(0, 0);
			this.graphics.moveTo(Math.cos(-45 * 180 / Math.PI) * r, Math.sin(-45 * 180 / Math.PI) * r);
			this.graphics.lineTo(0, 0);
			this.graphics.moveTo(Math.cos(125 * 180 / Math.PI) * r, Math.sin(125 * 180 / Math.PI) * r);
			this.graphics.lineTo(0, 0);
			this.graphics.moveTo(Math.cos(-125 * 180 / Math.PI) * r, Math.sin(-125 * 180 / Math.PI) * r);
			this.graphics.lineTo(0, 0);
			this.graphics.endFill();
		}
		
	}

}