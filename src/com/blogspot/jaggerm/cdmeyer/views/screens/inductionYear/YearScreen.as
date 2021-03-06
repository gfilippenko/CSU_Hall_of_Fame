package com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleLabel.CircleLabel;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	import com.blogspot.jaggerm.cdmeyer.views.list.SortBar;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.states.OverrideBase;
	
	import spark.components.Label;
	
	public class YearScreen extends ScreenView
	{
		private var _label : String;
		private var _labelChanged : Boolean = false;
//		private var sortButtons : SortBar;
		
		[Bindable]
		public function set label(value : String) : void
		{
			if(_label != value)
			{
				_label = value;
				_labelChanged = true;
				invalidateProperties();
			}
		}
		
		public function get label() : String
		{
			return _label;
		}
		
		public function YearScreen(value:ScreenSettings, _scrWidth:Number, _scrHeight:Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_YEARS_OF_DECADE;
			showHomeBtn = true;
//			addEventListener(Event.ADDED_TO_STAGE, Added);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(logo != null)
				if(_labelChanged)
				{
					logo.text = label;
					DrawList();
					_labelChanged = false;
				}
		}
		
		private function Added(e : Event) : void
		{
			if(list != null)
				DrawList();
		}
		
		override public function draw() : void
		{
			super.draw();
			
			if(settings.instructions != '')
			{
				DrawInstructions();
			}
			
			logo = new Label();
			logo.setStyle('fontFamily',"Swis721CnBT");
			logo.setStyle('fontWeight', "bold");
			logo.setStyle('fontSize', 104);
			logo.setStyle('color', 0xffffff);
			logo.x = ScreenView.screenlabelX;
			logo.y = ScreenView.screenlabelY;
			logo.text = label;
			addElement(logo);
			
			list = new AthletesList();
			list.x = 630;
			list.y = 3;			
			list.list.dataProvider = new ArrayCollection();
			addElement(list);
			
			sortButtons = new SortBar();
			sortButtons.x = 633;
			sortButtons.y = 840;
			sortButtons.addSortListeners(list);
			sortButtons.addEventListener(CDMeyerEvent.CLICK_SORT_BUTTON, onClickSortButton);
			addElement(sortButtons);
		}
		
		override protected function DrawList() : void
		{
			list.list.dataProvider = new ArrayCollection();
			sortButtons.currentFilter = '';
			sortButtons.addSortListeners(list);			
			ArrayCollection(list.list.dataProvider).disableAutoUpdate();
			var len : uint = Controller.getInstance().athletes.length;
			for(var i:uint=0;i<len;i++)
			{
				var item : Athlete = Controller.getInstance().athletes[i];
				if(HasItem(list.list.dataProvider, item))
				{
					item.fN = '';
					item.lN = '';
				}
				
				if(item.year.toUpperCase() == label.toUpperCase())
					list.list.dataProvider.addItem(item);
			}

//			list.list.scroller.verticalScrollBar.value = 0;
			var columnIndexes:Vector.<int> = Vector.<int>([ 2 ]);
			list.list.sortByColumns(columnIndexes, true);
			ArrayCollection(list.list.dataProvider).enableAutoUpdate();
			EnableSortBar(list.list.dataProvider as ArrayCollection);
		}
	}
}