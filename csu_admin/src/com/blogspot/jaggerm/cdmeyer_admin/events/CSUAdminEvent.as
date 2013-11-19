package com.blogspot.jaggerm.cdmeyer_admin.events
{
	import com.blogspot.jaggerm.cdmeyer_admin.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer_admin.model.Decade;
	
	import flash.events.Event;
	
	public class CSUAdminEvent extends Event
	{
		public static const EDIT_ITEM : String = 'editItem';
		public static const DELETE_ITEM : String = 'deleteItem';
		public static const ADD_ITEM : String = 'addItem';
		
		public var decade : Decade;
		public var athlete : Athlete;
		public var itemID : String;
		public var prevID : uint;

		public function CSUAdminEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}