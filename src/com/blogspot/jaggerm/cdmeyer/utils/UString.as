package com.blogspot.jaggerm.cdmeyer.utils
{
	public class UString
	{
		static public function trim(data:String):String
		{
			data = data.replace(/^\s*/, '');
			data = data.replace(/\s*$/, '');
			data = data.replace( new RegExp( " +", "g" ), " " );
			return data;
		}

	}
}