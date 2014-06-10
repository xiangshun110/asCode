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
		 * @param	isMilli 是否要毫秒
		 * @return
		 */
		static public function getCurTime2(isMilli:Boolean=false):String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
			if(!isMilli){
				str += "-" + d.getHours() + "-" + d.getMinutes() + "-" + d.getSeconds();
			}else {
				str += "-" + d.getHours() + "-" + d.getMinutes() + "-" + d.getSeconds()+ "-" + d.getMilliseconds();
			}
			return str;
		}
		
		
		/**
		 * 字符串返回年月日时分秒 例如:2013-10-10 17:22:30
		 * @param	isMilli 是否要毫秒
		 * @return
		 */
		static public function getCurTime3(isMilli:Boolean=false):String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
			if(!isMilli){
				str += " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
			}else {
				str += " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()+ "." + d.getMilliseconds();
			}
			return str;
		}
		
		//
		/**
		 * 字符串返回年月日时分秒 例如:2000-03-12T11:33:27+00:00
		 * @param	isMilli 是否要毫秒
		 * @return
		 */
		static public function getCurTime4():String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate()+"T";
			
			str += " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()+"+00:00";
			
			return str;
		}
		
		
		/**
		 * 返回年月日
		 * @param	sp间隔符号
		 * @return
		 */
		static public function getCurTime5(sp:String="-"):String {
			var d:Date = new Date();
			var str:String;
			str = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
			
			return str;
		}
		
	}

}