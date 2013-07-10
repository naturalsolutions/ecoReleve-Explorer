package com.ecoReleve.view.myFilter
{
    import org.openscales.core.feature.Feature;
    import org.openscales.core.filter.IFilter;
    
    public class AttributesFilter implements IFilter
    {
        private var att:String=""
        
        public function AttributesFilter(strAtt:String) 
		{
            this.att = strAtt;
        }
        
        public function matches(feature:Feature):Boolean 
		{
            return (feature.attributes["LyrHandle"]==att);
        }
		
		public function clone():IFilter
		{
			var AttributesFilter:AttributesFilter = new AttributesFilter(this.att);
			return AttributesFilter;
		}
        
    }
}
