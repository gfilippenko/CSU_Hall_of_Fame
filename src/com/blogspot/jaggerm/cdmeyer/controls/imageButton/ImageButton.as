package com.blogspot.jaggerm.cdmeyer.controls.imageButton
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.Button;
	import spark.primitives.BitmapImage;
	
	public class ImageButton extends Button
	{
		[Bindable]
		public var cornerRadius:Number = 00;
		
		[Bindable]
		public var source:Object;
		
		[SkinPart(required="false")]
		public var imageDisplay:BitmapImage;
		
		public function ImageButton()
		{
			super();	
			// set our custom skin class
			setStyle("skinClass", ImageButtonSkin );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == imageDisplay) {
				imageDisplay.addEventListener(Event.COMPLETE, handleImageLoaded);
				imageDisplay.scaleMode = BitmapScaleMode.STRETCH; 
				imageDisplay.source = source;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == imageDisplay) {
				imageDisplay.source = null;
			}
		}
		
		protected function handleImageLoaded(e:Event):void
		{
			if(imageDisplay)// commit gets called once before create children so let's check for imageDisplay
			{
				if((width == 0) && height != 0)//did the user set the height but not the width on the tag?
				{
					if(height == imageDisplay.sourceHeight)// the height was set but it happens to be the same as the source
					{
						width = Math.round((imageDisplay.sourceWidth * height) / imageDisplay.sourceHeight); 
					}
					else
					{
						width = Math.round((imageDisplay.sourceWidth * height) / imageDisplay.sourceHeight); 
					}
				}
				else if(height == 0 && width != 0)//did the user set the width but not the height on the tag?
				{
					if(width == imageDisplay.sourceWidth)// the width was set but it happens to be the same as the source
					{
						height = Math.round((imageDisplay.sourceHeight * width) / imageDisplay.sourceWidth); 
					}
					else
					{
						height = Math.round((imageDisplay.sourceHeight * width) / imageDisplay.sourceWidth); 
					}
				}
				else if(height != imageDisplay.sourceHeight && width != imageDisplay.sourceWidth)
				{
					// custom width and height
				}
			}
		}
		
	}
}