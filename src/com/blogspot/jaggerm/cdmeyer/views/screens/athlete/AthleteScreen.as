package com.blogspot.jaggerm.cdmeyer.views.screens.athlete
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.model.Video;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;

	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ListItemElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;

	import mx.core.IVisualElement;
	import mx.graphics.BitmapFillMode;
	import org.osmf.events.TimeEvent;

	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.VideoPlayer;

	public class AthleteScreen extends ScreenView
	{
		private var _athlete:Athlete;

		private var _athleteChanged:Boolean = false;

		private var _backScreen:String;

		private var _backScreenChanged:Boolean = false;


//		private var photoMask : Image;

		private var hofLbl:Label;

		private var oacLblbX:uint = 1470; //1200;//1524;

		private var oacLblbY:uint = 168;

		private var oacLabels:Array = [];

		private var oacs:XML;

		private var oacLblb:Label;

		private var oacText:TextArea;

		[Embed(source = "../../../../../../../resources/black_shade.png")]
		private var shade:Class;

		private var headshotHolder:Image;

		private var images:Array = [];

		private var imageCnt:Label;

		private var currentImageIndex:uint = 0;

		private var info:TextArea;

		private var videos:Array = [];

		private var videoBtn:Button;

		private var videoView:Boolean = false;

		private var videoPlayer:VideoPlayer;

		private var currentVideoLbl:Label;

		private var videoPlayerX:uint = 783; //783;

		private var videoPlayerY:uint = 169; //175;

		private var videoButtons:Array = [];

		private var btnLeft:Button;

		private var btnRight:Button;

		//to back to sport scr
		private var _sport:String;

		private var timer:Timer;

		public function set sport(value:String):void
		{
			if (value != _sport)
			{
				_sport = value;
				invalidateProperties();
			}
		}

		public function get sport():String
		{
			return _sport;
		}

		public function set athlete(value:Athlete):void
		{
			if (_athlete != value)
			{
				_athleteChanged = true;
				_athlete = value;
				invalidateProperties();
			}
		}

		public function get athlete():Athlete
		{
			return _athlete;
		}

		public function set backScreen(value:String):void
		{
			if (_backScreen != value)
			{
				_backScreenChanged = true;
				_backScreen = value;
				invalidateProperties();
			}
		}

		public function get athletePath():String
		{
			return cdmeyer.APP_PATH + 'info/' + _athlete.lastName + '_' + _athlete.firstName + '/';
		}

		public function AthleteScreen(value:ScreenSettings, _scrWidth:Number, _scrHeight:Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			showHomeBtn = true;
		}

		public function GetFileBytes(fileName:String):String
		{
			var file:File = File.documentsDirectory.resolvePath(athletePath + fileName);
			if (!file.exists)
				return null;
			var fileStream:FileStream = new FileStream();

			fileStream.open(file, FileMode.READ);
			var answer:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();

			return answer;
		}

		private function DrawBGPhoto():void
		{
			if (backgroundPhoto == null)
			{
				backgroundPhoto = new Image();
				backgroundPhoto.addEventListener(Event.COMPLETE, BackgroundLoaded);
				backgroundPhoto.x = 0;
				backgroundPhoto.y = 0;
				backgroundPhoto.scaleMode = BitmapFillMode.CLIP;
				backgroundPhoto.source = athletePath + _athlete.backGroundImage;
				addElement(backgroundPhoto);

				/*photoMask = new Image();
				photoMask.source = shade;
				photoMask.scaleMode = BitmapFillMode.SCALE;
				photoMask.x = 0;
				photoMask.y = 0;
				photoMask.width = _screenWidth;
				photoMask.height = _screenHeight;
				addElement(photoMask);*/
			}
			else
			{
//				removeElement(backgroundPhoto);
				backgroundPhoto.source = athletePath + _athlete.backGroundImage;
			}
		}

		private function BackgroundLoaded(event:Event):void
		{
			var w:Number = _screenWidth;
			var h:Number = _screenHeight * 2;
			var bgX:Number = (_screenWidth - backgroundPhoto.bitmapData.width) / 2;
			var bgY:Number = (_screenHeight - backgroundPhoto.bitmapData.height) / 2;
			backgroundPhoto.width = w;
			backgroundPhoto.height = h;
			backgroundPhoto.x = 0;
			backgroundPhoto.y = -_screenHeight;

//			shade.x = bgX;
//			shade.y
		}

		override public function draw():void
		{
			DrawBGPhoto();
			super.draw();
		}

		override protected function DrawTopLogo():void
		{
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_backScreenChanged)
			{
				_backScreenChanged = false;
				switch (_backScreen)
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

			if (_athleteChanged)
			{
				if (backgroundPhoto != null)
					DrawBGPhoto();

				hofLbl.text = 'Hall of Fame Class of ' + athlete.year;

				oacs = XML(GetFileBytes('other.xml'));

				for each (var dob:IVisualElement in oacLabels)
					removeElement(dob);
				oacLabels.splice(0, oacLabels.length);

				var startY:uint = oacLblbY + 26;
				var startX:uint = 111;
				oacText.text = '';

				oacText.textFlow = new TextFlow();
				var listElement:ListElement = new ListElement();
				oacText.textFlow.addChild(listElement);

				for each (var item:XML in oacs[0].item)
				{
//					var lbl : Label = new Label();
//					lbl.setStyle('fontFamily',"Swis721CnBT");
//					lbl.setStyle('fontWeight', "bold");
//					lbl.setStyle('fontSize', 16);
//					lbl.setStyle('color', 0xffffff);
//					lbl.x = oacLblbX;
//					startY = startY + 26;
//					lbl.y = startY; 
//					lbl.text = item[0];
//					addElement(lbl);
//					oacLabels.push(lbl);

					var listItem:ListItemElement = new ListItemElement();
					var s:SpanElement = new SpanElement();
					s.text = item[0];
					var par:ParagraphElement = new ParagraphElement();
					par.addChild(s);
					listItem.addChild(par);
					listElement.addChild(listItem);
				}

				GetImagesFiles();

				info.text = GetFileBytes('info.txt');
				btnLeft.visible = false;
				btnRight.visible = images.length > 1;
				currentImageIndex = 0;

				if (videoView)
					BtnVideoClicked(null);

				GetVideosFiles();
			}
		}

		private function GetImagesFiles():void
		{
			images.splice(0, images.length);

			var file:File = File.documentsDirectory.resolvePath(athletePath);
			if (!file.exists)
				return;

			var files:Array = file.getDirectoryListing();
			for each (var item:File in files)
			{
				if (((item.nativePath.toLowerCase().indexOf('.jpg') != -1) || (item.nativePath.toLowerCase().indexOf('.png') != -1)) && (_athlete.backGroundImage && item.nativePath.toLowerCase().indexOf(_athlete.backGroundImage.toLowerCase()) == -1))
					images.push(item.nativePath);
			}


			ShowImage(0);
		}

		private function SetVideoPlayerSource(id:int):void
		{
			var video:Video = videos[id] as Video;

			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.STOP_TIMER, true));
			videoPlayer.source = athletePath + video.file;
			currentVideoLbl.text = video.title.substring(0, 37);
			currentVideoLbl.x = videoPlayer.x + ((videoPlayer.width - (video.title.length * 24)) / 2);

			for each (var btn:Button in videoButtons)
			{
				btn.enabled = btn.id != id.toString();
			}
		}

		private function GetVideosFiles():void
		{
			videos.splice(0, videos.length);
			videoButtons.splice(0, videoButtons.length);

			var hGroup:HGroup = new HGroup();
			hGroup.percentWidth = 100;
			hGroup.y = 920;
			hGroup.horizontalAlign = "center";
			hGroup.mouseEnabled = false;
			addElement(hGroup);

			var files:XML = XML(GetFileBytes('video.xml'));
			for each (var item:XML in files[0].item)
			{
				var video:Video = new Video(item);

				videos.push(video);
				var btn:Button = new Button();
				btn.id = videoButtons.length.toString();
				btn.visible = false;
				btn.setStyle("skinClass", NextBideoBtnSkin);
				btn.addEventListener(MouseEvent.CLICK, NextBideoBtnClicked);
				btn.label = video.title;
				hGroup.addElement(btn);
				videoButtons.push(btn);
			}

			if (videos.length > 0)
			{
				videoBtn.visible = true;
					//SetVideoPlayerSource(videos[0] as Video);
			}
			else
				videoBtn.visible = false;
		}

		private function ShowImage(index:uint):void
		{
			currentImageIndex = index;
			headshotHolder.source = images[currentImageIndex];
			imageCnt.text = String(Number(currentImageIndex + 1)) + '/' + images.length;

		}

		override protected function createChildren():void
		{
			super.createChildren();

			hofLbl = new Label();
			hofLbl.setStyle('fontFamily', "Swis721CnBT");
			hofLbl.setStyle('fontWeight', "bold");
			hofLbl.setStyle('fontSize', 60.86);
			hofLbl.setStyle('color', 0xb38807);
			hofLbl.x = 108;
			hofLbl.y = 48;
			hofLbl.text = 'hofLbl';
			addElement(hofLbl);

			oacLblb = new Label();
			oacLblb.setStyle('fontFamily', "Swis721CnBT");
			oacLblb.setStyle('fontWeight', "bold");
			oacLblb.setStyle('fontSize', 16);
			oacLblb.setStyle('color', 0xb38807);
			oacLblb.x = oacLblbX;
			oacLblb.y = oacLblbY;
			oacLblb.text = 'OTHER ACCOMPLISHMENTS:';
			addElement(oacLblb);

			oacText = new TextArea();
			oacText.setStyle('fontFamily', "Swis721CnBT");
			oacText.setStyle('fontWeight', "bold");
			oacText.setStyle('fontSize', 26);
			oacText.setStyle('color', 0xffffff);
			oacText.x = oacLblbX;
			oacText.y = oacLblbY + 26;
			oacText.width = 440;
			oacText.height = 580;
			oacText.editable = false;
			oacText.selectable = false;
			oacText.setStyle("skinClass", AthleteInfoSkin);
//			oacText.setStyle('lineHeight', 25);
			addElement(oacText);

			var bio:Image = new Image();
			bio.source = cdmeyer.APP_PATH + 'bio.png';
			bio.x = 113;
			bio.y = 168;
			addElement(bio);

			headshotHolder = new Image();
			headshotHolder.width = 300;
			headshotHolder.height = 450;
			headshotHolder.x = 453;
			headshotHolder.y = 169;
			headshotHolder.scaleMode = mx.graphics.BitmapScaleMode.LETTERBOX;
			headshotHolder.horizontalAlign = 'center';
			addElement(headshotHolder);

			btnLeft = new Button();
			btnLeft.setStyle("skinClass", LeftButtonSkin);
			btnLeft.addEventListener(MouseEvent.CLICK, BtnLeftClicked);
			btnLeft.x = 455;
			btnLeft.y = 627;
			btnLeft.visible = false;
			addElement(btnLeft);

			btnRight = new Button();
			btnRight.setStyle("skinClass", RightButtonSkin);
			btnRight.addEventListener(MouseEvent.CLICK, BtnRightClicked);
			btnRight.x = 715;
			btnRight.y = 627;
			addElement(btnRight);

			imageCnt = new Label();
			imageCnt.setStyle('fontFamily', "Swis721CnBT");
			imageCnt.setStyle('fontWeight', "bold");
			imageCnt.setStyle('fontSize', 27);
			imageCnt.setStyle('color', 0xffffff);
			imageCnt.x = 592;
			imageCnt.y = 634;
			addElement(imageCnt);

			info = new TextArea();
			info.x = 848;
			info.y = 164;
			info.width = 593;
			info.height = 800;
			info.editable = false;
			info.selectable = false;

			info.setStyle("skinClass", AthleteInfoSkin);
			info.setStyle('fontFamily', "Swis721MdBT");
			info.setStyle('fontWeight', "bold");
			info.setStyle('fontSize', 26);
			info.setStyle('lineHeight', 35);
			info.setStyle('color', 0xffffff);
			addElement(info);

			videoBtn = new Button();
			videoBtn.setStyle("skinClass", VideoButtonSkin);
			videoBtn.addEventListener(MouseEvent.CLICK, BtnVideoClicked);
			videoBtn.x = 1770;
			videoBtn.y = 870;
			videoBtn.visible = false;
			addElement(videoBtn);

			videoPlayer = new VideoPlayer();
			videoPlayer.setStyle("skinClass", PlayerSkin);
			videoPlayer.visible = false;
			videoPlayer.x = videoPlayerX;
			videoPlayer.y = videoPlayerY;
			videoPlayer.width = 1024;
			videoPlayer.height = 576;
			videoPlayer.autoDisplayFirstFrame = true;
			videoPlayer.autoPlay = true;
			videoPlayer.scaleMode = 'stretch';
			videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoComplete);
//			videoPlayer.addEventListener(CDMeyerEvent.STOP_TIMER, OnTimerStop);

			addElement(videoPlayer);

			currentVideoLbl = new Label();
			currentVideoLbl.setStyle('fontFamily', "Swis721CnBT");
			currentVideoLbl.setStyle('fontWeight', "bold");
			currentVideoLbl.setStyle('fontSize', 60);
			currentVideoLbl.setStyle('color', 0xffffff);
			currentVideoLbl.x = 784;
			currentVideoLbl.y = 48;
			currentVideoLbl.visible = false;
			currentVideoLbl.text = 'Video Title';
			addElement(currentVideoLbl);

		}

//		private function OnTimerStop(e : CDMeyerEvent) : void
//		{
//			if(cdmeyer.timer.running)
//				cdmeyer.ResetTimer();
//		}

		private function BtnLeftClicked(e:MouseEvent):void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));

			if (!btnRight.visible)
				btnRight.visible = true;

			currentImageIndex--;
			ShowImage(currentImageIndex);

			if (currentImageIndex == 0)
			{
				btnLeft.visible = false;
			}

		}

		private function BtnRightClicked(e:MouseEvent):void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));

			if (!btnLeft.visible)
				btnLeft.visible = true;
			currentImageIndex++;
			ShowImage(currentImageIndex);

			if (currentImageIndex == images.length - 1)
			{
				btnRight.visible = false;
			}
		}

		private function BtnVideoClicked(e:MouseEvent):void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));

			videoView = !videoView;

			if (videos.length > 0)
				videoBtn.visible = !videoView;
			else
				videoBtn.visible = false;

			info.visible = !videoView;
			oacLblb.visible = !videoView;
			for each (var item:Label in oacLabels)
			{
				item.visible = !videoView;
			}

			oacText.visible = !videoView;

			videoPlayer.visible = videoView;
			videoPlayer.volume = 0.5;
			currentVideoLbl.visible = videoView;

			for each (var btn:Button in videoButtons)
			{
				btn.visible = videoView;
			}

			if (videoView)
				SetVideoPlayerSource(0);
		}

		private function NextBideoBtnClicked(e:MouseEvent):void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));

			SetVideoPlayerSource(Number(e.target.id));
		}

		override protected function BackClicked(e:MouseEvent):void
		{
			if (videoView)
			{
				dispatchEvent(new CDMeyerEvent(CDMeyerEvent.START_TIMER, true));
				BtnVideoClicked(new MouseEvent(MouseEvent.CLICK))
				return;
			}

			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));
			var event:CDMeyerEvent = new CDMeyerEvent(backBtnEventType);
			event.screenLabel = _sport;
			event.year = Number(_athlete.year);
			dispatchEvent(event);
		}

		override protected function HomeClicked(event:MouseEvent):void
		{
			if (videoView)
				videoPlayer.visible = false;
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.START_TIMER, true));
			super.HomeClicked(event);
		}

		private function VideoComplete(e:TimeEvent):void
		{
//			if(timer == null)
//			{
//				timer = new Timer(180000);
//				timer.addEventListener(TimerEvent.TIMER, TimerComplete);
//			}
//			stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
//			timer.start();
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.START_TIMER, true));
		}

//		private function MouseMove(e : MouseEvent) : void
//		{
//			timer.reset();
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
//		}

//		private function TimerComplete(e : TimerEvent) : void
//		{
//			timer.reset();
//			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
//		}

	}
}
