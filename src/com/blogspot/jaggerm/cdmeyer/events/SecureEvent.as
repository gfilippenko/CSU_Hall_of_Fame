package com.blogspot.jaggerm.cdmeyer.events
{
	import flash.events.Event;

	public class SecureEvent extends Event
	{

		public static const SECURITY_VALID:String = "SecurityValid";

		public static const SECURITY_NOT_VALID:String = "SecurityNotValid";

		public function SecureEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
