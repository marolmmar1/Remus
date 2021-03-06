<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- =========================================================== -->
<!-- File    : REMUS_system_operation.xsl                        -->
<!-- Content : REM XSLT for subjects at US - system operation    -->
<!-- Author  : Amador Dur?n Toro                                 -->
<!-- Date    : 2020/12/25                                        -->
<!-- Version : 3.0                                               -->
<!-- =========================================================== -->

<!-- =========================================================== -->
<!-- exclude-result-prefixes="rem" must be set in all files      -->
<!-- to avoid xmlsn:rem="..." to appear in HTML tags.            -->
<!-- =========================================================== -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rem="http://rem.lsi.us.es"
    exclude-result-prefixes="rem"
>

<!-- ============================================== -->
<!-- rem:systemOperation template                   -->
<!-- ============================================== -->

<xsl:template match="rem:systemOperation">
    <div id="{@oid}" class="system_operation">
        <table class="system_operation remus_table">
            <xsl:call-template name="generate_expanded_header"/>
            <tr>
                <td colspan="2">
                    <div class="code">
                        <xsl:apply-templates select="." mode="code"/>
                    </div>
                </td>
            </tr>
            <xsl:call-template name="generate_comments_row"/>
        </table>
    </div>
</xsl:template>

<!-- ============================================== -->
<!-- rem:systemOperation template (mode code)       -->
<!-- ============================================== -->

<xsl:template match="rem:systemOperation" mode="code">
    <xsl:if test="string-length(rem:description)">
        <div>
            <span class="code_comment">/**</span>
            <xsl:call-template name="generate_markdown">
                <xsl:with-param name="node" select="rem:description"/>
                <xsl:with-param name="node_class" select="'code_comment code_description'"/>
                <xsl:with-param name="mode" select="'paragraph'"/>
            </xsl:call-template>
            <span class="code_comment">*/</span>
        </div>
    </xsl:if>

    <xsl:variable name="operation_declaration">system operation</xsl:variable>

    <span class="keyword">
        <xsl:value-of select="$operation_declaration"/>
        <xsl:text> </xsl:text>
    </span>
    <xsl:apply-templates select="rem:name" mode="code"/>

    <br/>
    {<br/>

    <!-- preconditions -->

    <xsl:if test="rem:preconditionExpression">
        <div class="code_comment code_header"><xsl:value-of select="$rem:lang_code_preconditions"/></div>
        <ul class="properties">
            <xsl:apply-templates select="rem:preconditionExpression" mode="code"/>
        </ul>
    </xsl:if>

    <!-- postconditions -->

    <xsl:if test="rem:postconditionExpression">
        <br/>
        <div class="code_comment code_header"><xsl:value-of select="$rem:lang_code_postconditions"/></div>
        <ul class="properties">
            <xsl:apply-templates select="rem:postconditionExpression" mode="code"/>
        </ul>
    </xsl:if>

    <!-- exceptions -->

    <xsl:if test="rem:operationException">
        <br/>
        <div class="code_comment code_header"><xsl:value-of select="$rem:lang_code_exceptions"/></div>
        <ul class="properties">
            <xsl:for-each select="rem:operationException">
                <li id="{@oid}" class="property">
                    <xsl:apply-templates select="." mode="code"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:if>
    }
</xsl:template>

<!-- ==================================================== -->
<!-- rem:systemOperation/rem:name template                -->
<!-- ==================================================== -->

<xsl:template match="rem:systemOperation/rem:name">
    <xsl:value-of select="."/>
    <xsl:choose>
        <xsl:when test="not(../rem:parameter)">()</xsl:when>
        <xsl:otherwise>(
            <xsl:for-each select="../rem:parameter">
                <xsl:value-of select="rem:name"/>
                <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
        )
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="../rem:resultType"> : <xsl:value-of select="../rem:resultType"/></xsl:if>
</xsl:template>

<xsl:template match="rem:systemOperation/rem:name" mode="code">
    <span class="class_name"><xsl:value-of select="."/><xsl:text> </xsl:text></span>
    <!-- attributes -->
    <xsl:choose>
        <xsl:when test="not(../rem:parameter)">()</xsl:when>
        <xsl:otherwise>(<br/>
            <xsl:for-each select="../rem:parameter">
                <ul class="properties">
                    <xsl:apply-templates select="." mode="code"/>
                    <xsl:if test="not(position()=last())">, <br/></xsl:if>
                </ul>
            </xsl:for-each>
        )
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="../rem:resultType"> : <xsl:value-of select="../rem:resultType"/></xsl:if>
</xsl:template>


<!-- ==================================================== -->
<!-- rem:parameter template (mode code)                   -->
<!-- ==================================================== -->

<xsl:template match="rem:parameter" mode="code">
    <li id="{@oid}" class="property">
        <!-- name : type -->
        <xsl:value-of select="rem:name"/> : <xsl:choose>
            <xsl:when test="rem:isSet">Set(</xsl:when>
            <xsl:when test="rem:isSequence">Sequence(</xsl:when>
            <xsl:when test="rem:isBag">Bag(</xsl:when>
            </xsl:choose>
            <xsl:value-of select="id(@baseType)/rem:name"/>
            <xsl:if test="rem:isSet|rem:isSequence|rem:isBag">)</xsl:if>

        <!-- description -->
        <xsl:if test="string-length(rem:description)">
            <xsl:call-template name="generate_markdown">
                <xsl:with-param name="prefix">/**</xsl:with-param>
                <xsl:with-param name="postfix"> */</xsl:with-param>
                <xsl:with-param name="node" select="rem:description"/>
                <xsl:with-param name="node_class" select="'code_comment'"/>
                <xsl:with-param name="mode" select="'inline'"/>
            </xsl:call-template>
        </xsl:if>
    </li>
</xsl:template>

<!-- =========================================================================== -->
<!-- rem:preconditionExpression|rem:postconditionExpression template (mode code) -->
<!-- =========================================================================== -->

<xsl:template match="rem:preconditionExpression|rem:postconditionExpression" mode="code">
    <li id="{@oid}" class="property">
        <xsl:choose>
            <xsl:when test="string-length(rem:expression/rem:natural)">
                <xsl:call-template name="generate_markdown">
                    <xsl:with-param name="prefix">/**</xsl:with-param>
                    <xsl:with-param name="postfix"> */</xsl:with-param>
                    <xsl:with-param name="node" select="rem:expression/rem:natural"/>
                    <xsl:with-param name="node_class" select="'code_comment'"/>
                    <xsl:with-param name="mode" select="'paragraph'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><br/></xsl:otherwise>
        </xsl:choose>
        <span class="keyword"><xsl:value-of select="substring-before(local-name(),'Expression')"/> <xsl:text> </xsl:text></span>
        <xsl:value-of select="rem:name"/>:
        <xsl:if test="string-length(rem:expression/rem:ocl)">
            <xsl:call-template name="generate_markdown">
                <xsl:with-param name="node" select="rem:expression/rem:ocl"/>
                <xsl:with-param name="node_class" select="'code_ocl'"/>
                <xsl:with-param name="mode" select="'paragraph'"/>
            </xsl:call-template>
        </xsl:if>
    </li>
</xsl:template>

<!-- ==================================================== -->
<!-- rem:operationException template (mode code)          -->
<!-- ===================================================== -->

<xsl:template match="rem:operationException" mode="code">

    <xsl:variable name="condition_natural"       select="rem:operationCondition/rem:expression/rem:natural"/>
    <xsl:variable name="condition_ocl"           select="rem:operationCondition/rem:expression/rem:ocl"/>
    <xsl:variable name="expression_natural"      select="rem:expression/rem:natural"/>
    <xsl:variable name="expression_ocl"          select="rem:expression/rem:ocl"/>
    <xsl:variable name="condition_natural_arrow" select="concat($condition_natural,' do ')"/>
    <xsl:variable name="condition_ocl_arrow"     select="concat($condition_ocl,', do ')"/>

    <!-- comment when condition, do expression -->

    <xsl:choose>
        <xsl:when test="string-length($condition_natural) or string-length($expression_natural)">
            <xsl:call-template name="generate_markdown">
                <xsl:with-param name="prefix" select="concat('/** when ', $condition_natural_arrow)"/>
                <xsl:with-param name="postfix">
                */</xsl:with-param>
                <xsl:with-param name="node" select="rem:expression/rem:natural"/>
                <xsl:with-param name="node_class" select="'code_comment'"/>
                <xsl:with-param name="mode" select="'paragraph'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><br/></xsl:otherwise>
    </xsl:choose>

    <!-- exception name: -->

    <span class="keyword"><xsl:value-of select="$rem:lang_code_exception"/> <xsl:text> </xsl:text></span>
    <xsl:value-of select="rem:name"/>:<br/>

    <!-- when condition do expression -->

    <span class="keyword">when <xsl:text> </xsl:text></span>

    <xsl:call-template name="generate_markdown">
        <xsl:with-param name="node" select="rem:operationCondition/rem:expression/rem:ocl"/>
        <xsl:with-param name="node_class" select="'code_ocl'"/>
        <xsl:with-param name="mode" select="'paragraph'"/>
    </xsl:call-template><span class="keyword">do <xsl:text> </xsl:text></span>

    <!-- This is the only case in which the oid parameter has to be used -->
    <!-- because the local-name() of both nodes is ocl.                  -->
    <xsl:call-template name="generate_markdown">
        <xsl:with-param name="oid" select="concat(@oid,'-2')"/>
        <xsl:with-param name="node" select="rem:expression/rem:ocl"/>
        <xsl:with-param name="node_class" select="'code_ocl'"/>
        <xsl:with-param name="mode" select="'paragraph'"/>
    </xsl:call-template>

</xsl:template>


</xsl:stylesheet>
