package com.blogspot.jaggerm.cdmeyer.views.screens.athlete
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.ButtonLabelPlacement;
	import mx.core.IVisualElement;
	import mx.graphics.BitmapFillMode;
	import mx.rpc.events.HeaderEvent;
	import mx.utils.NameUtil;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.VideoPlayer;
	
	public class AthleteScreen extends ScreenView
	{
		private var _athlete : Athlete;
		private var _athleteChanged : Boolean = false;
		private var _backScreen : String;
		private var _backScreenChanged : Boolean = false;
		
		
		private var photoMask : Image;
		
		private var hofLbl : Label;
		
		private var oacLblbX : uint = 1524;//1200;//1524;
		private var oacLblbY : uint = 78;
		private var oacLabels : Array = []; 
		private var oacs : XML;
		private var oacLblb : Label;
		
		[Embed(source="../../../../../../../resources/black_shade.png")]
		private var shade : Class;
		
		private var headshotHolder : Image;
		private var images : Array = [];
		private var imageCnt : Label;
		private var currentImageIndex : uint = 0;
		
		private var info : TextArea;
		
		private var videos : Array = [];
		private var videoBtn : Button;
		private var videoView : Boolean = false;
		private var videoPlayer : VideoPlayer;
		private var currentVideoLbl : Label;
		private var videoPlayerX : uint = 784;//180;//
		private var videoButtons : Array = [];
		
		public function set athlete(value : Athlete) : void
		{
			if(_athlete != value)
			{
				_athleteChanged = true;
				_athlete = value;
				invalidateProperties();
			}			
		}
		
		public function get athlete() : Athlete
		{
			return _athlete;
		}
		
		public function set backScreen(value : String) : void
		{
			if(_backScreen != value)
			{
				_backScreenChanged = true;
				_backScreen = value;
				invalidateProperties();
			}
		}
		
		public function get athletePath() : String
		{
			return cdmeyer.APP_PATH + 'info/' + _athlete.lastName + '_' 
				+ _athlete.firstName  + '/';
		}
		
		public function AthleteScreen(value:ScreenSettings, _scrWidth:Number, _scrHeight:Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			showHomeBtn = true;
		}
		
		public function GetFileBytes(fileName : String) : String
		{
			var file:File = File.documentsDirectory.resolvePath(athletePath + fileName); 
			
			var fileStream:FileStream = new FileStream(); 
			
			fileStream.open(file, FileMode.READ); 
			var answer:String = fileStream.readUTFBytes(fileStream.bytesAvailable); 
			fileStream.close();
			
			return answer;
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
			backgroundPhoto.y = -_screenHeight;		
			
//			shade.x = bgX;
//			shade.y
		}
		
		override public function draw() : void
		{
			DrawBGPhoto();
			super.draw();
		}
				
		override protected function DrawTopLogo() : void
		{
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_backScreenChanged)
			{
				_backScreenChanged = false;
				switch(_backScreen)
				{
					case 'names':
					{
						backBtnEventType = CDMeyerEvent.SHOW_NAMES_SCREEN;
						break;
					}
						
					case 'year':
					{
						backBtnEventType = CDMeyerEvent.SHOW_SPORT_YEAR;
						break;
					}
						
					case 'sport':
					{
						backBtnEventType = CDMeyerEvent.SHOW_SPORT_SCREEN;
						break;
					}
				}
			}
			
			if(_athleteChanged)
			{
				if(backgroundPhoto != null)
					DrawBGPhoto();
				
				hofLbl.text = 'Hall of Fame Class of ' + athlete.year;
				
				oacs = XML(GetFileBytes('other.xml'));
				
				for each(var dob : IVisualElement in oacLabels)
				removeElement(dob);
				oacLabels.splice(0,oacLabels.length);
				
				var startY : uint = oacLblbY + 20;
				var startX : uint = 111;
				for each(var item : XML in oacs[0].item)
				{
					var lbl : Label = new Label();
					lbl.setStyle('fontFamily',"Swis721CnBT");
					lbl.setStyle('fontWeight', "bold");
					lbl.setStyle('fontSize', 16);
					lbl.setStyle('color', 0xffffff);
					lbl.x = oacLblbX;
					startY = startY + 20;
					lbl.y = startY; 
					lbl.text = '●    ' + item[0];
					addElement(lbl);
					oacLabels.push(lbl);
				}
				
				GetImagesFiles();
				
				info.text = GetFileBytes('info.txt');
				
				
				if(videoView)
					BtnVideoClicked(null);
				
				GetVideosFiles();
			}
		}
		
		private function GetImagesFiles() : void
		{
			images.splice(0, images.length);
			
			var file:File = File.documentsDirectory.resolvePath(athletePath);
			var files : Array = file.getDirectoryListing();
			for each(var item : File in files)
			{
				if((item.nativePath.toLowerCase().indexOf('.jpg') != -1) || (item.nativePath.toLowerCase().indexOf('.png') != -1))
					images.push(item.nativePath);
			}
			
			ShowImage(0);				
		}
		
		private function GetVideoTitle(path : String) : String
		{
			var tmp : Array = path.split('\\');
			return tmp[tmp.length -1 ].substr(0, tmp[tmp.length -1 ].length - 4);
		}
		
		private function GetVideosFiles() : void
		{
			videos.splice(0, videos.length);
			videoButtons.splice(0, videoButtons.length);
			var startX : uint = videoPlayerX;
			
			var file:File = File.documentsDirectory.resolvePath(athletePath);
			var files : Array = file.getDirectoryListing();
			for each(var item : File in files)
			{
				if((item.nativePath.toLowerCase().indexOf('.flv') != -1))
				{
					videos.push(item.nativePath);
					var btn : Button = new Button();
					btn.id = videoButtons.length.toString();
					btn.visible = false;
					btn.setStyle("skinClass", NextBideoBtnSkin );
					btn.addEventListener(MouseEvent.CLICK, NextBideoBtnClicked);
					btn.x = startX;
					btn.y = _screenHeight - 106;
					btn.label = GetVideoTitle(item.nativePath);
					addElement(btn);
					startX += 260;
					videoButtons.push(btn);
				}
								
			}
			
			if(videos.length > 0)
			{
				videoBtn.visible = true;
				videoPlayer.source = videos[0];
				
				currentVideoLbl.text = GetVideoTitle(videos[0]);
			}
			else
				videoBtn.visible = false;
		}
		
		private function ShowImage(index : uint) : void
		{
			currentImageIndex = index;
			headshotHolder.source = images[currentImageIndex];
			imageCnt.text = String(Number(currentImageIndex + 1)) + '/' + images.length;
			
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			hofLbl = new Label();
			hofLbl.setStyle('fontFamily',"Swis721CnBT");
			hofLbl.setStyle('fontWeight', "bold");
			hofLbl.setStyle('fontSize', 60.86);
			hofLbl.setStyle('color', 0xb38807);
			hofLbl.x = 109;
			hofLbl.y = 46;
			hofLbl.text = 'hofLbl';
			addElement(hofLbl);	
			
			oacLblb = new Label();
			oacLblb.setStyle('fontFamily',"Swis721CnBT");
			oacLblb.setStyle('fontWeight', "bold");
			oacLblb.setStyle('fontSize', 16);
			oacLblb.setStyle('color', 0xb38807);
			oacLblb.x = oacLblbX;
			oacLblb.y = oacLblbY;
			oacLblb.text = 'OTHER ACCOMPLISHMENTS:';
			addElement(oacLblb);
			
			var bio : Image = new Image();
			bio.source = cdmeyer.APP_PATH + 'bio.png';
			bio.x = 113;
			bio.y = 168;
			addElement(bio);
			
			headshotHolder = new Image();
			headshotHolder.width = 312;
			headshotHolder.height = 459;
			headshotHolder.x = 450;
			headshotHolder.y = 160;
			addElement(headshotHolder);
			
			var btnLeft : Button = new Button();
			btnLeft.setStyle("skinClass", LeftButtonSkin );
			btnLeft.addEventListener(MouseEvent.CLICK, BtnLeftClicked);
			btnLeft.x = 450;
			btnLeft.y = 627;
			addElement(btnLeft);
			
			var btnRight : Button = new Button();
			btnRight.setStyle("skinClass", RightButtonSkin );
			btnRight.addEventListener(MouseEvent.CLICK, BtnRightClicked);
			btnRight.x = 723;
			btnRight.y = 627;
			addElement(btnRight);
			
			imageCnt = new Label();
			imageCnt.setStyle('fontFamily',"Swis721CnBT");
			imageCnt.setStyle('fontWeight', "bold");
			imageCnt.setStyle('fontSize', 27);
			imageCnt.setStyle('color', 0xffffff);
			imageCnt.x = 597;
			imageCnt.y = 627;
			addElement(imageCnt);
			
			info = new TextArea();
			info.x = 825;
			info.y = 70;
			info.width = 700;
			info.height = 900;

//			info.width = 430;
//			info.height = 380;
			
			info.setStyle("skinClass", AthleteInfoSkin );
			info.setStyle('fontFamily',"Swis721MdBT");
//			info.setStyle('fontWeight', "bold");
			info.setStyle('fontSize', 16);
			info.setStyle('color', 0xffffff);
			addElement(info);
			
			videoBtn = new Button();
			videoBtn.setStyle("skinClass", VideoButtonSkin );
			videoBtn.addEventListener(MouseEvent.CLICK, BtnVideoClicked);
			videoBtn.x = _screenWidth - 160;
			videoBtn.y = _screenHeight - 241 - 20;
			videoBtn.visible = false;
			addElement(videoBtn);
			
			videoPlayer = new VideoPlayer();
			videoPlayer.setStyle("skinClass", PlayerSkin );
			videoPlayer.visible = false;
			videoPlayer.x = videoPlayerX;
			videoPlayer.y = 160;
			videoPlayer.width = 1024;
			videoPlayer.height = 576;
			videoPlayer.autoDisplayFirstFrame = true;
			videoPlayer.autoPlay = true;
			addElement(videoPlayer);
			
			currentVideoLbl = new Label();
			currentVideoLbl.setStyle('fontFamily',"Swis721CnBT");
			currentVideoLbl.setStyle('fontWeight', "bold");
			currentVideoLbl.setStyle('fontSize', 60);
			currentVideoLbl.setStyle('color', 0xffffff);
			currentVideoLbl.x = 784;
			currentVideoLbl.y = 46;
			currentVideoLbl.visible = false;
			currentVideoLbl.text = 'Video Title';
			addElement(currentVideoLbl);
			
		}
	
	
		private function BtnLeftClicked(e : MouseEvent) : void
		{
			if(currentImageIndex == 0 )
				return;
			currentImageIndex--;
			ShowImage(currentImageIndex);						
		}
		
		private function BtnRightClicked(e : MouseEvent) : void
		{
			if(currentImageIndex == images.length - 1)
				return;
			currentImageIndex++;
			ShowImage(currentImageIndex);	
		}
		
		private function BtnVideoClicked(e : MouseEvent) : void
		{
			videoView = !videoView;
			
			if(videos.length > 0)
				videoBtn.visible = !videoView;
			else
				videoBtn.visible = false;
			
			info.visible = !videoView;
			oacLblb.visible = !videoView;
			for each(var item : Label in oacLabels)
			{
				item.visible = !videoView;
			}
			
			videoPlayer.visible = videoView;
			currentVideoLbl.visible = videoView;
			
			for each(var btn : Button in videoButtons)
			{
				btn.visible = videoView;
			}
		}
		
		private function NextBideoBtnClicked(e : MouseEvent) : void
		{
			var source : String = videos[Number(e.target.id)]; 
			videoPlayer.source = source;
			var tmp : Array = source.split('\\');
			currentVideoLbl.text = tmp[tmp.length -1 ].substr(0, tmp[tmp.length -1 ].length - 4);
		}
		
		override protected function BackClicked(e : MouseEvent) : void
		{
			if(videoView)
			{
				BtnVideoClicked(new MouseEvent(MouseEvent.CLICK))
				return;
			}
			
			var event : CDMeyerEvent = new CDMeyerEvent(backBtnEventType);
			event.year = Number(_athlete.year); 
			dispatchEvent(event);
		}
	
	}
}