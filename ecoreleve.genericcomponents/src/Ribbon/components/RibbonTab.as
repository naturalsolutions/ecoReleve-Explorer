package Ribbon.components
{
	import mx.controls.TabBar;

	public class RibbonTab extends TabBar
	{
		private var TabStyleName:String="styleRibbonTab";
		
		public function RibbonTab()
		{
			super();
			this.styleName=TabStyleName;
		}
				
	}
}