package com.blogspot.jaggerm.cdmeyer_admin.model
{
	import com.blogspot.jaggerm.cdmeyer_admin.utils.UDate;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.sampler.getInvocationCount;
	
	import mx.controls.Alert;
	import mx.utils.StringUtil;
	
	public class Athlete
	{
		public var id : String = '';
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
		
		private var deleteVideos : Array = [];
		private var deleteHeadShots : Array = [];
		
		public function Athlete(rawData : XML = null)
		{
			if(rawData != null)
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
			var info : String = 'info/' + lastName + '_' + firstName + '/'
			var file : File = new File(csu_admin.APP_PATH + info);
			if(!file.exists)
				file.createDirectory();
			
			return info;
		}
		
		public function reset():void
		{
			deleteVideos = [];
			deleteHeadShots = [];
		}
		
		
		public function GetOacs() : void
		{
			oacs.splice(0, oacs.length);
			var oacsXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'other.xml'));
			for each(var item : XML in oacsXML[0].item)
			{
				oacs.push(item[0]);
			}
		}
		
		public function SaveOacs() : void
		{
			//			if(oacs.length == 0)
			//				return;
			
			var sportsXML : String = '<items>';
			for each(var item : String in oacs)
			{
				sportsXML += '<item><![CDATA[' + item + ']]></item>';
			}
			sportsXML += '</items>';
			
			csu_admin.SaveFileContent(infoPath() + 'other.xml', sportsXML);
		}
		
		public function GetVideos() : void
		{
			videos.splice(0, videos.length);
			var videosXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'video.xml'));
			for each(var item : XML in videosXML[0].item)
			{
				videos.push(new VideoVO(item));
			}
		}
		
		public function SaveVideos() : void
		{
			var videosXML : String = '<items>';
			for each(var item : VideoVO in videos)
			{
				if(item)
					videosXML += item.toXMLString();
			}
			videosXML += '</items>';
			
			csu_admin.SaveFileContent(infoPath() + 'video.xml', videosXML);
			
			for each(item in deleteVideos)
			{
				var file:File = new File(csu_admin.APP_PATH + infoPath() + item.file);
				if(file.exists)
					file.deleteFile();
			}
			
		}
		
		public function GetSports2() : void
		{
			sports2.splice(0, sports2.length);
			
			var sportsXML : XML = XML(csu_admin.GetFileContent(infoPath() + 'sports.xml'));
			for each(var item : XML in sportsXML[0].item)
			{
				sports2.push(item[0]);
			}
		}
		
		public function SaveSports2() : void
		{
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
			headShots.splice(0, headShots.length);
			
			var file:File = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath());
			if(!file.exists)
				return;
			
			var files : Array = file.getDirectoryListing();
			for each(var item : File in files)
			{
				if( ((item.nativePath.toLowerCase().indexOf('.jpg') != -1) || (item.nativePath.toLowerCase().indexOf('.png') != -1)) && item.name != backGroundImage)
					headShots.push(item.name);
			}
		}
		
		public function SaveBackground(value : String) : void
		{
			deleteBackground();
			
			var tmp : Array = value.split('\\');
			var file : File = new File(value);
			backGroundImage = String(tmp[tmp.length-1]).replace(' ', '');
			var index:int = backGroundImage.lastIndexOf(".");
			backGroundImage = backGroundImage.substring(0, index) + "_" + UDate.now() + backGroundImage.substr(index, backGroundImage.length);
			var destination:FileReference = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath() + backGroundImage);						
			file.copyTo(destination,true);
		}
		
		public function deleteBackground():void
		{
			var file:File = new File(csu_admin.APP_PATH + infoPath() + backGroundImage);
			if(file.exists && backGroundImage)
				file.deleteFile();
			
			backGroundImage = "";
		}
		
		public function SaveHeadShot(id : String, path : String) : void
		{
			var tmp : Array = path.split('\\');
			var file : File = new File(path);
			var fileName : String = String(tmp[tmp.length-1]).replace(' ', '');
			var index:int = fileName.lastIndexOf(".");
			fileName = fileName.substring(0, index) + "_" + UDate.now() + fileName.substr(index, fileName.length);
			var destination:FileReference = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath() + fileName);						
			file.copyTo(destination,true);
			
			index = Number(id);
			if(headShots.length > index)
				headShots[index] = fileName;
			else
				headShots.push(fileName);
		}
		
		public function deleteHeadShot(index:int):void
		{
			if(headShots.length > index)
			{
				deleteHeadShots.push(headShots[index]);
				headShots[index] = null;
			}
			else
			{
				deleteHeadShots.push( headShots.pop() );
			}
		}
		
		public function cleanHeadShots():void
		{
			for each(var fileName:String in deleteHeadShots)
			{
				var file:File = new File(csu_admin.APP_PATH + infoPath() + fileName);
				if(file.exists)
					file.deleteFile();
			}
		}
		
		public function SaveVideo(id : String, path : String, title : String) : void
		{
			var tmp : Array = path.split('\\');
			var file : File = new File(path);
			var fileName : String = String(tmp[tmp.length-1]).replace(' ', '');
			var index:int = fileName.lastIndexOf(".");
			fileName = fileName.substring(0, index) + "_" + UDate.now() + fileName.substr(index, fileName.length);
			var destination:FileReference = File.documentsDirectory.resolvePath(csu_admin.APP_PATH + infoPath() + fileName);						
			file.copyTo(destination,true);
			
			var videoVO : VideoVO = new VideoVO();
			videoVO.file = fileName;
			videoVO.title = title;
			
			index = Number(id);
			if(videos.length > index)
				videos[index] = videoVO;
			else
				videos.push(videoVO);
		}
		
		public function deleteVideo(index:int):void
		{
			if(videos.length > index)
			{
				deleteVideos.push(videos[index]);
				videos[index] = null;
			}
			else
			{
				deleteVideos.push( videos.pop() );
			}
		}
		
		
		public function UpdateVideoTitle(id : String, title : String) : void
		{
			var index : uint = Number(id);
			if(videos.length > index && videos[index])
				videos[index].title = title;
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