package com.blogspot.jaggerm.cdmeyer_admin.model
{
	public class VideoVO
	{
		public var title : String;
		public var file : String;
		
		public function VideoVO(rawData : XML = null)
		{
			if(rawData != null)
				initFromXML(rawData);
		}
			
		public function initFromXML(rawData : XML) : void
		{
			file = rawData.file[0];
			title = rawData.title[0];
		}
		
		public function toXMLString() : String
		{
			var answer : String = '<item>';
			answer += '<file><![CDATA[' + file + ']]></file>';
			answer += '<title><![CDATA[' + title + ']]></title>';
			answer += '</item>';

			return answer;
		}
	}
}