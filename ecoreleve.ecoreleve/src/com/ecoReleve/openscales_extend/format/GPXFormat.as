package com.ecoReleve.openscales_extend.format 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openscales.core.feature.CustomMarker;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.feature.LineStringFeature;
	import org.openscales.core.feature.PointFeature;
	import org.openscales.core.feature.PolygonFeature;
	import org.openscales.core.request.DataRequest;
	import org.openscales.core.style.Rule;
	import org.openscales.core.style.Style;
	import org.openscales.core.style.fill.SolidFill;
	import org.openscales.core.style.marker.WellKnownMarker;
	import org.openscales.core.style.stroke.Stroke;
	import org.openscales.core.style.symbolizer.LineSymbolizer;
	import org.openscales.core.style.symbolizer.PointSymbolizer;
	import org.openscales.core.style.symbolizer.PolygonSymbolizer;
	import org.openscales.geometry.Geometry;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.LinearRing;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.Polygon;
	import org.openscales.geometry.basetypes.Location;
	import org.openscales.proj4as.ProjProjection;
	import org.openscales.core.format.Format;               
	
	/**
	 * Read KML 2.0 and 2.2 file format.
	 */
	public class GPXFormat extends Format
	{
		private namespace opengis="http://www.opengis.net/kml/2.2";
		private namespace google="http://earth.google.com/kml/2.0";
		private namespace gpx10="http://www.topografix.com/GPX/1/0";
		private namespace gpx11="http://www.topografix.com/GPX/1/1";
		private namespace gpxx2="http://www.garmin.com/xmlschemas/GpxExtensions/v2";
		private namespace gpxx3="http://www.garmin.com/xmlschemas/GpxExtensions/v3"
			
			private var _proxy:String;
		private var _externalImages:Object = {};
		private var _images:Object = {};
		
		private var _defaultImage:Class;
		
		// features
		private var iconsfeatures:Vector.<Feature> = new Vector.<Feature>();
		private var linesfeatures:Vector.<Feature> = new Vector.<Feature>();
		private var _features:Vector.<Feature> = new Vector.<Feature>();
		
		// styles
		private var lineStyles:Object = new Object();
		private var pointStyles:Object = new Object();
		
		public function GPXFormat() {
		}
		
		public function set proxy(value:String):void {
			this._proxy = value;
		}
		
		/**
		 * return the RGB color of a Garmin color
		 */
		private function GarminColorsToRGB(data:String):Number 
		{
			
			/* "Black", "DarkRed", "DarkGreen", "DarkYellow", "DarkBlue", "DarkMagenta", "DarkCyan"
			"LightGray", "DarkGray"
			"Red", "Green", "Yellow", "Blue", "Magenta", "Cyan"
			"White", "Transparent"
			*/
			
			var myColor:String = "000000"; // Black by default
			
			if (data == "Green") {
				myColor = "00FF00";
			}else if (data == "Blue") {
				myColor = "0000FF";
			}else if (data == "Red") {
				myColor = "FF0000";
			}else if (data == "White") {
				myColor = "FFFFFF";
			}else if (data == "Yellow") {
				myColor = "FFFF00";
			}else if (data == "Magenta") {
				myColor = "FF00FF";
			}else if (data == "Cyan") {
				myColor = "00FFFF";
			}else if (data == "Transparent") {
				myColor = "FFFFFF";
			}                               
			return parseInt(myColor, 16);
		}
		
		/**
		 * Return the alpha part of a Garmin color
		 */
		private function GarminColorsToAlpha(data:String):Number 
		{
			/* "Black", "DarkRed", "DarkGreen", "DarkYellow", "DarkBlue", "DarkMagenta", "DarkCyan"
			"LightGray", "DarkGray"
			"Red", "Green", "Yellow", "Blue", "Magenta", "Cyan"
			"White", "Transparent"
			*/
			
			if (data == "Transparent") {
				return 0.0;
			}else {
				return 1.0;
			};
		}
		
		private function updateImages(e:Event):void 
		{
			var _url:String = e.target.loader.name;
			var _imgs:Array = _images[_url];
			_images[_url] = null;
			var _bm:Bitmap = Bitmap(_externalImages[_url].loader.content);
			var _bmd:BitmapData = _bm.bitmapData;
			for each(var _img:Sprite in _imgs) {
				var _image:Bitmap = new Bitmap(_bmd.clone());
				_image.x = -_image.width/2;
				_image.y = -_image.height;
				_img.addChild(_image);
			}
		}
		
		private function updateImagesError(e:Event):void 
		{
			var _url:String = e.target.loader.name;
			var _imgs:Array = _images[_url];
			_images[_url] = null;
			_externalImages[_url] = null;
			
			for each(var _img:Sprite in _imgs) {
				var _marker:Bitmap = new _defaultImage();
				_marker.y = -_marker.height;
				_marker.x = -_marker.width/2;
				_img.addChild(_marker);
			}
		}
		
		/**
		 * load styles
		 */
		private function loadStyles(styles:XMLList):void 
		{
			
			use namespace google;
			use namespace opengis;
			
			for each(var style:XML in styles) {
				var id:String = "";
				if(style.@id=="")
					continue;
				id = "#"+style.@id.toString();
				
				var color:Number;
				var alpha:Number=1;
				if(style.color != undefined) {
					color = GarminColorsToRGB(style.color.text());
					alpha = GarminColorsToAlpha(style.color.text())
				}
				
				if(style.IconStyle != undefined) {
					pointStyles[id] = new Object();
					pointStyles[id]["icon"] = null
					if(style.IconStyle.Icon != undefined && style.IconStyle.Icon.href != undefined) {
						try {
							var _url:String = style.IconStyle.Icon.href.text();
							var _req:DataRequest;
							_req = new DataRequest(_url, updateImages, updateImagesError);
							_req.proxy = this._proxy;
							//_req.security = this._security; // FixMe: should the security be managed here ?
							_req.send();
							_externalImages[_url] = _req;
							pointStyles[id]["icon"] = _url;
							_images[_url] = new Array();
						} catch(e:Error) {
							pointStyles[id]["icon"] = null;
						}
					}
					if(style.IconStyle.color != undefined) {
						pointStyles[id]["color"] = GarminColorsToRGB(style.IconStyle.color.text());
						pointStyles[id]["alpha"] = GarminColorsToAlpha(style.IconStyle.color.text());
					}
					if(style.IconStyle.scale != undefined)
						pointStyles[id]["scale"] = Number(style.IconStyle.scale.text());
					if(style.IconStyle.heading != undefined) //0 to 360°
						pointStyles[id]["rotation"] = Number(style.IconStyle.headingtext());
					// TODO implement offset support + rotation effect
				}
			}
		}
		
		/**
		 * load placemarks
		 */
		private function loadPlacemarks(placemarks:XMLList):void {
			
			use namespace google;
			use namespace opengis;
			
			for each(var placemark:XML in placemarks) {
				var coordinates:Array;
				var point:Point;
				var htmlContent:String = "";
				var attributes:Object = new Object();
				
				if(placemark.name != undefined) {
					attributes["name"] = placemark.name.text();
					htmlContent = htmlContent + "<b>" + placemark.name.text() + "</b><br />";
				}
				
				if(placemark.description != undefined) {
					attributes["description"] = placemark.description.text();
					htmlContent = htmlContent + placemark.description.text() + "<br />";
				}
				
				for each(var extendedData:XML in placemark.ExtendedData.Data) {
					if(extendedData.value)
						attributes[extendedData.@name] = extendedData.value.text();
					htmlContent = htmlContent + "<b>" + extendedData.@name + "</b> : " + extendedData.value.text() + "<br />";
				}
				attributes["popupContentHTML"] = htmlContent;
				
				var _id:String;
				
				//Waypoints
				if(placemark.Point != undefined)
				{
					coordinates = placemark.Point.coordinates.text().split(",");
					point = new Point(coordinates[0], coordinates[1]);
					if (this._internalProj != null, this._externalProj != null) {
						point.transform(this.externalProj, this.internalProj);
					}
					var loc:Location;
					if(placemark.styleUrl != undefined) {
						_id = placemark.styleUrl.text();
						if(pointStyles[_id] != undefined) { // style
							if(pointStyles[_id]["icon"]!=null) { // icon
								var _icon:String = pointStyles[_id]["icon"];
								var customMarker:CustomMarker;
								if(_images[_icon]!=null) { // image not loaded so we will wait for it
									var _img:Sprite = new Sprite();
									_images[_icon].push(_img);
									loc = new Location(point.x,point.y);
									customMarker = CustomMarker.createDisplayObjectMarker(_img,loc,attributes,0,0);
								}
								else if(_externalImages[_icon]!=null) { // image allready loaded, we copy the loader content
									var Image:Bitmap = new Bitmap(new Bitmap(_externalImages[_icon].loader.content).bitmapData.clone());
									Image.y = -Image.height;
									Image.x = -Image.width/2;
									customMarker = CustomMarker.createDisplayObjectMarker(Image,new Location(point.x,point.y),attributes,0,0);
								}
								else { // image failed to load
									var _marker:Bitmap = new _defaultImage();
									_marker.y = -_marker.height;
									_marker.x = -_marker.width/2;
									customMarker = CustomMarker.createDisplayObjectMarker(_marker,new Location(point.x,point.y),attributes,0,0);
								}
								iconsfeatures.push(customMarker);
							}
							else { // style without icon
								var _style:Style = Style.getDefaultPointStyle()
								if(pointStyles[_id]["color"] != undefined)
								{
									var _fill:SolidFill = new SolidFill(pointStyles[_id]["color"], pointStyles[_id]["alpha"]);
									var _stroke:Stroke = new Stroke(pointStyles[_id]["color"], pointStyles[_id]["alpha"]);
									var _mark:WellKnownMarker = new WellKnownMarker(WellKnownMarker.WKN_SQUARE, _fill, _stroke);
									var _symbolizer:PointSymbolizer = new PointSymbolizer();
									_symbolizer.graphic = _mark;
									var _rule:Rule = new Rule();
									_rule.name = _id;
									_rule.symbolizers.push(_symbolizer);
									_style = new Style();
									_style.name = _id;
									_style.rules.push(_rule);
								}
								iconsfeatures.push(new PointFeature(point, attributes, _style));
							}
						}
						else // no matching style
							iconsfeatures.push(new PointFeature(point, attributes, Style.getDefaultPointStyle()));
					}
					else // no style
						iconsfeatures.push(new PointFeature(point, attributes, Style.getDefaultPointStyle()));
				} // end if point
			}
			import org.openscales.core.feature.LineStringFeature;
			import org.openscales.core.feature.PointFeature;
			import org.openscales.geometry.Point;
			
		} // end of loadPlacemarks
		
		/**
		 * load waypoints
		 */
		
		private function loadWaypoints(waypoints:XMLList):void {
			
			use namespace gpx10;
			use namespace gpx11;
			
			var point:Point;
			var _style:Style = Style.getDefaultPointStyle()
			for each(var waypoint:XML in waypoints) {
				var htmlContent:String = "";
				var attributes:Object = new Object();
				if(waypoint.name != undefined) {
					attributes["name"] = waypoint.name.text();
					htmlContent = htmlContent + "<b>" + waypoint.name.text() + "</b><br />";
				}
				if(waypoint.desc != undefined) {
					attributes["description"] = waypoint.description.text();
					htmlContent = htmlContent + waypoint.description.text() + "<br />";
				}
				// TODO: more attributes here
				attributes["popupContentHTML"] = htmlContent;
				point = new Point(waypoint.@lon, waypoint.@lat);
				if (this._internalProj != null, this._externalProj != null) {
					point.transform(this.externalProj, this.internalProj);
				}
				
				iconsfeatures.push(new PointFeature(point,null,_style));
			}
		}
		
		/**
		 * load track segments
		 */
		private function loadTrackSegments(tracksegs:XMLList, lstyle:Style):void {
			
			use namespace gpx10;
			use namespace gpx11;
			
			var point:Point;
			for each(var trackseg:XML in tracksegs) {
				var trackpoints:XMLList = trackseg.trkpt;
				var points:Vector.<Number> = new Vector.<Number>();
				for each(var trackpoint:XML in trackpoints) {
					point = new Point(trackpoint.@lon, trackpoint.@lat);
					if (this._internalProj != null, this._externalProj != null) {
						point.transform(this.externalProj, this.internalProj);
					}
					points.push(point.x);
					points.push(point.y);
				}
				var line:LineString = new LineString(points);
				var lsf:LineStringFeature=new LineStringFeature(line, null, lstyle);
				lsf.attributes["length"]=lsf.geometry.length
				//TO DO calculate duration
				lsf.attributes["duration"]=null	
				linesfeatures.push(lsf);
			}
		}
		
		/**
		 * load tracks
		 */
		private function loadTracks(tracks:XMLList):void {
			
			use namespace gpx10;
			use namespace gpx11;
			use namespace gpxx2;
			use namespace gpxx3;
			
			for each(var track:XML in tracks) {
				var lstyle:Style = Style.getDefaultLineStyle();
				var gdc:String = track.extensions.TrackExtension.DisplayColor.text();
				if (gdc != "") {
					var Lcolor:Number = GarminColorsToRGB(gdc);
					var Lalpha:Number = GarminColorsToAlpha(gdc);
					var Lwidth:Number = 3;
					var Lrule:Rule = new Rule();
					Lrule.name = gdc;
					if (gdc == "Transparent") {
						// Just a wide translucent Black stripe
						Lrule.symbolizers.push(new LineSymbolizer(new Stroke(0.0, Lwidth + 2, 0.2)));
					}
					else {
						// First a wider solid Black stripe
						Lrule.symbolizers.push(new LineSymbolizer(new Stroke(0.0, Lwidth + 2, 1.0)));
						// Then overlayed with a narrower stripe of the right colour
						Lrule.symbolizers.push(new LineSymbolizer(new Stroke(Lcolor, Lwidth, Lalpha)));
					}
					lstyle = new Style();
					lstyle.name = gdc;
					lstyle.rules.push(Lrule);
				}
				var trackSegs:XMLList = track.trkseg;
				loadTrackSegments(trackSegs, lstyle);
			}
		}
		
		/**
		 * Read data
		 *
		 * @param data data to read/parse.
		 *
		 * @return array of features.
		 */
		override public function read(data:Object):Object {
			var dataXML:XML = data as XML;
			use namespace gpx10;
			use namespace gpx11;
			
			var tracks:XMLList = dataXML..trk;
			loadTracks(tracks);
			
			var waypoints:XMLList = dataXML.wpt;
			loadWaypoints(waypoints);
			
			_features = linesfeatures.concat(iconsfeatures);
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
		
		public function get internalProj():ProjProjection {
			return this._internalProj;
		}
		
		public function set internalProj(value:ProjProjection):void {
			this._internalProj = value;
		}
		
		public function get externalProj():ProjProjection {
			return this._externalProj;
		}
		
		public function set externalProj(value:ProjProjection):void {
			this._externalProj = value;
		}
		
	}
}
