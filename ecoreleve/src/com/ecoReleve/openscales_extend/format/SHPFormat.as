package com.ecoReleve.openscales_extend.format
{
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpHeader;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpPoint;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpPolygon;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpPolyline;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpRecord;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpTools;
	import com.ecoReleve.openscales_extend.format.vanrijkom.SHP.ShpType;
	import com.ecoReleve.openscales_extend.format.vanrijkom.DBF.DbfHeader;
	import com.ecoReleve.openscales_extend.format.vanrijkom.DBF.DbfTools;
	import com.ecoReleve.openscales_extend.format.vanrijkom.DBF.DbfRecord;
	
	import flash.utils.ByteArray;
	
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.format.Format;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.proj4as.ProjProjection;
	
	/**
	 * READ SHAPEFILE FORMAT 
	 */
	public class SHPFormat extends Format
	{
		private var _proxy:String;
		private var _features:Vector.<Feature> = new Vector.<Feature>();
		
		public function SHPFormat()
		{
			super();
		}
		
		public function set proxy(value:String):void 
		{
			this._proxy = value;
		}
		
		private function loadPolyline(shapArray:Array,dbfArray:Array):void 
		{       
			var arrayComponents:Vector.<Number>;
			var arrayVertices:Vector.<Geometry>;    
			var point:Point;
			_features.slice(0,_features.length)
			
			for each(var record:ShpRecord in shapArray) {
				var line:ShpPolyline=record.shape as ShpPolyline;
				for each(var ring:Array in (record.shape as ShpPolygon).rings) {
					arrayVertices= new Vector.<Geometry>();
					arrayComponents = new Vector.<Number>();
					for each (var shapePoint:ShpPoint in ring) {
						point = new Point(shapePoint.x, shapePoint.y);
						if (this._internalProj != null, this._externalProj != null) {
							point.transform(this.externalProj, this.internalProj);
						}
						arrayComponents.push(point.x,point.y)   
					}
					
					arrayVertices.push(new LinearRing(arrayComponents));
					var ln:LineString=new LineString(arrayComponents)
					
					/* loop over DBF records,find matching ID and create attributes*/
					var attributes:Object = new Object();
					var dbfRec:DbfRecord=dbfArray[record.number-1] as DbfRecord
					for (var key:String in dbfRec.values){
						attributes[key] = dbfRec.values[key];
					}
					
					var pFeat:LineStringFeature=new LineStringFeature(ln)
					pFeat.attributes=attributes
					_features.push(pFeat)   
				}
			}
			
			
			
		}
		
		private function loadPoint(shapArray:Array,dbfArray:Array):void 
		{
			var point:Point;
			_features.slice(0,_features.length)
			
			for each(var record:ShpRecord in shapArray) {
				var pt:ShpPoint=record.shape as ShpPoint;
				point = new Point(pt.x, pt.y);
				if (this._internalProj != null, this._externalProj != null) {
					point.transform(this.externalProj, this.internalProj);
				}
				
				/* loop over DBF records,find matching ID and create attributes*/
				var attributes:Object = new Object();
				var dbfRec:DbfRecord=dbfArray[record.number-1] as DbfRecord
				for (var key:String in dbfRec.values){
					attributes[key] = dbfRec.values[key];
				}
				
				var pFeat:PointFeature=new PointFeature(point)
				pFeat.attributes=attributes
				_features.push(pFeat)
			}
		}
		
		private function loadPolygons(shapArray:Array,dbfArray:Array):void 
		{
			var arrayComponents:Vector.<Number>;
			var arrayVertices:Vector.<Geometry>;
			var point:Point;
			_features.slice(0,_features.length)
			
			for each(var record:ShpRecord in shapArray) {
				var polygon:ShpPolygon = record.shape as ShpPolygon;
				for each(var ring:Array in (record.shape as ShpPolygon).rings) {
					arrayVertices= new Vector.<Geometry>();
					arrayComponents = new Vector.<Number>();
					for each (var shapePoint:ShpPoint in ring) {                            
						point = new Point(shapePoint.x, shapePoint.y);
						if (this._internalProj != null, this._externalProj != null) {
							point.transform(this.externalProj, this.internalProj);
						}
						arrayComponents.push(point.x,point.y)
					}
					arrayVertices.push(new LinearRing(arrayComponents));
					var poly:Polygon=new Polygon(arrayVertices)
					
					/* loop over DBF records,find matching ID and create attributes*/
					var attributes:Object = new Object();
					var dbfRec:DbfRecord=dbfArray[record.number-1] as DbfRecord
					for (var key:String in dbfRec.values){
						attributes[key] = dbfRec.values[key];
					}
					
					var pFeat:PolygonFeature=new PolygonFeature(poly)
					pFeat.attributes=attributes
					_features.push(pFeat)
				}
			}
		}
		
		
		override public function read(data:Object):Object 
		{
			var shpBytes:ByteArray=data[0] as ByteArray
			var dbfBytes:ByteArray=data[1] as ByteArray
			
			var shp:ShpHeader=new ShpHeader(shpBytes)                       
			var shapArray:Array = ShpTools.readRecords(shpBytes);
			
			var header:DbfHeader = new DbfHeader(dbfBytes);
			var dbfArray:Array=new Array()
			for(var i:Number = 0; i < header.recordCount; i++) {
				dbfArray.push(DbfTools.getRecord(dbfBytes,header,i));
			}
			
			if (shp.shapeType == ShpType.SHAPE_POLYGON){                            
				trace('polygon')
				loadPolygons(shapArray,dbfArray)
			} else if (shp.shapeType == ShpType.SHAPE_POLYLINE){
				trace('polyline')
				loadPolyline(shapArray,dbfArray)
			} else if (shp.shapeType == ShpType.SHAPE_POINT){
				trace('point')
				loadPoint(shapArray,dbfArray)
			}
			
			return _features;
		}
		
		public function get features():Vector.<Feature>
		{
			return _features;
		}
		
		public function set features(value:Vector.<Feature>):void
		{
			_features = value;
		}
		
		public function get internalProj():ProjProjection 
		{
			return this._internalProj;
		}
		
		public function set internalProj(value:ProjProjection):void 
		{
			this._internalProj = value;
		}
		
		public function get externalProj():ProjProjection {
			return this._externalProj;
		}
		
		public function set externalProj(value:ProjProjection):void 
		{
			this._externalProj = value;
		}
	}
}
