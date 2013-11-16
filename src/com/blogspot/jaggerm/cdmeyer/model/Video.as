package com.blogspot.jaggerm.cdmeyer.model
{
	public class Video
	{
		public var title : String;
		public var file : String; 
		public function Video(rawData : XML)
		{
			initFromXML(rawData);
		}
		
		public function initFromXML(rawData : XML) : void
		{
			title = rawData.title[0];
			file = rawData.file[0];
		}
	}
}