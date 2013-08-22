package com.ucvcbbs.data
{
	import com.ucvcbbs.utils.AppTools;
	import com.ucvcbbs.utils.StringTools;
	import com.ucvcbbs.utils.SystemName;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.errors.SQLError;
	/**
	 * ...一个SQLLite只能用于一个数据库
	 * 星号等特殊符号需要加个单引号
	 * @author xiangshun
	 */
	public class SQLLite extends EventDispatcher
	{
		private var conn:SQLConnection;
		private var statement:SQLStatement=new SQLStatement();
		private var dbFile:File;//数据库文件
		private var tbName:String;//表名字
		private var dbName:String;//数据库名字
		private var attrObj:Object;//字段对象
		private var _dbPathAndName:String;//数据库的路径跟名字，以程序的安装目录为跟目录
		public function SQLLite(dbPathAndName:String) 
		{
			_dbPathAndName = dbPathAndName;
			creatDB(_dbPathAndName);
		}
		
		/**
		 * 创建一个数据库,路径前不要带斜杠“/”,例如:"db/mydb.db"
		 * @param	dbPath 数据库名称及路径，
		 */
		private function creatDB(dbPath:String):void {
			var str:String;
			switch(AppTools.getSystemName()) {
				case SystemName.WINDOWS:
					str = AppTools.getAppPath()+"/"+dbPath;
					break;
				case SystemName.MAC:
					str = AppTools.getAppPath()+"/"+dbPath;
					break;
				case SystemName.IOS://--/Library
					str = AppTools.getAppPath();
					str = AppTools.getParentURL(str);
					str += ("/Library/" + dbPath);
					break;
				case SystemName.LINUX:
					str = AppTools.getStoragePath() +"/"+dbPath;
					break;
			}
			/*var str:String = File.applicationDirectory.nativePath;
			str += ("/" + dbPath);*/
			trace(str);
			dbFile = new File();
			dbFile = dbFile.resolvePath(str);
			dbFile.parent.createDirectory();
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, createDBHandler);
			conn.addEventListener(SQLErrorEvent.ERROR,creatDBErrorHandler);
			conn.open(dbFile);
		}
		private function createDBHandler(evt:SQLEvent):void {
			trace("数据库已经创建");
			conn.removeEventListener(SQLEvent.OPEN,createDBHandler);
			conn.removeEventListener(SQLErrorEvent.ERROR,creatDBErrorHandler);
			conn.close();
			statement.sqlConnection=conn;
		}
		private function creatDBErrorHandler(evt:SQLErrorEvent):void{
			trace(evt.error.message);
			conn.removeEventListener(SQLEvent.OPEN, createDBHandler);
			conn.removeEventListener(SQLErrorEvent.ERROR,creatDBErrorHandler);
			conn.close();
			throw new Error("创建数据库出错，请检查路径名字是否正确");
		}
		
		
		
		/**
		 * 创建一个数据表
		 * @param	tableName 表名称
		 * @param	attObj 字段与字段类型对象，例如{name:*,age:*}
		 */
		public function creatTable(tableName:String,attObj:Object):void {
			//创建数据库表;
			var sql:String = "create table if not exists " + tableName + " ( ";
			sql += "id integer primary key autoincrement, ";//序号，自动生成
			for (var att:String in attObj) {
				sql += (att + " " + attObj[att] + ", ");
			}
			sql = sql.substring(0, sql.length - 2);
			sql += ")";
			excuteSQL(sql);
		}
		
		
		/**
		 * 在某个表中插入数据
		 * @param	tbnameStr 表名字
		 * @param	dataObj 数据对象
		 */
		public function insert(tbnameStr:String,dataObj:Object):void {	
			var sql:String;
			var sqlStr:String = "INSERT INTO "+tbnameStr+" (";
			var sqlStr2:String = "VALUES(";
			for (var obj:String in dataObj) {
				sqlStr += (obj + ",");
				dataObj[obj] = StringTools.replaceAllByRegex(dataObj[obj], "'", "‘");
				sqlStr2 += ("'"+dataObj[obj] + "',");
			}
			sqlStr=sqlStr.substring(0, sqlStr.length - 1);
			sqlStr2 = sqlStr2.substring(0, sqlStr2.length - 1);
			sqlStr = sqlStr + ")";
			sqlStr2 = sqlStr2 + ")";
			sql = sqlStr + " " + sqlStr2;
			excuteSQL(sql);
		}
		
		
		/**
		 * 更新数据
		 * @param	tbnameStr 表名
		 * @param	dataObj  数据对象，例如{name:"xs",age:18}
		 * @param	ofDateObj 根据什么来更新，也就是where后面的，例如{school:"cj"},多条件:{school:"cj",class:315}
		 */
		public function update(tbnameStr:String, dataObj:Object, ofDateObj:Object):void {
			var sql:String;
			var s1:String = "UPDATE "+tbnameStr+" SET ";
			var s2:String = "WHERE ";
			for (var obj:String in dataObj) {
				dataObj[obj] = StringTools.replaceAllByRegex(dataObj[obj], "'", "‘");
				s1 += obj + "='"+dataObj[obj] + "',";
			}
			s1 = s1.substring(0, s1.length - 1);
			
			for (obj in ofDateObj) {
				s2 += (obj + "='" + ofDateObj[obj] + "' AND ");
			}
			s2 = s2.substr(0, s2.length - 5);
			sql = s1 +" " + s2;
			excuteSQL(sql);
		}
		
		/**
		 * 删除表中一行数据
		 * @param	tbnameStr 表名字
		 * @param	ofDateObj 条件对象，也就是where后面的，例如{school:"cj"},多条件:{school:"cj",class:315}
		 */
		public function deleteData(tbnameStr:String, ofDateObj:Object):void {
			var sql:String;
			var s1:String = "DELETE FROM "+tbnameStr+" ";
			var s2:String = "WHERE ";
			for (var obj:String in ofDateObj) {
				s2 += (obj + "='" + ofDateObj[obj] + "' AND ");
			}
			s2 = s2.substr(0, s2.length - 5);
			sql = s1 +" " + s2;
			excuteSQL(sql);
		}
		
		/**
		 * 删除表中所有的数据
		 * @param	tbnameStr
		 */
		public function deleteAllData(tbnameStr:String):void {
			//DELETE FROM table_name
			var sql:String = "DELETE FROM " + tbnameStr;
			excuteSQL(sql);
		}
		
		/**
		 * 查询
		 * SQL 使用单引号来环绕文本值（大部分数据库系统也接受双引号）。如果是数值，请不要使用引号
		 */
		/**
		 * 查询，如果有条件，使用or链接
		 * @param	tbnameStr  表名
		 * @param	wordAry  要查询的字段数组，默认为将为*
		 * @param	ofDateObj  条件对象，默认为null，表示查询整个表
		 * @param	oa  条件链接是用OR还是AND，默认是OR
		 * @return  返回一个数组，以object为元素，每个object装一行的信息
		 */
		public function selectData(tbnameStr:String, wordAry:Array=null,ofDateObj:Object = null,oa:String="OR"):Array {
			if (!wordAry) {
				wordAry = new Array("*");
			}
			var sql:String;
			var s1:String = "SELECT ";
			if (wordAry[0] == "*"||wordAry[0] == null) {
				s1 += "* FROM "+tbnameStr;
			}else {
				for each(var obj1:String in wordAry) {
					s1 += obj1 + ",";
				}
				s1=s1.substr(0,s1.length-1);
				s1 += " FROM "+tbnameStr;
			}
			if (ofDateObj) {
				var s2:String = " WHERE ";
				for (var obj2:String in ofDateObj) {
					if (ofDateObj[obj2] is Number) {
						s2 += obj2 + "=" + ofDateObj[obj2]+" "+oa+" ";
					}else {
						s2 += obj2 + "='" + ofDateObj[obj2]+"' "+oa+" ";
					}
				}
				s2 = s2.substr(0, (s2.length - (oa.length+1)));
				sql = s1 + s2;
			}else {
				sql = s1;
			}
			excuteSQL(sql);
			//trace("statement.getResult().data:"+statement.getResult().data);
			return (statement.getResult().data as Array);
		}
		
		/**
		 * 用where in查询
		 * @param	tbnameStr 表名
		 * @param	wordAry	要查询的字段数组，默认为将为*
		 * @param	ofDateObj	条件对象{aa:"1,3,5"}
		 * @return
		 */
		public function selectData_IN(tbnameStr:String, wordAry:Array=null,ofDateObj:Object = null):Array {
			if (!wordAry) {
				wordAry = new Array("*");
			}
			var sql:String;
			var s1:String = "SELECT ";
			if (wordAry[0] == "*"||wordAry[0] == null) {
				s1 += "* FROM "+tbnameStr;
			}else {
				for each(var obj1:String in wordAry) {
					s1 += obj1 + ",";
				}
				s1=s1.substr(0,s1.length-1);
				s1 += " FROM "+tbnameStr;
			}
			if (ofDateObj) {
				var s2:String = " WHERE ";
				for (var obj2:String in ofDateObj) {
					s2 += (obj2 + " IN (");
					s2 += (ofDateObj[obj2] + ")");
					break;
					/*if (ofDateObj[obj2] is Number) {
						s2 += obj2 + "=" + ofDateObj[obj2]+" "+oa;
					}else {
						s2 += obj2 + "='" + ofDateObj[obj2]+"' "+oa;
					}*/
				}
				//s2 = s2.substr(0, (s2.length - (oa.length+1)));
				sql = s1 + s2;
			}else {
				sql = s1;
			}
			excuteSQL(sql);
			//trace("statement.getResult().data:"+statement.getResult().data);
			return (statement.getResult().data as Array);
		}
		
		/**
		 * 去重复查询，如果有条件，使用or链接
		 * @param	tbnameStr  表名
		 * @param	keyword  要查询的字段
		 * @return  返回一个数组，以object为元素，每个object装一行的信息
		 */
		public function distinctSelectData(tbnameStr:String, keyword:String):Array {
			var s1:String = "SELECT DISTINCT ";
			s1 += keyword + " FROM " + tbnameStr;
			excuteSQL(s1);
			//trace("statement.getResult().data:"+statement.getResult().data);
			return (statement.getResult().data as Array);
		}
		
		
		/**
		 * 增加，修改，删除列
		 * 增加: ALTER TABLE table_name ADD column_name datatype
		 * 删除列: ALTER TABLE table_name DROP COLUMN column_name//不支持
		 * 修改: ALTER TABLE table_name ALTER COLUMN column_name datatype
		 */
		
		
		/**
		 *给数据表增加列(字段),一次只能添加一个字段 
		 * @param	tbnameStr 表名
		 * @param	dataObj  字段名跟字段类型对象 例{test:"TEXT"}
		 */
		public function addColumn(tbnameStr:String, dataObj:Object):Array {
			var s1:String="";
			for (var obj:String in  dataObj) {
				s1 += (obj + " " + dataObj[obj]);
			}
			var sql:String =" ALTER TABLE " + tbnameStr + " ADD ";
			sql += s1;
			excuteSQL(sql);
			return (statement.getResult().data as Array);
		}
		
		/**
		 * 查询（前asc/后desc）N条数据，
		 * @param	tbnameStr  表名
		 * @param	count 数量
		 * @param	key 根据什么排序
		 * @param	wordAry 要查询的字段数组
		 * @param	oa  条件链接是用OR还是AND，默认是OR
		 * @param	order  升序ASC还是降序DESC
		 * @return
		 */
		public function selectTopData(tbnameStr:String, count:int = 20,key:String="id", wordAry:Array = null,oa:String="OR", ofDateObj:Object = null, order:String = "DESC"):Array {
			if (!wordAry) {
				wordAry = new Array("*");
			}
			var sql:String;
			var s1:String = "SELECT ";
			if (wordAry[0] == "*"||wordAry[0] == null) {
				s1 += "* FROM "+tbnameStr;
			}else {
				for each(var obj1:String in wordAry) {
					s1 += obj1 + ",";
				}
				s1=s1.substr(0,s1.length-1);
				s1 += " FROM "+tbnameStr;
			}
			if (ofDateObj) {
				var s2:String = " WHERE ";
				for (var obj2:String in ofDateObj) {
					if (ofDateObj[obj2] is Number) {
						s2 += obj2 + "=" + ofDateObj[obj2]+" "+oa+" ";
					}else {
						s2 += obj2 + "='" + ofDateObj[obj2]+"' "+oa+" ";
					}
				}
				s2 = s2.substr(0, (s2.length - (oa.length+1)));
				sql = s1 + s2;
			}else {
				sql = s1;
			}
			sql += " ORDER BY " + key +" " + order+" LIMIT "+count;
			//trace(sql);
			excuteSQL(sql);
			return (statement.getResult().data as Array);
		}
		
		/**
		 * 查询总的记录数
		 * @param	tbnameStr
		 * @return
		 */
		public function getTotalCount(tbnameStr:String):int {
			var sql:String = "select count(*) from " + tbnameStr;
			excuteSQL(sql);
			var ary:Array = (statement.getResult().data as Array);
			if (ary && ary.length) {
				return ary[0]["count(*)"];
			}
			return 0;
		}
		
		/**
		 * 从startIndex开始返回len条数据
		 * @param	tbnameStr
		 * @param	startIndex
		 * @param	len
		 * @return
		 */
		public function selectForLimit(tbnameStr:String, startIndex:int, len:int):Array {
			var sql:String = "select * from " + tbnameStr + " limit " + (startIndex - 1) + "," + len;
			excuteSQL(sql);
			return (statement.getResult().data as Array);
		}
		
		
		/**
		 * 执行一个SQL语句
		 * @param	sqlStr  要执行的SQL语句
		 */
		public function excuteSQL(sqlStr:String):void {
			//trace("sqlStr:" + sqlStr);
			conn.open(dbFile);
			statement.text = sqlStr;
			statement.addEventListener(SQLEvent.RESULT,resultHandler);
			statement.addEventListener(SQLErrorEvent.ERROR,errorHandler);
			try {
				statement.execute();
			}catch (evt:SQLError) {
				throw new Error("执行SQL数据出错");
			}
		}
		
		
		//模糊查询：FROM word WHERE word_name like '%" + searchString + "%'";
		
		//执行SQL语句事件处理
		private function resultHandler(evt:SQLEvent):void {
			//trace("~~~~~~~~~~~~:"+statement.getResult().data);
			statement.removeEventListener(SQLEvent.RESULT,resultHandler);
			statement.removeEventListener(SQLErrorEvent.ERROR,errorHandler);
			conn.close();
		}
		private function errorHandler(evt:SQLErrorEvent):void {
			statement.removeEventListener(SQLEvent.RESULT,resultHandler);
			statement.removeEventListener(SQLErrorEvent.ERROR,errorHandler);
			conn.close();
			throw new Error("执行SQL数据出错");
		}
		
		
		/**
		 * 获取当前数据库
		 * @return
		 */
		public function getCurrentDB():File {
			if(dbFile){
				return dbFile;
			}else{
				throw new Error("数据库还没有创建");
				return null;
			}
		}
		
		
		/**
		 * 返回当前数据的地址以及文件名
		 * @return
		 */
		public function getCurrentDBPath():String{
			if(dbFile){
				return dbFile.nativePath;
			}else{
				throw new Error("数据库还没有创建");
				return "null";
			}
		}
		
		
		
	}

}