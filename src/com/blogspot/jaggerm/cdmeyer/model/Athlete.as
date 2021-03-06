package com.blogspot.jaggerm.cdmeyer.model
{
	import mx.utils.StringUtil;

	public class Athlete
	{
		public var fN : String;
		public var lN : String;

		public var firstName : String;
		public var lastName : String;
		public var sport : String;
		public var sports : Array = [];
		public var year : String;
		public var backGroundImage : String;
		
		public function Athlete(rawData : XML)
		{
			initFromXML(rawData);
		}
		
		public function initFromXML(rawData : XML) : void
		{
			fN = rawData.f[0];
			lN = rawData.l[0];

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
			
			sport = sports.join(', ');
		}
		
		public function hasSport(value : String) : Boolean
		{
			for each(var item : String in sports)
			{
				if(item.toLowerCase() == value.toLowerCase())
					return true;
			}
			
			return false;
		}
	}
}