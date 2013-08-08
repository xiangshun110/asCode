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
		
		
		
		/**
		 * 模糊查询
		 * @param	info 要查的字符串 
		 * @param	source 数据源
		 * @return
		 */
		public static function fuzzySearch(info:String, source:Vector.<String>):Vector.<String> {
			return getSearchResult(info,source);
		}
		/** 搜索并返回结果数组 */
		private static function getSearchResult(info:String,source:Vector.<String>):Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			if (info == "") return list;
			
			var isSame:Boolean = false;
			var mInfo:String = "";
			var sInfo:String = null;
			var amount:int = source.length;
			
			for (var i:int = 0; i < amount; i++) 
			{
				mInfo = source[i];
				if (mInfo == info)
				{
					//完全相同
					list.push(info);
				}
				else
				{
					//不相等，找相近
					if (hasRelation(mInfo, info))
					{
						sInfo = getRelationData(mInfo, info);
						if (sInfo != "") list.push(sInfo);
					}
				}
			}
			
			list.sort(sortByLength);
			
			return list;
		}
		/** 按长度排列顺序 */
		private static function sortByLength(data1:String, data2:String):int
		{
			if (data1.length < data2.length)
			{
				return -1
			}
			else if (data1.length > data2.length)
			{
				return 1;
			}
			else 
			{
				return 0;
			}
        }
		/** 两个字符串是否有相同字符 */
		private static function hasRelation(resInfo:String, searchInfo:String):Boolean
		{
			if (resInfo.indexOf(searchInfo) >= 0) return true;
			var len0:int = resInfo.length;
			var info0:String;
			
			var len1:int = searchInfo.length;
			var j:int = 0;
			
			for (var i:int = 0; i < len0; i++) 
			{
				info0 = resInfo.charAt(i);
				for (j = 0; j < len1; j++) 
				{
					if (info0 == searchInfo.charAt(j)) return true;
				}
			}
			
			return false;
		}
		/** 得到两个字符串匹配结果的类型数据 */
		private static function getRelationData(resInfo:String, searchInfo:String):String
		{
			//被包含
			var index:int = resInfo.indexOf(searchInfo);
			if (index >= 0) return resInfo;
			
			//不包含
			var len0:int = resInfo.length;
			var info0:String;
			
			var len1:int = searchInfo.length;
			var j:int = 0;
			
			var sameAmount:int = 0;
			
			for (var i:int = 0; i < len0; i++) 
			{
				info0 = resInfo.charAt(i);
				
				for (j = 0; j < len1; j++) 
				{
					if (info0 == searchInfo.charAt(j)) 
					{
						sameAmount++;
						break;
					}
				}
			}
			
			if (sameAmount >= len1) 
			{
				return resInfo;
			}
			
			return "";
		}
		
	}

}