package HierachicalADG.utils 
{
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DataGrid;
	
	/** Based on http://coockbooks.adobe.com/post_Copying_a_datagrid_data_to_the_clipboard_for_Excel-9883.html
	 * 
	 **/
	public class DataGridUtil
	{	
		protected static var tabDelimiter:String = "\t";
		protected static var commaDelimiter:String = ","; 
		protected static var newLine:String = "\n";						
		
		public static function exportDGToClipboard (grid:DataGrid, csv:Boolean = true, onlySelected:Boolean = true):void
		{
			System.setClipboard(exportDGToCSV (grid, csv, onlySelected));
		}
		
		public static function exportADGToClipboard (grid:AdvancedDataGrid, csv:Boolean = true, onlySelected:Boolean = true):void
		{
			System.setClipboard(exportADGToCSV (grid, csv, onlySelected));
		}
		
		public static function exportDGToCSV (grid:DataGrid, csv:Boolean = true, onlySelected:Boolean = true):String
		{
			return exportGridToCSV (grid, csv, onlySelected);
		}				
		
		public static function exportADGToCSV (grid:AdvancedDataGrid, csv:Boolean = true, onlySelected:Boolean = true):String
		{
			return exportGridToCSV (grid, csv, onlySelected);
		}
		
		protected static function exportGridToCSV (grid:Object, csv:Boolean, onlySelected:Boolean):String
		{
			var dataSource:ICollectionView = (onlySelected ? new ArrayCollection (grid.selectedItems) : grid.dataProvider) as ICollectionView;
			
			var headers:String = "";		
			var delimiter:String = ""
			
			if (csv)	
				delimiter = commaDelimiter;
			else
				delimiter = tabDelimiter;
			
			//build header
			for each (var hcol:Object in grid.columns)//coltypes differe between DG & ADG
			{
				if (headers.length > 0)//avoid firstcolumn having extra delimeter
					headers += delimiter;					
				
				headers += hcol.headerText;			
			}
			headers += newLine;
			
			//populate data
			var cursor:IViewCursor = dataSource.createCursor();
			var data:String = "";
			var item:Object;
			var itemData:String;
			
			do 
			{
				item = cursor.current;
				itemData = "";
				
				for each (var col:Object in grid.columns)
				{
					if (itemData.length > 0)	//avoid firstcolumn having extra delimeter				
						itemData += delimiter;
					
					itemData += col.itemToLabel(item);					
				}
				
				data += itemData +newLine;
			}while (cursor.moveNext())
			
			return headers + data;
		} 						
	}
}