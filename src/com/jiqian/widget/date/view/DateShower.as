package com.jiqian.widget.date.view 
{
	import com.jiqian.widget.date.events.DateChooseEvent;
	import com.jiqian.widget.date.events.ModelChangeEvent;
	import com.jiqian.widget.date.model.MonthChooseModel;
	import com.jiqian.widget.date.model.DayChooseModel;
	import com.jiqian.widget.date.model.YearChooseModel;
	import com.jiqian.widget.date.model.YearGroupModel;
	import com.jiqian.widget.date.TDateChooser;
	import flash.display.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tangzx <xu love qq>
	 */
	public class DateShower extends Sprite
	{
		public static const SHOW_DAY_CHOOSER:String 		= 'showDay';
		public static const SHOW_MONTH_CHOOSER:String 		= 'showMonth';
		public static const SHOW_YEAR_CHOOSER:String 		= 'showYear';
		public static const SHOW_YEAR_GROUP_CHOOSER:String 	= 'showYearGroup';
		
		//三个
		public var dayChooser:DayChooseModel;
		public var monthChooser:MonthChooseModel;
		public var yearChooser:YearChooseModel;
		public var yearGroupChooser:YearGroupModel;
		//map
		private var refObj:Object;
		//当前正在显示
		private var currentModelName:String;
		
		public function DateShower() 
		{
			this.init();
		}
		
		
		
		private function init():void
		{
			dayChooser = new DayChooseModel;
			dayChooser.addEventListener(DateChooseEvent.CHOOSE_DAY, onDayChoose);
			
			monthChooser = new MonthChooseModel;
			monthChooser.setVisible(false);
			monthChooser.addEventListener(DateChooseEvent.CHOOSE_MONTH, 	onMonthChoose);
			
			yearChooser = new YearChooseModel;
			yearChooser.setVisible(false);
			yearChooser.addEventListener(DateChooseEvent.CHOOSE_YEAR, 		onYearChoose);
			
			yearGroupChooser = new YearGroupModel;
			yearGroupChooser.setVisible(false);
			yearGroupChooser.addEventListener(DateChooseEvent.CHOOSE_YEAR, 	onYearGroupChoose);
			
			addChild(yearGroupChooser);
			addChild(yearChooser);
			addChild(monthChooser);
			addChild(dayChooser);
			
			dayChooser.setDate(new Date);
			
			currentModelName = SHOW_DAY_CHOOSER;
			refObj = { 'showDay':[dayChooser, 0], 'showMonth':[monthChooser, 1], 'showYear':[yearChooser, 2], 'showYearGroup':[yearGroupChooser, 3] };
		}
		
		
		
		////日期选择
		private function onDayChoose(e:DateChooseEvent):void
		{
			this.setDate(e.date, true);
			this.dispatchEvent(e);
		}
		////月份选择
		private function onMonthChoose(e:DateChooseEvent):void
		{
			this.setDate(e.date);
			this.dispatchEvent(e);
		}
		////年份选择
		private function onYearChoose(e:DateChooseEvent):void
		{
			monthChooser.setFocusMonth(e.date.getMonth());
			monthChooser.setFullYear(e.date.getFullYear());
			this.setModelShow(SHOW_MONTH_CHOOSER, yearChooser.getPointByYear(e.date.getFullYear()));
			this.dispatchEvent(e);
		}
		////年团选择
		protected function onYearGroupChoose(e:DateChooseEvent):void
		{
			this.setModelShow(SHOW_YEAR_CHOOSER, yearGroupChooser.getPointByYear(e.date.getFullYear()), e.date.getFullYear());
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		
		
		
		/**
		 * 显示相应的模块
		 * @param	modelType
		 */
		public function setModelShow(modelType:String, pos:Point = null, data:Object = null):void
		{
			var showData:Array = refObj[modelType] as Array;
			var currData:Array = refObj[currentModelName] as Array;
			var showModel:MotionComponent = showData[0] as MotionComponent;
			var currModel:MotionComponent = currData[0] as MotionComponent;
			var zoomType:Number = showData[1] < currData[1] ? MotionComponent.ZOOM_OUT : MotionComponent.ZOOM_IN;
			
			if (showModel != currModel)
			{
				if (showModel == dayChooser)
				{
					pos = pos || monthChooser.getPointByMonth(dayChooser.getMonth());
				}else if (showModel == monthChooser)
				{
					monthChooser.setFullYear(currModel == dayChooser ? dayChooser.getFullYear() : yearChooser.getFullYear());
				}else if (showModel == yearChooser)
				{
					yearChooser.setFocusYear(Number(data) || monthChooser.getFullYear());
				}else if (showModel == yearGroupChooser)
				{
					yearGroupChooser.setFocusYear(Number(data) || yearChooser.getStartYear());
				}
				
				currModel.motionOut(zoomType, pos);
				showModel.motionIn(zoomType, pos);
				currentModelName = modelType;
			}
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		
		public function getModelShow():String
		{
			return currentModelName;
		}
		
		
		
		
		/**
		 * 显示Model的层级升
		 */
		public function showLevelUp():void
		{
			switch(currentModelName)
			{
				case SHOW_DAY_CHOOSER:
					monthChooser.setFocusMonth(dayChooser.getMonth());
					this.setModelShow(SHOW_MONTH_CHOOSER, monthChooser.getPointByMonth(dayChooser.getMonth()));
				break;
				case SHOW_MONTH_CHOOSER:
					var year:Number = monthChooser.getFullYear() || dayChooser.getFullYear();
					yearChooser.setFocusYear(year);
					this.setModelShow(SHOW_YEAR_CHOOSER, yearChooser.getPointByYear(year));
				break;
				case SHOW_YEAR_CHOOSER:
					yearGroupChooser.setFocusYear(yearChooser.getStartYear());
					this.setModelShow(SHOW_YEAR_GROUP_CHOOSER, yearGroupChooser.getPointByYear(yearChooser.getStartYear()));
				break;
			}
		}
		
		
		
		
		
		
		/**
		 * 取标题
		 * @return
		 */
		public function getTitleString():String
		{
			switch(currentModelName)
			{
				case SHOW_DAY_CHOOSER:
				return this.getDateStr();
				break;
				case SHOW_MONTH_CHOOSER:
				return monthChooser.getFullYear().toString();
				break;
				case SHOW_YEAR_CHOOSER:
				return yearChooser.getStartYear() + " - " + yearChooser.getEndYear();
				break;
				case SHOW_YEAR_GROUP_CHOOSER:
				return yearGroupChooser.getStartYear() + " - " + yearGroupChooser.getEndYear();;
				break;
			}
			return null;
		}
		
		
		
		
		private var dateFormatStr:String = TDateChooser.DEFAULT_DATE_FORMAT;
		
		private var dateFormater:Function = TDateChooser.defaultDateFormater;
		
		public function setDateFormater(formater:Function):void
		{
			dateFormater = formater;
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		/**
		 * 显示格式
		 * YYYY年MM月
		 * YYYY-MM
		 * YY/MM
		 * ...
		 * @param	format
		 */
		public function setTitleFormat(format:String):void
		{
			format = format.toUpperCase();
			if (format.indexOf('YYYY') == -1 ||
				format.indexOf('MM') == -1)
			{
				format = TDateChooser.DEFAULT_DATE_FORMAT;
			}
			dateFormatStr = format;
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		public function getTitleFormat():String
		{
			return dateFormatStr;
		}
		
		
		
		private function getDateStr():String
		{
			return dateFormater(dayChooser.getDate()) as String;
			var year:String 	= String(dayChooser.getFullYear());
			var month:String	= String(dayChooser.getMonth() + 1);
			month = String('0' + month).substr(month.length - 1, 2);
			var finalStr:String = dateFormatStr.split('YYYY').join(year).split('MM').join(month);
			return finalStr;
		}
		
		
		
		
		
		/**
		 * 设置日期
		 * @param	date	日期
		 * @param	motion	用动画效果
		 */
		public function setDate(date:Date, motion:Boolean = false):void
		{
			if (date.getFullYear() == dayChooser.getFullYear() &&
				date.getMonth() == dayChooser.getMonth() &&
				currentModelName == SHOW_DAY_CHOOSER)
			{//就是本月，无须过渡
				dayChooser.setFocusDay(date.getDate());
				this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
				return;
			}
			
			
			if (motion && currentModelName == SHOW_DAY_CHOOSER)
			{//利用动画效果
				var direction:Number = dayChooser.getDate().getTime() < date.getTime() ? MotionComponent.LEFT : MotionComponent.RIGHT;
				dayChooser.moveLR(direction);
			}
			
			//设置
			dayChooser.setDate(date);
			dayChooser.setFocusDay(date.getDate() || 1);
			if (currentModelName != SHOW_DAY_CHOOSER) setModelShow(SHOW_DAY_CHOOSER);
			
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		
		public function getDate():Date
		{
			return dayChooser.getDate();
		}
		
		
		
		
		
		/**
		 * 能向左移？
		 * @return boolean
		 */
		public function getCanL():Boolean
		{
			return getCurrentModel().getCanL();
		}
		
		
		
		/**
		 * 能向右移？
		 * @return boolean
		 */
		public function getCanR():Boolean
		{
			return getCurrentModel().getCanR();
		}
		
		
		
		
		public function getCurrentModel():MotionComponent
		{
			return refObj[currentModelName][0];
		}
		
		
		
		
		/**
		 * 去上一页
		 */
		public function goPrev():void
		{
			switch(currentModelName)
			{
				case SHOW_DAY_CHOOSER:
				var date:Date = dayChooser.getDate(); 
				date.setMonth(date.getMonth() + 1);
				date.setDate(1);
				dayChooser.moveLR( -1);
				dayChooser.setDate(date);
				break;
				default:
				var model:MotionComponent = refObj[currentModelName][0] as MotionComponent;
				model.moveLR( -1);
				break;
			}
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		
		
		
		/**
		 * 翻下一页
		 */
		public function goNext():void
		{
			switch(currentModelName)
			{
				case SHOW_DAY_CHOOSER:
					var date:Date = dayChooser.getDate(); 
					date.setMonth(date.getMonth() - 1);
					date.setDate(1);
					dayChooser.moveLR(1);
					dayChooser.setDate(date);
				break;
				default:
					var model:MotionComponent = refObj[currentModelName][0] as MotionComponent;
					model.moveLR(1);
				break;
			}
			this.dispatchEvent(new ModelChangeEvent(ModelChangeEvent.CHANGE));
		}
		
		
		
		
		public function getDayChooseModel():DayChooseModel
		{
			return dayChooser;
		}
		public function getMonthChooseModel():MonthChooseModel
		{
			return monthChooser;
		}
		
		
	}
	
}