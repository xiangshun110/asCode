package  com.ucvcbbs.utils
{
	/**
	 * 时间工具
	 * ...
	 * @author xiangshun
	 */
	public class DateTools 
	{
		
		public function DateTools() 
		{
			
		}
		
		/**
		 * 按照通用时间返回 Date 对象中自 1970 年 1 月 1 日午夜以来的毫秒数。
		 * @return
		 */
		static public function getTimer():Number {
			var d:Date = new Date();
			return d.getTime();
		}
		
		/**
		 * 翼字符串返回年月日时分秒
		 * @return
		 */
		static public function getCurTime():String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "/" + (d.getMonth() + 1) + "/" + d.getDate();
			str += "--" + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
			return str;
		}
		
		/**
		 * 字符串返回年月日时分秒全部用“-”间隔
		 * @return
		 */
		static public function getCurTime2():String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
			str += "-" + d.getHours() + "-" + d.getMinutes() + "-" + d.getSeconds();
			return str;
		}
		
	}

}