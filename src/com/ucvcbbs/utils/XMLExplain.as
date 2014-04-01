package com.ucvcbbs.utils 
{
	/**
	 * ...
	 * @author xiangshun
	 */
	public class XMLExplain 
	{
		
		public function XMLExplain() 
		{
			
		}
		
		/**
		 * 把XML数据转成对象
		 * 一个节点就是一个对象:obj={property:Object,txt:String,child:Array}
		 * property:节点属性,txt:节点内的文本内容, child:包含的子节点
		 * 纯文字节点就是一个空对象,
		 * @param	xmldata  XML数据
		 * @return
		 */
		public static function explainToObj(xmldata:XML):Object {
			var rootObj:Object = new Object();
			rootObj = nodeExplain(xmldata);
			return rootObj;
		}
		
		private static function nodeExplain(node:XML):Object {
			var obj:Object = new Object();
			var nodeAry:Array = [];
			obj.property = getAttributes(node);
			obj.txt = node.text().toString();
			obj.child = nodeAry;
			if (node.hasComplexContent()) {
				var len:int = node.children().length();
				for (var i:int; i < len; i++) {
					nodeAry[i] = nodeExplain(node.children()[i]);
				}
			}
			return obj;
		}
		
		private static function getAttributes(node:XML):Object {
			var len:int = node.attributes().length();
			if (len == 0) return null;
			var obj:Object = new Object();
			for (var i:int = 0; i < len; i++) {
				obj[String(node.attributes()[i].name())] = node.attributes()[i];
			}
			return obj;
		}
		
	}

}