<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:gfc="http://www.isotc211.org/2005/gfc"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:uuid="java:java.util.UUID"
    exclude-result-prefixes="#all"
    version="2.0">
    
    
    <xsl:template match="metadata">
        <xsl:variable name="uid" select="uuid:randomUUID()"/>
        
        <gfc:FC_FeatureCatalogue xmlns:gfc="http://www.isotc211.org/2005/gfc"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx"
            uuid="{$uid}">
            
            <gmx:name>
                <gco:CharacterString><xsl:value-of select="eainfo/detailed/@Name"/></gco:CharacterString>
            </gmx:name>
            
            <gmx:scope>
                <gco:CharacterString>Scope</gco:CharacterString>
            </gmx:scope>
            
            <!--<gmx:fieldOfApplication>
                <gco:CharacterString/>
            </gmx:fieldOfApplication> -->
            
            <gmx:versionNumber>
                <gco:CharacterString>1.0</gco:CharacterString>
            </gmx:versionNumber>
            
            <gmx:versionDate>
                <gco:DateTime><xsl:value-of select="concat(substring(Esri/ModDate, 1, 4), '-', substring(Esri/ModDate, 5, 2), '-', substring(Esri/ModDate, 7, 2))"/>T<xsl:value-of select="concat(substring(Esri/ModTime, 1, 2), ':', substring(Esri/ModDate, 3, 2), ':', substring(Esri/ModDate, 5, 2))"/>
                </gco:DateTime>
            </gmx:versionDate>
            
            <!--<gmx:language>
                <gco:CharacterString>dut</gco:CharacterString>
            </gmx:language>-->
            
            <!--<gmx:characterSet>
                <gco:CharacterString>UTF-8</gco:CharacterString>
            </gmx:characterSet>-->
            
            <gfc:producer>
                <gmd:CI_ResponsibleParty>
                    <gmd:individualName>
                        <gco:CharacterString>Individual name</gco:CharacterString>
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
            
            
           
            <xsl:apply-templates select="eainfo" />
        </gfc:FC_FeatureCatalogue>
    </xsl:template>
    
    
    <xsl:template match="eainfo">
       
        <xsl:variable name="featureType" select="//FC_FeatureCatalogue/featureType" />

        <gfc:featureType>
            <gfc:FC_FeatureType>
                <gfc:typeName>
                    <gco:LocalName><xsl:value-of select="detailed/@Name" /></gco:LocalName>
                </gfc:typeName>
                <gfc:definition>
                    <gco:CharacterString/>
                </gfc:definition>
                <gfc:isAbstract>
                    <gco:Boolean>false</gco:Boolean>
                </gfc:isAbstract>
                <gfc:aliases>
                    <gco:LocalName>Local name</gco:LocalName>
                </gfc:aliases>
                <gfc:featureCatalogue/>
                <gfc:constrainedBy>
                    <gfc:FC_Constraint>
                        <gfc:description>
                            <gco:CharacterString>Description of the feature catalogue</gco:CharacterString>
                        </gfc:description>
                    </gfc:FC_Constraint>
                </gfc:constrainedBy>
     
                <xsl:for-each select="detailed/attr">
               <!-- 
            
                 <attr>
                <attrlabl Sync="TRUE">OBJECTID</attrlabl>
                <attalias Sync="TRUE">OBJECTID</attalias>
                <attrtype Sync="TRUE">OID</attrtype>
                <attwidth Sync="TRUE">4</attwidth>
                <atprecis Sync="TRUE">10</atprecis>
                <attscale Sync="TRUE">0</attscale>
                <attrdef Sync="TRUE">Internal feature number.</attrdef>
                <attrdefs Sync="TRUE">Esri</attrdefs>
                <attrdomv>
                    <udom Sync="TRUE">Sequential unique whole numbers that are automatically
                        generated.</udom>
                </attrdomv>
            </attr>
            -->
               
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
                               </xsl:choose><xsl:value-of select="attrdef" />
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
                       <!--<gfc:valueMeasurementUnit>
                           <gml:UnitDefinition xmlns:gml="http://www.opengis.net/gml" gml:id="unknown">
                               <gml:description/>
                               <gml:identifier codeSpace="unknown"/>
                           </gml:UnitDefinition>
                       </gfc:valueMeasurementUnit>-->
                       <gfc:valueType>
                           <gco:TypeName>
                               <gco:aName>
                                   <gco:CharacterString><xsl:value-of select="attrtype" /></gco:CharacterString>
                               </gco:aName>
                           </gco:TypeName>
                       </gfc:valueType>
                       <!--<gfc:listedValue>
                           <gfc:FC_ListedValue>
                               <gfc:label>
                                   <gco:CharacterString>First type (eg. Forest)</gco:CharacterString>
                               </gfc:label>
                               <gfc:code>
                                   <gco:CharacterString>F</gco:CharacterString>
                               </gfc:code>
                               <gfc:definition>
                                   <gco:CharacterString/>
                               </gfc:definition>
                           </gfc:FC_ListedValue>
                       </gfc:listedValue>
                       <gfc:listedValue>
                           <gfc:FC_ListedValue>
                               <gfc:label>
                                   <gco:CharacterString>Second type (eg. Water)</gco:CharacterString>
                               </gfc:label>
                               <gfc:code>
                                   <gco:CharacterString>W</gco:CharacterString>
                               </gfc:code>
                           </gfc:FC_ListedValue>
                       </gfc:listedValue>-->
                   </gfc:FC_FeatureAttribute>
               </gfc:carrierOfCharacteristics>
               
           </xsl:for-each>
           
            </gfc:FC_FeatureType>
        </gfc:featureType>
        
    </xsl:template>
</xsl:stylesheet>