package com.blogspot.jaggerm.cdmeyer.model
{
	public class Athlete
	{
		public var firstName : String;
		public var lastName : String;
		public var sport : String;
		public var year : String;
		
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
		}
	}
}