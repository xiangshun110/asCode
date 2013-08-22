package com.jiqian.widget.date.model
{
	import com.jiqian.display.Pen;
	import com.jiqian.widget.date.events.DateChooseEvent;
	import com.jiqian.widget.date.skin.IButtonSkin;
	import com.jiqian.widget.date.TDateChooser;
	import com.jiqian.widget.date.view.MotionComponent;
	import com.jiqian.widget.date.view.TextAlign;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class DayChooseModel extends MotionComponent
	{
		//按钮的偏移
		private var offX:Number = 3;
		private var offY:Number = 3;
		//本组的日期
		private var _date:Date;
		
		//星期bar
		private var _daPanel:Sprite;
		//星期文本集合
		private var _daAry:Array;
		
		protected var _dayNames:Array;
		
		
		
		
		public function DayChooseModel() 
		{
			this.init();
		}
		
		
		
		
		private function init():void
		{
			//星期头
			_daAry = new Array;
			for (i = 0; i < 7; i++)
			{
				var dt:DayNameText = new DayNameText;
				_daAry.push(dt);
			}
			_daPanel = new Sprite;
			_daPanel.x = offX + 2;
			_daPanel.y = offY;
			this.addChild(_daPanel);
			this.setDayNames(TDateChooser.CN_DAY_NAMES);
			
			var oX:Number = Math.floor((getWidth() - offX * 2) / 7);
			var oY:Number = Math.floor((getHeight() - _daPanel.height) / 6);
			//日期按钮
			this.createButtons(6, 7);
			for (var i:Number = 0; i < 42; i++)
			{
				var nb:IButtonSkin = buttonAry[i] as IButtonSkin;
				nb.y = Math.floor(i / 7) * oY + _daPanel.height + offY;
				nb.x = (i % 7) * oX + offX + 2;
				nb.setWidth(oX - 1);
				nb.setHeight(oY - 1);
				nb.setAlign(TextAlign.RIGHT);
			}
			
		}
		
		
		
		
		/**
		 * 距焦日
		 * @param	v
		 */
		public function setFocusDay(day:Number):void
		{
			var now:Date = new Date;
			for each(var tb:IButtonSkin in buttonAry)
			{
				tb.setSelected(tb.getData().getMonth() == getMonth() && (tb.getData().getDate() == day));
			}
		}
		
		
		
		/**
		 * 设置时间
		 * @param	date
		 */
		public function setDate(date:Date):void
		{
			_date = date;
			this.updateShow();
			this.setFocusDay(date.getDate() || 1);
		}
		
		public function getDate():Date { return _date; }
		
		
		
		
		
		
		
		
		
		/**
		 * 设置日期名字
		 * @param	dnames
		 */
		public function setDayNames(dnames:Array):void
		{
			var oX:Number = Math.floor((getWidth() - offX * 2) / 7);
			
			_dayNames = dnames;
			
			for(var i:String in _daAry)
			{
				_daAry[i].setText(_dayNames[i]);
				_daAry[i].setWidth(oX);
				_daAry[i].x = Number(i) * oX;
				_daPanel.addChild(_daAry[i]);
			}
			
		}
		public function getDayNames():Array
		{
			return _dayNames;
		}
		
		
		
		
		public function getTDate():Date { return _date; }
		
		public function getFullYear():Number { return _date.getFullYear(); }
		
		public function getMonth():Number { return _date.getMonth(); }
		
		
		public function getDay():Number { return _date.getDay(); }
		
		
		
		
		override public function getCanL():Boolean 
		{
			return getMonth() > 0 || getFullYear() > 1900;
		}
		
		override public function getCanR():Boolean 
		{
			return getMonth() < 11 || getFullYear() < 2099;
		}
		
		
		
		
		/**
		 * 更新显示
		 */
		public function updateShow():void
		{
			var now:Date = new Date;
			var sDate:Date = new Date(_date.getFullYear(), _date.getMonth(), 0);
			var eDate:Date = new Date(_date.getFullYear(), _date.getMonth() + 1, 0);
			var total:Number = eDate.getDate() - sDate.getDate() + 1;
			var sWeek:Number = sDate.getDay(); //起始的星期
			var eWeek:Number = eDate.getDay(); //最后的星期
			
			for (var i:Number = 0; i < 42; i++)
			{
				var nb:IButtonSkin = buttonAry[i] as IButtonSkin;
				var nd:Date = new Date(sDate);
				
				nd.setDate(sDate.getDate() - sWeek + i);
				nb.setData(nd);
				nb.setText(nd.getDate().toString());
				//今天
				if ((getFullYear() == now.getFullYear()) && (nb.getData().getMonth() == now.getMonth()))
				{
					nb.setIsToday(nb.getData().getDate() == now.getDate());
				}else {
					nb.setIsToday(false);
				}
				nb.setAshColor(nd.getMonth() != getMonth());
			}
			
		}
		
		
		
		/**
		 * 选择了一天
		 * @param	e
		 */
		override protected function onChoose(e:MouseEvent):void
		{
			var nb:IButtonSkin = e.target as IButtonSkin;
			this.dispatchEvent(new DateChooseEvent(DateChooseEvent.CHOOSE_DAY, nb.getData() as Date));
		}
		
		
		
		
		/**
		 * 左右切换时，距焦到1号
		 * @param	direction
		 */
		override public function moveLR(direction:Number):void 
		{
			super.moveLR(direction);
			this.setFocusDay(1);
		}
		
		
		
		
	}
	
}




import flash.display.Sprite;
import flash.text.TextField;



class DayNameText extends Sprite
{
	
	
	private var _mainText:TextField;
	
	public function DayNameText():void {
		
		this.mouseChildren = this.mouseEnabled = false;
		
		_mainText = new TextField;
		_mainText.autoSize = 'left';
		_mainText.height = 0;
		
		addChild(_mainText);
		setWidth(20);
	}
	
	
	
	/**
	 * 设获文本
	 * @param	t
	 */
	public function setText(t:String):void
	{
		_mainText.text = t;
		
	}
	public function getText():String { return _mainText.text; }
	
	
	
	private var _width:uint;
	/**
	 * 设获宽
	 * @param	v
	 */
	public function setWidth(v:uint):void
	{
		_width = v;
		_mainText.x = Math.floor((v - _mainText.width) / 2);
	}
	public function getWidth():uint
	{
		return _width;
	}
	
	
	
}