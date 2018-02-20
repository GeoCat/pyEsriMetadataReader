<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gfc="http://www.isotc211.org/2005/gfc"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:uuid="java:java.util.UUID"
    exclude-result-prefixes="uuid"
    version="2.0">
    
        <!-- Remove xml-stylesheet instruction from header -->
    <xsl:template match="processing-instruction('xml-stylesheet')"/>
      
    <xsl:template match="metadata">
        <!-- Original version 
        <xsl:variable name="uid" select="uuid:randomUUID()"/>
        --> 
		<!--lxml version with argument passing-->        
	   <xsl:parameter name="uid"/>

        <gfc:FC_FeatureCatalogue xmlns:gfc="http://www.isotc211.org/2005/gfc"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx"
            uuid="{$uid}">
            
            <gmx:name>
                <gco:CharacterString><xsl:value-of select="eainfo/detailed/@Name"/></gco:CharacterString>
            </gmx:name>
            
            <gmx:scope>
                <gco:CharacterString><xsl:value-of select="eainfo/detailed/enttyp/enttypt"/></gco:CharacterString>
            </gmx:scope>
            
            <gmx:versionNumber>
                <gco:CharacterString>1.0</gco:CharacterString>
            </gmx:versionNumber>
            
            <gmx:versionDate>
                 <gco:DateTime><xsl:value-of select="concat(substring(Esri/ModDate, 1, 4), '-', substring(Esri/ModDate, 5, 2), '-', substring(Esri/ModDate, 7, 2))"/>T<xsl:value-of select="concat(substring(Esri/ModTime, 1, 2), ':', substring(Esri/ModDate, 3, 2), ':', substring(Esri/ModDate, 5, 2))"/>
                </gco:DateTime>
            </gmx:versionDate>
            
            <xsl:if test="string(gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode/@codeListValue)">
                <gmx:language>
                    <gco:CharacterString><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode/@codeListValue" /></gco:CharacterString>
                </gmx:language>
            </xsl:if>
            
            <xsl:if test="string(gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue)">
                <gmx:characterSet>
                    <gmd:MD_CharacterSetCode codeListValue="{gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue}"
                        codeList="MD_CharacterSetCode"/>
                </gmx:characterSet>
            </xsl:if>
        
            <xsl:apply-templates select="." mode="producer" />
            
                                
            <!-- Process attributes -->
            <xsl:apply-templates select="eainfo" />
            
        </gfc:FC_FeatureCatalogue>
    </xsl:template>
    
    
    <!-- Template to process Feature Type information -->
    <xsl:template match="eainfo">
       
        <xsl:variable name="featureType" select="//FC_FeatureCatalogue/featureType" />

        <gfc:featureType>
            <gfc:FC_FeatureType>
                <gfc:typeName>
                    <gco:LocalName><xsl:value-of select="detailed/@Name" /></gco:LocalName>
                </gfc:typeName>
                <gfc:definition>
                    <gco:CharacterString><xsl:value-of select="detailed/enttyp/enttypt" /></gco:CharacterString>
                </gfc:definition>
                <gfc:isAbstract>
                    <gco:Boolean>false</gco:Boolean>
                </gfc:isAbstract>
                <gfc:aliases>
                    <gco:LocalName><xsl:value-of select="detailed/@Name" /></gco:LocalName>
                </gfc:aliases>
                <gfc:featureCatalogue/>
                
                <!--<gfc:constrainedBy>
                    <gfc:FC_Constraint>
                        <gfc:description>
                            <gco:CharacterString>Description of the feature catalogue</gco:CharacterString>
                        </gfc:description>
                    </gfc:FC_Constraint>
                </gfc:constrainedBy>-->
     
                <xsl:for-each select="detailed/attr">
              
               <xsl:variable name="name" select="attrlabl"/>
                    
               <gfc:carrierOfCharacteristics>
                   <gfc:FC_FeatureAttribute>
                       <gfc:featureType/>
                       <gfc:memberName>
                           <gco:LocalName><xsl:value-of select="$name" /></gco:LocalName>
                       </gfc:memberName>
                       <gfc:definition>
                           <gco:CharacterString>
                               <xsl:choose>
                                   <xsl:when test="string(attrdef)"><xsl:value-of select="attrdef" /></xsl:when>
                                   <xsl:when test="string($featureType/featureAttribute[name = $name]/definition)"><xsl:value-of select="$featureType/featureAttribute[name = $name]/definition" /></xsl:when>
                               </xsl:choose>
                           </gco:CharacterString>
                       </gfc:definition>
                       <gfc:cardinality>
                           <gco:Multiplicity>
                               <gco:range>
                                   <gco:MultiplicityRange>
                                       <gco:lower>
                                           <gco:Integer>1</gco:Integer>
                                       </gco:lower>
                                       <gco:upper>
                                           <gco:UnlimitedInteger isInfinite="true" xsi:nil="true"/>
                                       </gco:upper>
                                   </gco:MultiplicityRange>
                               </gco:range>
                           </gco:Multiplicity>
                       </gfc:cardinality>
                        
                       <gfc:code>
                           <gco:CharacterString><xsl:value-of select="$name" /></gco:CharacterString>
                       </gfc:code>
                       
                       <gfc:valueType>
                           <gco:TypeName>
                               <gco:aName>
                                   <gco:CharacterString><xsl:value-of select="attrtype" /></gco:CharacterString>
                               </gco:aName>
                           </gco:TypeName>
                       </gfc:valueType>
                   </gfc:FC_FeatureAttribute>
               </gfc:carrierOfCharacteristics>
               
           </xsl:for-each>
           
            </gfc:FC_FeatureType>
        </gfc:featureType>
        
    </xsl:template>
    
    
    <!-- Template to process producer.
           - Uses first gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact if exists.
           - Otherwise adds an empty producer.
    -->
    <xsl:template match="*" mode="producer">
        <xsl:choose>
            <!-- Contact info in iso19139 -->
            <xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact">
                <xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[1]">
                    <gfc:producer>
                        <xsl:copy-of select="namespace::*"/>
                        <xsl:apply-templates select="node() | @*"/>
                    </gfc:producer>
                </xsl:for-each>
            </xsl:when>
            
            <!-- Contact info in ESRI format -->
            <xsl:when test="dataIdInfo/idPoC">
                <xsl:for-each select="dataIdInfo/idPoC[1]">
                    <gfc:producer>
                        <gmd:CI_ResponsibleParty>
                            <gmd:individualName>
                                <gco:CharacterString><xsl:value-of select="rpIndName"/></gco:CharacterString>
                            </gmd:individualName>
                            <gmd:organisationName>
                                <gco:CharacterString><xsl:value-of select="rpOrgName"/></gco:CharacterString>
                            </gmd:organisationName>
                            <gmd:positionName>
                                <gco:CharacterString><xsl:value-of select="rpPosName"/></gco:CharacterString>
                            </gmd:positionName>
                            
                            <xsl:for-each select="rpCntInfo[1]">
                                <gmd:contactInfo>
                                    <gmd:CI_Contact>
                                        <xsl:for-each select="cntPhone">
                                            <gmd:phone>
                                                <gmd:CI_Telephone>
                                                    <xsl:for-each select="voiceNum">
                                                        <gmd:voice>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:voice>
                                                    </xsl:for-each>
                                                    <xsl:for-each select="faxNum">
                                                        <gmd:facsimile>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:facsimile>
                                                    </xsl:for-each>
                                                
                                                </gmd:CI_Telephone>
                                            </gmd:phone>
                                        </xsl:for-each>
                                     
                                        <xsl:for-each select="cntAddress">
                                            <gmd:address>
                                                <gmd:CI_Address>
                                                    <xsl:for-each select="delPoint">
                                                        <gmd:deliveryPoint>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:deliveryPoint>                                                        
                                                    </xsl:for-each>
                                                    <xsl:for-each select="city[1]">
                                                        <gmd:city>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:city>                                                        
                                                    </xsl:for-each>
                                                    
                                                    <xsl:for-each select="adminArea[1]">
                                                        <gmd:administrativeArea>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:administrativeArea>
                                                    </xsl:for-each>
                                                    
                                                    <xsl:for-each select="postCode[1]">
                                                        <gmd:postalCode>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:postalCode>
                                                    </xsl:for-each>

                                                    <xsl:for-each select="country[1]">
                                                        <gmd:country>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:country>
                                                    </xsl:for-each>
                                                                                               
                                                    <xsl:for-each select="eMailAdd">
                                                        <gmd:electronicMailAddress>
                                                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                                                        </gmd:electronicMailAddress>
                                                    </xsl:for-each>
                                                   
                                                </gmd:CI_Address>
                                            </gmd:address>
                                            
                                        </xsl:for-each>
                                                                          
                                    </gmd:CI_Contact>
                                </gmd:contactInfo>                                
                            </xsl:for-each>
                             
                            <gmd:role>
                                <gmd:CI_RoleCode codeListValue="pointOfContact" codeList="CI_RoleCode"/>
                            </gmd:role>
                        </gmd:CI_ResponsibleParty>
                    </gfc:producer>
                    
                </xsl:for-each>

            </xsl:when>
            
            <!-- No contact info available - add empty contact -->
            <xsl:otherwise>
                <gfc:producer>
                    <gmd:CI_ResponsibleParty>
                        <gmd:individualName>
                            <gco:CharacterString></gco:CharacterString>
                        </gmd:individualName>
                        <gmd:organisationName>
                            <gco:CharacterString/>
                        </gmd:organisationName>
                        <gmd:positionName>
                            <gco:CharacterString/>
                        </gmd:positionName>
                        <gmd:contactInfo>
                            <gmd:CI_Contact>
                                <gmd:phone>
                                    <gmd:CI_Telephone>
                                        <gmd:voice>
                                            <gco:CharacterString/>
                                        </gmd:voice>
                                        <gmd:facsimile>
                                            <gco:CharacterString/>
                                        </gmd:facsimile>
                                    </gmd:CI_Telephone>
                                </gmd:phone>
                                <gmd:address>
                                    <gmd:CI_Address>
                                        <gmd:deliveryPoint>
                                            <gco:CharacterString/>
                                        </gmd:deliveryPoint>
                                        <gmd:city>
                                            <gco:CharacterString/>
                                        </gmd:city>
                                        <gmd:administrativeArea>
                                            <gco:CharacterString/>
                                        </gmd:administrativeArea>
                                        <gmd:postalCode>
                                            <gco:CharacterString/>
                                        </gmd:postalCode>
                                        <gmd:country>
                                            <gco:CharacterString/>
                                        </gmd:country>
                                        <gmd:electronicMailAddress>
                                            <gco:CharacterString/>
                                        </gmd:electronicMailAddress>
                                    </gmd:CI_Address>
                                </gmd:address>
                            </gmd:CI_Contact>
                        </gmd:contactInfo>
                        <gmd:role>
                            <gmd:CI_RoleCode codeListValue="pointOfContact" codeList="CI_RoleCode"/>
                        </gmd:role>
                    </gmd:CI_ResponsibleParty>
                </gfc:producer>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="gmd:*">
        <xsl:element name="gmd:{local-name()}">
            <xsl:copy-of select="namespace::*"/>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:element>    
        
    </xsl:template>
</xsl:stylesheet>