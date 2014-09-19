package com.ucvcbbs.utils 
{
	import flash.utils.ByteArray;
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
			
			for (var i:int = 0; i < ary.length; i++ ) {
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
		
		
		/**
		 * 获取一串中文的拼音字母,例如:你好--nh
		 * @param        chinese        <string>Unicode格式的中文字符串
		 * @return                        <string>拼音声母字符串
		 * @example 
		 * var chinese:String = "中华人民共和国";
		 * var py:String = Convert.convertString(chinese);
		 * trace(py);        //zhrmghg
		 */
		public static function convertString(chinese:String):String 
		{
				var len:int = chinese.length;
				var ret:String = "";
				for (var i:int = 0; i < len; i++) 
				{
						ret += convertChar(chinese.charAt(i));
				}
				return ret;
		}
		
		/**
		 * 获取单个字符的首字母
		 * @param        char        <String>Unicode格式的一个中文字符
		 * @return                        <String>中文字符的声母
		 * @example
		 * var chineseChar:String = "我";
		 * var py:String = Convert.convertChar(chineseChar);
		 * trace(py);        //w
		 */
		public static function convertChar(chineseChar:String):String 
		{
				var bytes:ByteArray = new ByteArray();
				bytes.writeMultiByte(chineseChar.charAt(0), "cn-gb");
				var n:int = bytes[0] << 8;
				n += bytes[1];
				if (isIn(0xB0A1, 0xB0C4, n)) return "a";
				if (isIn(0XB0C5, 0XB2C0, n)) return "b";
				if (isIn(0xB2C1, 0xB4ED, n)) return "c";
				if (isIn(0xB4EE, 0xB6E9, n)) return "d";
				if (isIn(0xB6EA, 0xB7A1, n)) return "e";
				if (isIn(0xB7A2, 0xB8c0, n)) return "f";
				if (isIn(0xB8C1, 0xB9FD, n)) return "g";
				if (isIn(0xB9FE, 0xBBF6, n)) return "h";
				if (isIn(0xBBF7, 0xBFA5, n)) return "j";
				if (isIn(0xBFA6, 0xC0AB, n)) return "k";
				if (isIn(0xC0AC, 0xC2E7, n)) return "l";
				if (isIn(0xC2E8, 0xC4C2, n)) return "m";
				if (isIn(0xC4C3, 0xC5B5, n)) return "n";
				if (isIn(0xC5B6, 0xC5BD, n)) return "o";
				if (isIn(0xC5BE, 0xC6D9, n)) return "p";
				if (isIn(0xC6DA, 0xC8BA, n)) return "q";
				if (isIn(0xC8BB, 0xC8F5, n)) return "r";
				if (isIn(0xC8F6, 0xCBF0, n)) return "s";
				if (isIn(0xCBFA, 0xCDD9, n)) return "t";
				if (isIn(0xCDDA, 0xCEF3, n)) return "w";
				if (isIn(0xCEF4, 0xD188, n)) return "x";
				if (isIn(0xD1B9, 0xD4D0, n)) return "y";
				if (isIn(0xD4D1, 0xD7F9, n)) return "z";
				return "\0";
		}
		
		private static function isIn(from:int, to:int, value:int):Boolean
		{  
				return ((value >= from) && (value <= to));
		}
		
		/**
		 * 判断单个字符是否是汉字
		 * @param        chineseChar        <String>Unicode格式的一个中文字符
		 * @return                                <Boolean>是中文返回true,不是返回flase
		 */
		public static function isChinese(chineseChar:String):Boolean 
		{
				if (convertChar(chineseChar) == "\0")
				{
						return false;
				}
				return true;
		}
		
		/** 
	     * 排序，支持中英混排 
	     * @param arr 列表数组 
	     * @param key 键名(键值数组时使用) 
	     * @return 
	     * 
	     */   
	    public static function sort(arr:Array, key:String = ""):Array 
	    { 
			var byte:ByteArray = new ByteArray(); 
			var sortedArr:Array = []; 
			var returnArr:Array = []; 
			var item:*; 
			for each (item in arr) 
			{
				var word:String;
				 if (key == "") 
				 { 
					word = String(item).charAt(0);
				 } 
				 else 
				 {
					word = String(item[key]).charAt(0);
				 }
				 
				 if(isChinese(word)){
					byte.writeMultiByte(word, "gb2312");
				}else {
					byte.writeMultiByte(word, "gb2312");
					byte.writeMultiByte(word, "gb2312");
				}
			} 
			byte.position = 0; 
			//trace("len:" + byte.length);
			var len:int = byte.length / 2; 
			
			for (var i:int = 0; i < len; i++) 
			{
				//trace(byte[i * 2], byte[i * 2 + 1]);
				sortedArr[sortedArr.length] = {a: byte[i * 2], b: byte[i * 2 + 1], c: arr[i]}; 
			}
			
			//sortedArr.sortOn(["a", "b"], [Array.DESCENDING | Array.NUMERIC]);
			sortedArr.sortOn(["a", "b"],  Array.NUMERIC);
			
			for each (var obj:Object in sortedArr) 
			{ 
				returnArr[returnArr.length] = obj.c; 
			} 
			return returnArr; 
		} 
		
	}

}