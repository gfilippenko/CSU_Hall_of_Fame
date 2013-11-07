package com.blogspot.jaggerm.cdmeyer.views.screens.sports
{
	import com.blogspot.jaggerm.cdmeyer.Controller;
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.Athlete;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleLabel.CircleLabel;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	
	import spark.components.Label;
	
	public class SportScreen extends ScreenView
	{
		private var _label : String;
		private var _labelChanged : Boolean = false;
		
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
		
		public function SportScreen(value:ScreenSettings, _scrWidth:Number, _scrHeight:Number)
		{
			super(value, _scrWidth, _scrHeight);
			showBackBtn = true;
			backBtnEventType = CDMeyerEvent.SHOW_SPORTS_SCREEN;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(logo != null)
			{
				if(_labelChanged)			
				{
					logo.text = label;
					DrawList();	
					_labelChanged = false;
				}
			}			
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
			addElement(logo);
			
			list = new AthletesList();
			list.x = _screenWidth - ScreenView.listWidth - 20;
			list.y = _screenHeight - ScreenView.listHeight - 20;
			list.list.dataProvider = new ArrayCollection();
			addElement(list);
		}
		
		override protected function DrawList() : void
		{
			ArrayCollection(list.list.dataProvider).disableAutoUpdate();
			list.list.dataProvider.removeAll();
			
			for each(var item : Athlete in Controller.getInstance().athletes)
			{
				if(item.sport.toUpperCase() == label.toUpperCase())
					list.list.dataProvider.addItem(item);
			}
			
			ArrayCollection(list.list.dataProvider).enableAutoUpdate();
		}
	}
}