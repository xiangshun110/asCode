package com.jiqian.widget.date 
{
	import com.jiqian.display.Pen;
	import com.jiqian.widget.date.events.DateChooseEvent;
	import com.jiqian.widget.date.events.ModelChangeEvent;
	import com.jiqian.widget.date.model.MonthChooseModel;
	import com.jiqian.widget.date.model.DayChooseModel;
	import com.jiqian.widget.date.view.ArrowButton;
	import com.jiqian.widget.date.view.DateShower;
	import com.jiqian.widget.date.view.MotionComponent;
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * 日期选择器，模仿Windows Vista 的.
	 * 可自定义按钮皮肤（接口:com.jiqian.widget.skin.IButtonSkin）
	 * 可自定义星期名称、月份名称
	 * @see setDayNames
	 * @see setMonthNames
	 * 可自定义标题格式
	 * @see setDateFormater
	 * 
	 * @author tangzx 2009.6.9 
	 * @qq 272669294
	 * @mail 272669294@qq.com
	 * @version 1.0
	 * 
	 */
	public class TDateChooser extends Sprite
	{
		public static var skinClassRef:Class;
		
		//月的格式
		public static var EN_MONTH_NAMES:Array = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
		public static var CN_MONTH_NAMES:Array = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
		
		//星期的格式
		public static var EN_DAY_NAMES:Array = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
		public static var CN_DAY_NAMES:Array = ["日", "一", "二", "三", "四", "五", "六"];
		
		//标题显示格式
		public static var DEFAULT_DATE_FORMAT:String = "YYYY年MM月";
		
		public static function defaultDateFormater(d:Date):String
		{
			return d.getFullYear() + "年" + (d.getMonth() + 1) + "月";
		}
		
		
		private var toLButton:ArrowButton;
		private var toRButton:ArrowButton;	//左右箭头
		
		private var textButton:TitleButton;	//标题按钮
		
		private var base:Sprite;	//背景
		private var maskSp:Sprite; 	//遮罩用
		private var content:Sprite; //真正的容器
		
		private var dateShower:DateShower;	//日历
		
		public function TDateChooser()
		{
			this.init();
		}
		
		
		private function init():void
		{
			base = Pen.createShape(197, 180, 0xFFFFFF);
			addChild(base);
			
			maskSp = Pen.createShape(197, 150);
			maskSp.y = 30;
			addChild(maskSp);
			
			content = new Sprite;
			content.y = 30;
			content.mask = maskSp;
			addChild(content);
			
			this.createTitleBar();
			
			
			dateShower = new DateShower;
			dateShower.addEventListener(ModelChangeEvent.CHANGE, 		onModelChange);
			dateShower.addEventListener(DateChooseEvent.CHOOSE_DAY, 	onChoose);
			dateShower.addEventListener(DateChooseEvent.CHOOSE_MONTH, 	onChoose);
			dateShower.addEventListener(DateChooseEvent.CHOOSE_YEAR, 	onChoose);
			dateShower.setDate(new Date);
			
			content.addChild(dateShower);
		}
		
		
		
		private function createTitleBar():Sprite
		{
			
			var titleSprite:Sprite = new Sprite;
			titleSprite.y = 5;
			addChild(titleSprite);
			//标题按钮
			textButton = new TitleButton;
			textButton.setText('---- - --');
			textButton.width = 150;
			textButton.x = Math.floor((width - 150) / 2);
			textButton.addEventListener(MouseEvent.CLICK, changeModel);
			
			//左方向箭
			toLButton = ArrowButton.createLeft();
			toLButton.moveTo(new Point(5, 5));
			toLButton.addEventListener(MouseEvent.CLICK, onPrev);
			
			//右方向箭
			toRButton = ArrowButton.createRight();
			toRButton.moveTo(new Point(width - 5, 5));
			toRButton.addEventListener(MouseEvent.CLICK, onNext);
			
			titleSprite.addChild(textButton);
			titleSprite.addChild(toLButton);
			titleSprite.addChild(toRButton);
			return titleSprite;
		}
		
		
		
		
		
		/**
		 * 显示层级变化
		 * @param	e
		 */
		private function changeModel(e:MouseEvent):void
		{
			dateShower.showLevelUp();
		}
		
		
		
		private function onModelChange(e:ModelChangeEvent):void
		{
			textButton.setText(dateShower.getTitleString());
			
			toLButton.setEnabled(dateShower.getCanL());
			toRButton.setEnabled(dateShower.getCanR());
		}
		
		
		
		/**
		 * 选择日期
		 * @param	e
		 */
		private function onChoose(e:DateChooseEvent):void
		{
			this.dispatchEvent(new DateChooseEvent(e.type, e.date));
		}
		
		
		
		/**
		 * 获取日期
		 * @return
		 */
		public function getDate():Date
		{
			return dateShower.getDate();
		}
		
		
		
		
		/**
		 * 设定日期
		 * @param	date
		 * @param	motion
		 */
		public function setDate(date:Date, motion:Boolean):void
		{
			dateShower.setDate(date, motion);
		}
		
		
		
		
		/**
		 * 星期方法
		 * @param	names
		 */
		public function setDayNames(names:Array):void
		{
			dateShower.dayChooser.setDayNames(names);
		}
		public function getDayNames():Array
		{
			return dateShower.dayChooser.getDayNames();
		}
		
		
		
		/**
		 * 月份的名称
		 * @param	v
		 */
		public function setMonthNames(v:Array):void
		{
			dateShower.monthChooser.setMonthNames(v);
		}
		public function getMonthNames():Array
		{
			return dateShower.monthChooser.getMonthNames();
		}
		
		
		
		
		/**
		 * 往一个
		 * @param	e
		 */
		private function onPrev(e:MouseEvent):void
		{
			dateShower.goNext();
		}
		
		
		/**
		 * 往下一个
		 * @param	e
		 */
		private function onNext(e:MouseEvent):void
		{
			dateShower.goPrev();
		}
		
		
		
		
		/**
		 * 显示格式
		 * @param	format
		 */
		public function setTitleFormater(func:Function):void
		{
			dateShower.setDateFormater(func);
		}
		
		
		
		
		
		
		
		
		override public function get width():Number { return maskSp.width; }
		override public function get height():Number { return maskSp.height + 30; }
	}
	
}



import com.jiqian.display.Pen;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class TitleButton extends SimpleButton
{
	private var s1text:TextField;
	private var s2text:TextField;
	private var s3text:TextField;
	private var hit:Sprite;
	
	public function TitleButton()
	{
		this.init();
	}
	
	private function init():void
	{
		this.useHandCursor = false;
		
		s1text = this.createText(0);
		s2text = this.createText(0x9BE9F7);
		s3text = this.createText(0x10A8C2);
		hit = Pen.createShape(5, 5);
		width = 30;
	}
	
	/**
	 * 设置文本
	 * @param	t
	 */
	public function setText(t:String):void
	{
		s1text.text = s2text.text = s3text.text = t;
		
		upState = s1text;
		overState = s2text;
		downState = s3text;
		hitTestState = hit;
		if (s1text.width > width) width = s1text.width + 10;
		alignText();
	}
	public function getText():String
	{
		return s1text.text;
	}
	
	
	override public function get width():Number { return hit.width; }
	
	override public function set width(value:Number):void 
	{
		hit.width = value;
		hit.height = 20;
		alignText();
	}
	
	public function alignText():void
	{
		var tx:Number = Math.floor((width - s1text.width ) / 2);
		s1text.x = tx;
		s2text.x = tx;
		s3text.x = tx;
	}
	
	
	private function createText(nColor:Number):TextField
	{
		var t:TextField = new TextField;
		var tf:TextFormat = t.getTextFormat();
		tf.color = nColor;
		t.defaultTextFormat = tf;
		t.autoSize = 'left';
		return t;
	}
	
	
}