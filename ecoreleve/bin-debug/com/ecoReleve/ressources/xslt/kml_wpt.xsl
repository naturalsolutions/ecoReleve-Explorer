<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="OBSERVATIONS">
<kml xmlns="http://earth.google.com/kml/2.1">
<Document>

<!-- ***********************
        Gestion des styles  
 *************************** -->


<!-- Style des points normal
******************************* -->

<Style id="NormalStyle">
<IconStyle>
<color>ff00ffff</color>
<scale>1.2</scale>
<Icon>
<href>images\oiseau_normal.gif</href>
</Icon>
</IconStyle>
<BalloonStyle>
<bgColor>WHITE</bgColor>
<text><![CDATA[<b><font color=Black size="+2">Name: $[name]</font></b><br/><br/><font>$[description]</font><br/><P ALIGN=RIGHT>Data from eReleve ]]>(<xsl:value-of select="DATEOFEXPORT"/>)<![CDATA[</P>]]></text>
</BalloonStyle>
</Style>

<!-- Style des points en mouseover 
*************************************** -->

<Style id="HighlightStyle">
<IconStyle>
<color>ff00ffff</color>
<scale>1.2</scale>
<Icon>
<href>images\oiseau_highlight.gif</href>
</Icon>
</IconStyle>
<BalloonStyle>
<bgColor>WHITE</bgColor>
<text><![CDATA[<b><font color=Black size="+3">Name: $[name]</font></b><br/><br/><font>$[description]</font><br/><P ALIGN=RIGHT>Data from eReleve ]]>(<xsl:value-of select="DATEOFEXPORT"/>)<![CDATA[</P>]]></text>
</BalloonStyle>
</Style>

<!-- Style global des points 
****************************** -->

<StyleMap id="MyStyle">
<Pair>
<key>normal</key>
<styleUrl>#NormalStyle</styleUrl>
</Pair>
<Pair>
<key>highlight</key>
<styleUrl>#HighlightStyle</styleUrl>
</Pair>
</StyleMap>

<!-- ********************************************************
          Création des points (regroupé dans un dossier)
 ************************************************************ -->


<Folder>  
<name>Houbara locations</name> 

<xsl:for-each select="OBSERVATION">
<Placemark>
<styleUrl>#MyStyle</styleUrl>
<name>
<xsl:value-of select="@NAME"/>
</name>

<!-- Change le format de date de JJ/MM/AAAA HH:MM:SS en AAAA-MM-JJTHH:MM:SSZ -->
<TimeStamp>
<xsl:element name="when">
<xsl:call-template name="FormatDate">
	<xsl:with-param name="Date" select="WHEN/DATE"/>
</xsl:call-template>
</xsl:element>
</TimeStamp>
<description> 
<!-- &lt;br/&gt;  -->
<![CDATA[<B>STATION</B><br/>]]>
Date:<xsl:value-of select="WHEN/DATE"/><![CDATA[<br/>]]>
Field worker1:<xsl:value-of select="WHO/OBSERVER1"/><![CDATA[<br/>]]>
Field worker2:<xsl:value-of select="WHO/OBSERVER2"/><![CDATA[<br/>]]>
Nb Field worker:<xsl:value-of select="WHO/NB_OBSERVER"/><![CDATA[<br/>]]>
Field activity:<xsl:value-of select="WHO/ACTIVITY"/><![CDATA[<br/>]]>
Monitored site:<xsl:value-of select="MONITORED_SITE/NAME"/> (<xsl:value-of select="MONITORED_SITE/TYPE"/>)<![CDATA[<br/>]]>
Precision:<xsl:value-of select="WHERE/PRECISION"/><![CDATA[<br/>]]>
<![CDATA[<HR>
<B>OTHER</B><br/>]]>
<xsl:for-each select="WHAT/ATTRIBUTE/PARAMETERS">
<xsl:copy-of select="text()" />:<xsl:value-of select="VALUE"/><![CDATA[<br/>]]>
</xsl:for-each>
</description>
<Point>
<coordinates><xsl:value-of select="WHERE/LONGITUDE"/>,<xsl:value-of select="WHERE/LATITUDE"/>,0</coordinates>
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


