package com.blogspot.jaggerm.cdmeyer.views.screens.athlete
{
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.screens.TopScreen;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.core.IVisualElement;
	import mx.graphics.BitmapFillMode;
	
	import spark.components.Image;
	import spark.components.Label;
	
	
	
	public class AthleteTop extends TopScreen
	{
		private var _athlete : Athlete;
		private var _athleteChanged : Boolean = false;
		
		private var firstName : Label;
		private var lastName : Label;
		
		private var sportsLabels : Array = []; 
		private var sports : XML;
		
		private var firstNameY : Number = 200;
		
		private var photoMask : Image;
		[Embed(source="../../../../../../../resources/black_shade.png")]
		private var shade : Class;
		
		[Bindable]
		public function set athlete(value : Athlete) : void
		{
			if(_athlete != value)
			{
				_athleteChanged = true;
				_athlete = value;
				invalidateProperties();
				invalidateDisplayList();
			}			
		}
		
		public function get athlete() : Athlete
		{
			return _athlete;
		}
		
		public function get athletePath() : String
		{
			return cdmeyer.APP_PATH + 'info/' + _athlete.lastName + '_' 
				+ _athlete.firstName  + '/';
		}
//		
		public function AthleteTop(value:ScreenSettings, _scrWidth:Number, _scrHeight:Number)
		{
			super(value, _scrWidth, _scrHeight);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_athleteChanged)
			{
				firstName.text = athlete.firstName.toUpperCase();
				lastName.text = athlete.lastName.toUpperCase();
				
				sports = GetFileBytes('sports.xml');
				
				for each(var dob : IVisualElement in sportsLabels)
				removeElement(dob);
				sportsLabels.splice(0,sportsLabels.length);
				
				var startY : uint = firstNameY - 20;
				var startX : uint = 111;
				for each(var item : XML in sports[0].item)
				{
					var lbl : Label = new Label();
					lbl.setStyle('fontFamily',"Swis721CnBT");
					lbl.setStyle('fontWeight', "bold");
					lbl.setStyle('fontSize', 48);
					lbl.setStyle('color', 0xb38807);
					lbl.x = startX;
					startY = startY - 60;
					lbl.y = startY; 
					lbl.text = item[0];
					addElement(lbl);
					sportsLabels.push(lbl);
				}
			}
		}
				
		private function DrawBGPhoto(): void
		{
			if(backgroundPhoto == null)
			{
				backgroundPhoto = new Image();
				backgroundPhoto.addEventListener(Event.COMPLETE, BackgroundLoaded);
				backgroundPhoto.x = 0;
				backgroundPhoto.y = 0;		
				backgroundPhoto.scaleMode = BitmapFillMode.CLIP;
				backgroundPhoto.source = athletePath + _athlete.backGroundImage;
				addElement(backgroundPhoto);
				
				photoMask = new Image();
				photoMask.source = shade;
				photoMask.scaleMode = BitmapFillMode.SCALE;
				photoMask.x = 0;
				photoMask.y = 0;
				photoMask.width = _screenWidth;
				photoMask.height = _screenHeight;
				addElement(photoMask);
			}
			else 
			{
				//				removeElement(backgroundPhoto);
				backgroundPhoto.source = athletePath + _athlete.backGroundImage;
			}
		}	
		
		private function BackgroundLoaded(event : Event) : void
		{
			var w : Number = _screenWidth;
			var h : Number = _screenHeight * 2;
			var bgX : Number =  (_screenWidth - backgroundPhoto.bitmapData.width) / 2;
			var bgY : Number = (_screenHeight - backgroundPhoto.bitmapData.height) / 2;
			backgroundPhoto.width = w;
			backgroundPhoto.height = h;
			backgroundPhoto.x = 0;
			backgroundPhoto.y = 0;		
			
			//			shade.x = bgX;
			//			shade.y
		}
		
		override public function draw() : void
		{
			DrawBGPhoto();			
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			firstName = new Label();
			firstName.setStyle('fontFamily',"Swis721CnBT");
			firstName.setStyle('fontWeight', "bold");
			firstName.setStyle('fontSize', 180);
			firstName.setStyle('color', 0xffffff);
			firstName.x = 111;
			firstName.y = firstNameY;
			firstName.text = 'firstName';
			addElement(firstName);	
			
			lastName = new Label();
			lastName.setStyle('fontFamily',"Swis721CnBT");
			lastName.setStyle('fontWeight', "bold");
			lastName.setStyle('fontSize', 180);
			lastName.setStyle('color', 0xb38807);
			lastName.x = 111;
			lastName.y = firstNameY + 180;
			lastName.text = 'lastName';
			addElement(lastName);	
		}
		
		public function GetFileBytes(fileName : String) : XML
		{
			var file:File = File.documentsDirectory.resolvePath(athletePath + fileName); 
			
			var fileStream:FileStream = new FileStream(); 
			
			fileStream.open(file, FileMode.READ); 
			var answer:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			
			return answer;
		}
		
		override protected function DrawTopLogo() : void
		{
			
		}
		
	}
}