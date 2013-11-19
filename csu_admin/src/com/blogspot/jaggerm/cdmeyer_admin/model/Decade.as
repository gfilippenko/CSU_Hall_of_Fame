package com.blogspot.jaggerm.cdmeyer_admin.model
{
	public class Decade
	{
		public var id : uint;
		public var years  : Array = [];
		
		public function Decade()
		{
			
		}
		
		public function toXML() : String
		{
			var ans : String = '<decade id="' + id + '">';
			for each(var year : Number in years)
			{ 
				ans += '<year>' + year + '</year>';
			}
			ans += '</decade>';	
			
			return ans;
		}
	}
}