package com.blogspot.jaggerm.cdmeyer_admin.model
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.sampler.getInvocationCount;
	
	import mx.utils.StringUtil;

	public class Athlete
	{
		public var id : String;
		public var firstName : String = '';
		public var lastName : String = '';
		public var sports : Array = [];
		public var sport : String = '';
		public var year : String = '';
		public var backGroundImage : String = '';
		public var videos : Array = [];
		public var sports2 : Array = [];
		public var bio : String = '';
		public var headShots : Array = [];
		public var oacs : Array = [];
		
		public function Athlete(rawData : XML)
		{
			initFromXML(rawData);
		}
		
		public function initFromXML(rawData : XML) : void
		{
			firstName = rawData.f[0];
			lastName = rawData.l[0];
			sport = rawData.s[0];
			year = rawData.year[0];
			backGroundImage = rawData.bg[0];
			sports = sport.split(',');
			
			var len : uint = sports.length;
			for(var i:uint=0;i<len;i++)
			{
				sports[i] = StringUtil.trim(sports[i]);
			}
		}
		
		public function toXML() : String
		{
			var answer : String = '<item><f><![CDATA['+ firstName +']]></f><l><![CDATA['+ lastName +']]></l><s><![CDATA['+ sports.join(',') +']]></s><year>'+ year +'</year><bg><![CDATA['+ backGroundImage +']]></bg></item>';
			return answer;
		}
		
		public function infoPath() : String
		{
			return 'info/' + lastName + '_' + firstName + '/';
		}
		
		public function GetOacs() : void
		{
			var oacsXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'other.xml'));
			for each(var item : XML in oacsXML[0].item)
			{
				oacs.push(item[0]);
			}
		}
		
		public function SaveOacs() : void
		{
			if(oacs.length == 0)
				return;
			
			var sportsXML : String = '<items>';
			for each(var item : String in sports2)
			{
				sportsXML += '<item><![CDATA[' + item + ']]></item>';
			}
			sportsXML += '</items>';
			
			csu_admin.SaveFileContent(infoPath() + 'other.xml', sportsXML);
		}
		
		public function GetVideos() : void
		{
			var videosXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'video.xml'));
			for each(var item : XML in videosXML[0].item)
			{
				videos.push(new VideoVO(item));
			}
		}
		
		public function SaveVideos() : void
		{
			if(videos.length == 0)
				return;
			
			var videosXML : String = '<items>';
			for each(var item : VideoVO in videos)
			{
				videosXML += item.toXMLString();
			}
			videosXML += '</items>';
			
			csu_admin.SaveFileContent(infoPath() + 'video.xml', videosXML);
		}
		
		public function GetSports2() : void
		{
			var sportsXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'sports.xml'));
			for each(var item : XML in sportsXML[0].item)
			{
				sports2.push(item[0]);
			}
		}
		
		public function SaveSports2() : void
		{
			if(sports2.length == 0)
				return;
			
			var sportsXML : String = '<items>';
			for each(var item : String in sports2)
			{
				sportsXML += '<item><![CDATA[' + item + ']]></item>';
			}
			sportsXML += '</items>';
			
			csu_admin.SaveFileContent(infoPath() + 'sports.xml', sportsXML);
		}
		
		public function GetBio() : void
		{
			bio = csu_admin.GetFileContent(infoPath() + 'info.txt');
		}
		
		public function SaveBio() : void
		{
			csu_admin.SaveFileContent(infoPath() + 'info.txt', bio);
		}
		
		public function GetHedshots() : void
		{
			var file:File = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath());
			if(!file.exists)
				return;
			
			var files : Array = file.getDirectoryListing();
			for each(var item : File in files)
			{
				if((item.nativePath.toLowerCase().indexOf('.jpg') != -1) || (item.nativePath.toLowerCase().indexOf('.png') != -1))
					headShots.push(item.nativePath);
			}
		}
		
		public function RemoveAllInfo(): void
		{
			var file:File = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath());
			if(!file.exists)
				return;
			file.deleteDirectory(true);			
		}
	}
}