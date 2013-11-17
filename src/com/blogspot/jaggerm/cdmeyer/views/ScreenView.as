package com.blogspot.jaggerm.cdmeyer.views
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.list.SortBar;
	import com.blogspot.jaggerm.cdmeyer.views.screens.BackButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.HomeButtonSkin;
	import com.blogspot.jaggerm.cdmeyer.views.screens.NextButtonSkin;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.ReturnKeyLabel;
	import flash.ui.Mouse;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.events.FlexEvent;
	import mx.graphics.BitmapFillMode;
	import mx.states.OverrideBase;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.WindowedApplication;
	import spark.primitives.BitmapImage;
	

	public class ScreenView extends Group
	{
		protected var backgroundPhoto : Image;
		
		public static const mainButtonWidth : Number = 428;
		public static const mainButtonHeight : Number = 428;
		public static const backBtnHeight : Number = 241;
		public static const listWidth : Number = 1272;//800;//1322;
		public static const listHeight : Number = 820;//600;//900; 
		public static const sportButtonWidth : Number = 265;
		
		public static const instructionsWidth : Number = 419;
		public static const instructionsHeight : Number = 377;
		
		public static const instructionsX : Number = 113;
		public static const instructionsY : Number = 177;
				
		public var showHomeBtn : Boolean = false;
		public var showBackBtn : Boolean = false;
		public var backBtnEventType : String;
		
		public var _screenWidth : Number;
		public var _screenHeight : Number;
		
		protected var instructionsText : Text;
		protected var listLimit : uint = 15;
		protected var listSource : Array;
		private var listPages : uint;
		protected var list : AthletesList;
		protected var currentPage : uint = 1;
		[Bindable]
		protected var currentProvider : ArrayCollection;
		
		protected var backBtn : Button;
		protected var nextBtn : Button;
		protected var homeBtn : Button; 
		
		protected var backgroundImage : Image;
		private var _settings : ScreenSettings;
		
		protected var logo : Label;
		public static const screenlabelX : Number = 113;
		public static const screenlabelY : Number = 30;
		
		protected var sortButtons : SortBar;
		
		public function get settings() : ScreenSettings
		{
			return _settings;
		}
		
		public function set pages(value : uint) : void
		{
			listPages = value;
		}
		
		public function get pages() : uint
		{
			return listPages;
		}
		
		public function ScreenView(value : ScreenSettings, _scrWidth : Number, _scrHeight : Number)
		{
			_settings = value;
			
			_screenWidth = _scrWidth;
			_screenHeight = _scrHeight;
			
			measuredWidth = _scrWidth;
			measuredHeight = _scrHeight;
			width = _scrWidth;
			height = _scrHeight;
			
			addEventListener(FlexEvent.CREATION_COMPLETE, CreationComplete);
		}
		
		private function CreationComplete(e : FlexEvent) : void
		{
			if(list != null)
				EnableSortBar(list.list.dataProvider as ArrayCollection);
		}
		
		public function draw() : void
		{
			if(showBackBtn)
			{
				backBtn = new Button();
				backBtn.addEventListener(MouseEvent.CLICK, BackClicked);
				backBtn.setStyle('skinClass',BackButtonSkin);
				backBtn.useHandCursor = true;
				backBtn.x = 83;
				backBtn.y = 764;
				addElement(backBtn);
			}
			
			if(showHomeBtn)
			{
				homeBtn = new Button();
				homeBtn.addEventListener(MouseEvent.CLICK, HomeClicked);
				homeBtn.setStyle('skinClass',HomeButtonSkin);
				homeBtn.useHandCursor = true;
				homeBtn.x = 144 + 120;
				homeBtn.y = 764;
				addElement(homeBtn);
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			DrawBG();
			DrawTopLogo();
			draw();
		}
		
		protected function DrawBG(): void
		{
			backgroundImage = new Image();
			backgroundImage.percentWidth = measuredWidth;
			backgroundImage.percentHeight = measuredHeight;
			backgroundImage.x = 0;
			backgroundImage.y = 0;		
			backgroundImage.scaleMode = BitmapFillMode.SCALE;
			backgroundImage.source = cdmeyer.APP_PATH + _settings.botBackgroundImage;
			addElement(backgroundImage);
		}
		

		protected function DrawList() : void
		{
			list.list.dataProvider = new ArrayCollection();
			sortButtons.currentFilter = '';
			sortButtons.addSortListeners(list);
			
			var len : uint = Controller.getInstance().athletes.length;
			for(var i:uint=0;i<len;i++)
			{
				var item : Athlete = Controller.getInstance().athletes[i];
				if(HasItem(list.list.dataProvider, item))
				{
					item.fN = '';
					item.lN = '';			
				}
				list.list.dataProvider.addItem(item);
			}
			
			
			list.list.scroller.verticalScrollBar.value = 0;
			
			
			EnableSortBar(list.list.dataProvider as ArrayCollection);
		}
		
		protected function EnableSortBar(data : ArrayCollection) : void
		{
			if(sortButtons == null)
				return;
			var len : uint = sortButtons.numElements;
			
			for(var i:uint =0;i<len;i++)
			{
				if(sortButtons.getElementAt(i) is Button)
					Button(sortButtons.getElementAt(i)).enabled = false;	
			}
			
			for each(var item : Athlete in data)
			{
				CheckListItem(item);
			}
		}
		
		protected function CheckListItem(item : Athlete) : void
		{
			var len : uint = sortButtons.numElements;
			
			for(var i:uint =0;i<len;i++)
			{
				if(sortButtons.getElementAt(i) is Button)
				{
					var btn : Button = sortButtons.getElementAt(i) as Button;
					var f : String = btn.id.substr(0,1);
					var s : String = btn.id.substr(1,1);
					if(String(item.lastName).toLowerCase().indexOf(f) == 0 ||
						String(item.lastName).toLowerCase().indexOf(s) == 0)
							Button(sortButtons.getElementAt(i)).enabled = true;
//					else					
//						Button(sortButtons.getElementAt(i)).enabled = false;	
				}
			}
		}
		
		protected function HasItem(list : IList, item : Athlete) : Boolean
		{
			var len : uint = list.length;
			for (var i:uint=0; i<len; i++)
			{
				var a : Athlete = list.getItemAt(i) as Athlete;
				if(a.firstName == item.firstName && a.lastName == item.lastName)
					return true;
			}
			
			return false;
		}
				
		protected function DrawInstructions() : void
		{
			instructionsText = new Text();
			instructionsText.text = settings.instructions;
			instructionsText.setStyle('fontFamily',"Swis721CnBTnonCFF");
			instructionsText.setStyle('fontSize', 36);
			instructionsText.setStyle('color', 0xffffff);
			instructionsText.x = ScreenView.instructionsX;
			instructionsText.y = ScreenView.instructionsY;
			instructionsText.width = ScreenView.instructionsWidth;
			instructionsText.height = ScreenView.instructionsHeight;
			instructionsText.selectable = false;
			addElement(instructionsText);
		}
		
		
		/*
		* overrided in top screen instance
		* */
		protected function DrawTopLogo() : void
		{
			
		}
		
		protected function BackClicked(e : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));
			dispatchEvent(new CDMeyerEvent(backBtnEventType));
		}
		
		private function HomeClicked(event : MouseEvent) : void
		{
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.PLAY_BTN_SOUND, true));
			dispatchEvent(new CDMeyerEvent(CDMeyerEvent.SHOW_MAIN_SCREEN));
		}
	}
}