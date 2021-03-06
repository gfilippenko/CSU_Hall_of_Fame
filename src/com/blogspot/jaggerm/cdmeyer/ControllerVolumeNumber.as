package com.blogspot.jaggerm.cdmeyer
{
	import com.blogspot.jaggerm.cdmeyer.events.SecureEvent;

	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setTimeout;

	[Event(name = "SecurityValid", type = "com.blogspot.jaggerm.cdmeyer.events.SecureEvent")]
	[Event(name = "SecurityNotValid", type = "com.blogspot.jaggerm.cdmeyer.events.SecureEvent")]
	public class ControllerVolumeNumber extends EventDispatcher
	{
		private const UTILITE_NAME:String = "DeviceID.exe";

		private var _nativeProcess:NativeProcess;

		private var _file:File;

		private var _nativeProcessSUI:NativeProcessStartupInfo;

		private var serialVolumes:Vector.<String> = new Vector.<String>();

		private var codes:Vector.<String> = new Vector.<String>();

		public function ControllerVolumeNumber()
		{
			loadTrustedCodes();
		}

		private function activateNativeProcess():void
		{
			if (NativeProcess.isSupported)
			{
				_nativeProcess = new NativeProcess();
				_nativeProcessSUI = new NativeProcessStartupInfo();
				_file = File.applicationDirectory.resolvePath(UTILITE_NAME);
				if (_file.exists)
				{
					_nativeProcessSUI.executable = _file;
					_nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onNativeProcessSOD);
					_nativeProcess.start(_nativeProcessSUI);
				}
			}
			else
			{
				throw new Error("NativeProcess NOT SUPPORTED");
			}
		}

		private function onNativeProcessSOD(e:ProgressEvent):void
		{
			var stdOut:String = _nativeProcess.standardOutput.readUTFBytes(_nativeProcess.standardOutput.bytesAvailable);
			serialVolumes = new Vector.<String>();
			var rex:RegExp = /[\s\r\n]*/gim;
			for each (var serialNumber:String in XML(stdOut)..@serialNumber)
			{
				serialNumber = serialNumber.replace(rex, '');
				serialVolumes.push(addSeparator(serialNumber.toUpperCase()));
			}
//            trace(XML(stdOut)..@serialNumber);
			checkSecureStatus();
			stopNativeProcess();
		}

		private function addSeparator(value:String):String
		{
			var str1:String = value.slice(0, value.length / 2);
			var str2:String = value.slice(value.length / 2, value.length);
			return str1 + "-" + str2;
		}

		private function loadTrustedCodes():void
		{
			var xmlFile:File = File.applicationDirectory.resolvePath("app:/resources/codes.xml");
			var xmlStream:FileStream = new FileStream();
			xmlStream.open(xmlFile, FileMode.READ);
			var xml:XML = XML(xmlStream.readUTFBytes(xmlStream.bytesAvailable));
			xmlStream.close();

			for each (var serial:String in xml..Code)
			{
				codes.push(serial);
			}
			if (xml.children()[0].name().localName == "Disabled")
			{
				trace("Disabled Secure");
				setTimeout(notifySecureStatus, 1000, true);
			}
			else
				activateNativeProcess();
		}

		private function checkSecureStatus():void
		{
			var security:SecurityVolume = new SecurityVolume();
			notifySecureStatus(security.applicationCanRun(codes, serialVolumes));
		}

		private function stopNativeProcess():void
		{
			if (_nativeProcess.running)
				_nativeProcess.exit(true);
		}

		private function notifySecureStatus(value:Boolean):void
		{
			if (value)
				dispatchEvent(new SecureEvent(SecureEvent.SECURITY_VALID));
			else
				dispatchEvent(new SecureEvent(SecureEvent.SECURITY_NOT_VALID));
		}
	}
}
