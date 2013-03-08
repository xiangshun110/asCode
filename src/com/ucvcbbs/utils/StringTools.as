package com.ucvcbbs.utils 
{
	/**
	 * ...
	 * @author xiangshun
	 */
	public class StringTools 
	{
		
		public function StringTools() 
		{
			
		}
		
		/**
		 * 去掉空格，去掉换行
		 * @param	str
		 * @return
		 */
		public static function trim(str:String):String {
			if (str == null) return null;
			var reg:RegExp = /\r\n/g;
			var temp:String = str.replace(reg, "");
			return temp.replace(/\s/g,"");
		}
		
		/**
		 * 裁剪掉字符串开头和结尾的空格 
		 * @param string 需要被裁剪的字符串
		 * @return 返回裁剪后的字符串
		 * 
		 */
		public static function trimHeadEnd(string:String):String {
			var reg:RegExp=/^\s*|\s*$/g;
			var str:String=string.replace(reg,"");
			return str;
		}
		
		/**
		 * 去除换行
		 * @param	str
		 * @return
		 */
		public static function removeLineBreak(str:String):String {
			if (str == null) return null;
			var reg:RegExp = /\r\n/g;
			var temp:String = str.replace(reg, "");
			return temp;
		}
		
		/**
		 * 检测Email地址字符串是否正确 
		 * @param EmailStr 被检测的Email地址字符串
		 * @return 返回检测的结果,true表示正确
		 * 
		 */
		public static function checkEmail(EmailStr:String):Boolean {
			var checker:RegExp=/^[a-z0-9][-_\.a-z0-9]*\@([a-z0-9][-_a-z0-9]*\.)+[a-z]{2,6}$/;
			return checker.test(EmailStr);
		}
		
		/**
		 * 搜索数组中每个项目是否含有关键字，并返回索引，以数组形式返回这些索引
		 * @param	str
		 * @param	ary
		 * @return
		 */
		public static function searchArray(str:String, ary:Array):Array {
			var len:int = ary.length;
			var temp:Array = [];
			var index:int;
			for (var i:int = 0; i < len; i++) {
				index = ary[i].indexOf(str);
				if(index!=-1){
					temp.push(i);
				}
			}
			return temp;
		}
		
		/**
		 * 用于货币数值显示,例如10000，变成:"10,000"
		 * @param	num
		 * @return
		 */
		public static function moneyNumberToString(num:int):String {
			var str:String = String(num);
			var ary:Array = str.split("");
			str = "";
			var ary2:Array = [];
			ary = ary.reverse();
			
			for (var i = 0; i < ary.length; i++ ) {
				if (i != 0 && (i % 3) == 0) {
					ary2.push(",");
				}
				ary2.push(ary[i]);
			}
			
			ary2 = ary2.reverse();
			str = ary2.join("");
			//trace("str: " + str);
			return str;
		}
		
		/**
		 * 替换所有需要替换的字符串
		 * @param	strSource 需要查找替换的字符串
		 * @param	strReplaceFrom 查找的字符串
		 * @param	strRepalceTo 替换成某字符串
		 * @return
		 */
		public static function replaceAllByRegex(strSource:String, strReplaceFrom:String, strRepalceTo:String):String {
			return strSource == null ? null : strSource.replace(new RegExp(strReplaceFrom, 'g'), strRepalceTo);
		}
		
	}

}