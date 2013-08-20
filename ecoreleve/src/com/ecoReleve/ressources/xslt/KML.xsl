<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="RELEVES">
<kml xmlns="http://earth.google.com/kml/2.1">
<Document>

<!-- ********************************************************
          Création des points (regroupé dans un dossier)
 ************************************************************ -->


<Folder>  
<name>Stations</name> 

<xsl:for-each select="RELEVE">
<Placemark>
<styleUrl>#MyStyle</styleUrl>
<name>
<xsl:value-of select="NAME"/>
</name>

<!-- Change le format de date de JJ/MM/AAAA HH:MM:SS en AAAA-MM-JJTHH:MM:SSZ -->
<TimeStamp>
<xsl:call-template name="FormatDate">
	<xsl:with-param name="Date" select="DATE"/>
</xsl:call-template>
</TimeStamp>
<description> 
<!-- &lt;br/&gt;  -->
<![CDATA[<B>STATION</B><br/>]]>
Date:<xsl:value-of select="DATE"/><![CDATA[<br/>]]>
Species name:<xsl:value-of select="SPECIES_NAME"/><![CDATA[<br/>]]>
Elevation:<xsl:value-of select="ELEVATION"/><![CDATA[<br/>]]>
Comments:<xsl:value-of select="COMMENTS"/><![CDATA[<br/>]]>
</description>
<Point>
<coordinates><xsl:value-of select="LONGITUDE"/><xsl:text>,</xsl:text><xsl:value-of select="LATITUDE"/><xsl:text>,0</xsl:text></coordinates>
</Point>
</Placemark>
</xsl:for-each>
</Folder>

<!-- ************************
        Fin du document   
 ************************ -->	
	
</Document>
</kml>
</xsl:template>

<!-- ************************************
 TEMPLATE pour formater la date
*************************************** -->

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


