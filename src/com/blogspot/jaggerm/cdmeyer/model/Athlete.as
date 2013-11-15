package com.blogspot.jaggerm.cdmeyer.model
{
	public class Athlete
	{
		public var fN : String;
		public var lN : String;

		public var firstName : String;
		public var lastName : String;
		public var sport : String;
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
		}
	}
}