<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- ======================================================== -->
<!-- File    : REMUS_change_request.xsl                       -->
<!-- Content : REM XSLT for subjects at US - change_request   -->
<!-- Author  : Amador Dur�n Toro                              -->
<!-- Date    : 2021/01/01                                     -->
<!-- Version : 3.0                                            -->
<!-- ======================================================== -->

<!-- ======================================================== -->
<!-- exclude-result-prefixes="rem" must be set in all files   -->
<!-- to avoid xmlsn:rem="..." to appear in HTML tags.         -->
<!-- ======================================================== -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rem="http://rem.lsi.us.es"
    exclude-result-prefixes="rem"
>
<!-- ============================================= -->
<!-- rem:changeRequest template                    -->
<!-- ============================================= -->

<xsl:template match="rem:changeRequest">
    <div id="{@oid}">
        <table class="change_request remus_table">

            <xsl:call-template name="generate_expanded_header"/>

            <!-- directly affected objects -->
            <xsl:call-template name="generate_directly_affected_objects"/>

            <!-- indirectly affected objects -->
            <xsl:call-template name="generate_indirectly_affected_objects"/>

            <xsl:call-template name="generate_markdown_row">
                <xsl:with-param name="label"   select="$rem:lang_description"/>
                <xsl:with-param name="content" select="rem:description"/>
                <xsl:with-param name="mode"    select="'paragraph'"/>
            </xsl:call-template>

            <xsl:call-template name="generate_markdown_row">
                <xsl:with-param name="label"   select="$rem:lang_analysis"/>
                <xsl:with-param name="content" select="rem:analysis"/>
                <xsl:with-param name="mode"    select="'paragraph'"/>
            </xsl:call-template>

            <!-- alternatives -->
            <xsl:call-template name="generate_alternatives"/>

            <xsl:call-template name="generate_priority_rows"/>
            <xsl:call-template name="generate_comments_row"/>

        </table>
    </div>
</xsl:template>

</xsl:stylesheet>
