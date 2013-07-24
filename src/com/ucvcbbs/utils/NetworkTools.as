package com.ucvcbbs.utils 
{
	import flash.display.Stage;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	/**
	 * ...
	 * @author xiangshun
	 */
	public class NetworkTools 
	{
		
		public function NetworkTools() 
		{
			
		}
		
		/**
		 * 获取本机的IP地址
		 * @return
		 */
		public static function getLocalAddress():String {
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();
			if( interfaces != null )
			{
				for each ( var interfaceObj:NetworkInterface in interfaces )
				{
					if (interfaceObj.hardwareAddress == "") continue;
					for each ( var address:InterfaceAddress in interfaceObj.addresses )
					{
						if (address.broadcast != "") {
							return address.address;
						}
					}
				}            
			}
			return null;
		}
		
		/**
		 * 检查端口是否被占用
		 * @param	address IP地址
		 * @param	port 端口
		 * @return
		 */
		public static function checkLocalPort(address:String,port:int):Boolean {
			var socket:ServerSocket = new ServerSocket();
			try {
				socket.bind(port, address);
			}catch (e:Error) {
				return true;
			}
			socket.close();
			return false;
		}
		
		/**
		 * 获取本机一个可用的端口
		 * @param	startPort 起始端口
		 * @return
		 */
		public static function getUsableLocalPort(startPort:int=3000):int {
			//65535
			var tnum:int = Math.round(Math.random() * (65535 - startPort)) + startPort;
			if (checkLocalPort(getLocalAddress(), tnum)) {
				getUsableLocalPort(startPort);
			}
			return tnum;
		}
		
	}

}