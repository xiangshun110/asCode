package skin 
{
	
	//import com.jiqian.display.Scale9Sprite;
	//import com.jiqian.tool.BitmapManager;
	import com.jiqian.display.ScaleBitmap;
	import com.jiqian.widget.date.view.TextAlign;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;


	public class BSprite extends Sprite
	{
		private var base:ScaleBitmap;
		private var _textfield:TextField;
		
		public function BSprite(i:Number, textColor:Number = 0)
		{
			var data:BitmapData = new BitmapData(12, 9, true, 0xeaf8ff);
			base = new ScaleBitmap(data);
			base.alpha = i;
			addChild(base);
			
			_textfield = new TextField;
			_textfield.autoSize = 'left';
			addChild(_textfield);
			
			setColor(textColor);
		}
		
		
		private var text:String = '';
		public function setText(v:String):void
		{
			_textfield.text = v;
			text = v;
			setAlign(alignType);
		}
		
		
		
		public function setColor(v:Number):void
		{
			var tf:TextFormat = _textfield.getTextFormat();
			tf.color = v;
			_textfield.defaultTextFormat = tf;
			setText(text);
		}
		
		
		
		
		private var alignType:String = 'center';
		public function setAlign(alignType:String):void
		{
			this.alignType = alignType;
			switch(alignType)
			{
				case TextAlign.LEFT:
				_textfield.x = 0;
				break;
				case TextAlign.CENTER:
				_textfield.x = Math.floor((width - _textfield.width) / 2);
				break;
				case TextAlign.RIGHT:
				_textfield.x = width - _textfield.width - 2;
				break;
			}
			_textfield.y = (height - _textfield.height) / 2;
		}
		
		
		
		override public function get width():Number { return base.width; }
		
		override public function set width(value:Number):void 
		{
			base.width = value;
		}
		
		
		override public function get height():Number { return base.height; }
		
		override public function set height(value:Number):void 
		{
			base.height = value;
		}
		
		
		
	}
	
}