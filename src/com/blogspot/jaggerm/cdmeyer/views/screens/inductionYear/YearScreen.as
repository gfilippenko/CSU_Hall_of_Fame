package com.blogspot.jaggerm.cdmeyer.views.screens.inductionYear
{
	import com.blogspot.jaggerm.cdmeyer.events.CDMeyerEvent;
	import com.blogspot.jaggerm.cdmeyer.model.ScreenSettings;
	import com.blogspot.jaggerm.cdmeyer.views.ScreenView;
	import com.blogspot.jaggerm.cdmeyer.views.circleLabel.CircleLabel;
	import com.blogspot.jaggerm.cdmeyer.views.list.AthletesList;
	
	import mx.collections.ArrayCollection;
	
	public class YearScreen extends ScreenView
	{
		private var _label : String;
		private var _labelChanged : Boolean = false;
		private var logo : CircleLabel;
		
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
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(logo != null)
				if(_labelChanged)
				{
					logo.lbl.text = label;
				}
		}
		
		override public function draw() : void
		{
			super.draw();
			
			if(settings.instructions != '')
			{
				DrawInstructions();
			}
			
			logo = new CircleLabel();
			logo.x = 50;
			logo.y = ScreenView.instructionsHeight  + 50;
			logo.lbl.text = label;
			//BindingUtils.bindProperty(logo.lbl, 'text', this, label);
			addElement(logo);
			
			list = new AthletesList();
			list.x = _screenWidth - ScreenView.listWidth - 20;
			list.y = _screenHeight - ScreenView.listHeight - 20;			
			
			currentProvider = new ArrayCollection();
			addElement(list);
		}
	}
}