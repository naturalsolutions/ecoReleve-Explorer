<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="RELEVES">
<gpx
	version="1.1"
	creator="eReleve"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://www.topografix.com/GPX/1/1"
	xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">

<xsl:for-each select="RELEVE">

<!-- ajoute lat et lon en attribut du noeud wpt -->

<wpt>
<xsl:attribute name="lat"><xsl:value-of select="LATITUDE"/></xsl:attribute>
<xsl:attribute name="lon"><xsl:value-of select="LONGITUDE"/></xsl:attribute>  
<ele><xsl:value-of select="ELEVATION"/></ele>

<!-- Change le format de date de JJ/MM/AAAA HH:MM:ss en AAAA-MM-JJTHH:MM:SSZ -->
<xsl:element name="time">
<xsl:call-template name="FormatDate">
<xsl:with-param name="Date" select="DATE"/>
 </xsl:call-template>
</xsl:element>

<!-- commentaire -->
<cmt><xsl:value-of select="COMMENTS"/></cmt>

<!-- description -->
<desc><xsl:text>Source: </xsl:text><xsl:value-of select="SOURCE"/></desc> 

</wpt>

</xsl:for-each>
</gpx>

</xsl:template>

<!-- TEMPLATE pour formater la date-->
<xsl:template name="FormatDate">
 <xsl:param name="Date"/>
 
<xsl:variable name="day">
<xsl:value-of select="substring($Date,1,2)" />
</xsl:variable>
<xsl:variable name="temp1">
<xsl:value-of select="substring-after($Date,'/')" />
</xsl:variable>
<xsl:variable name="month">
<xsl:value-of select="substring($temp1,1,2)" />
</xsl:variable>
<xsl:variable name="temp2">
<xsl:value-of select="substring-after($temp1,'/')" />
</xsl:variable>
<xsl:variable name="year">
<xsl:value-of select="substring-before($temp2,' ')" />
</xsl:variable>
<xsl:variable name="time">
<xsl:value-of select="substring-after($temp1,' ')" />
</xsl:variable>
 
    
<xsl:value-of select="$year"/>
<xsl:value-of select="'-'"/>
<xsl:value-of select="$month"/>
<xsl:value-of select="'-'"/>
<xsl:value-of select="$day"/>
<xsl:value-of select="'T'"/>
<xsl:value-of select="$time"/>
<xsl:value-of select="'Z'"/>
</xsl:template>


</xsl:stylesheet>


 
