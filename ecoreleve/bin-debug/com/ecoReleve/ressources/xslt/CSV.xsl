<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>
<xsl:template match="RELEVES">NAME,LATITUDE,LONGITUDE,DATE,ELEVATION,COMMENTS,SPECIES_NAME,NB_INDIVIDUAL,SOURCE
<xsl:for-each select="RELEVE">
<xsl:text>"</xsl:text><xsl:value-of select="NAME"/><xsl:text>",</xsl:text>
<xsl:value-of select="LATITUDE"/><xsl:text>,</xsl:text>
<xsl:value-of select="LONGITUDE"/><xsl:text>,</xsl:text>
<xsl:value-of select="DATE"/><xsl:text>,</xsl:text>
<xsl:value-of select="ELEVATION"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="COMMENTS"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="SPECIES_NAME"/><xsl:text>",</xsl:text>
<xsl:value-of select="NB_INDIVIDUAL"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="SOURCE"/><xsl:text>"</xsl:text><xsl:text>;
</xsl:text>
</xsl:for-each> 
</xsl:template>
</xsl:stylesheet>
