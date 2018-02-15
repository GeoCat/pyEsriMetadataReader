#/usr/bin/env python3
#-*- coding: utf-8 -*-
"""Module for xmp parsing and extraction of metadata and features from Arcmap metadata XML"""

from lxml import etree

from config import xlink_href

class XMLParser(object):
    """Arcmap XML parser.
    It parses the XML I/O object. Splits into md_metadata and fc_featurecatalog xml object
    
    Arguments:
    xmlFile -- XML file I/O object with read() method
    
    """
    
    csw_link = "{0}?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id={1}"
    # Do new element structure but hand using a simple string have problems with xlink
    NS_METADATA={None:  "http://www.isotc211.org/2005/gmd","xlink": 'http://www.w3.org/1999/xlink'}
    
    
    def __init__(self,xmlFile):
        self.xmlDoc = etree.parse(xmlFile)
        self.encoding = "UTF-8"
        self.xml_declaration = True
        self.pretty_print = True
        
       
    
    def _getXML(self,elName,asString=False):
        """Makes an xpath query and returns an XML doc for based on the elName, we have getMetadata and getFeature as proxy for this private method
        
        Arguments:
        asString -- If true it returns XML as string otherwise as XML Element (default: False)
        
        Output:
        XML element or None if not found (empty)
        
        """
        XPATH_EXPR = "//*[local-name() = '{}']".format(elName)
        metadataObj = self.xmlDoc.xpath(XPATH_EXPR)
        
        if not metadataObj:
            return None 
        
        else:
            if asString:
                return etree.tostring(metadataObj[0], encoding='UTF-8', xml_declaration=True,pretty_print=True)
            else:
                return metadataObj[0]
    
    
    
    def getMetadata(self,asString=False):
        """Gets MD_Metadata Element
        
        Arguments:
        asString -- If true it returns XML as string otherwise as XML Element (default: False)
        
        Output:
        XML MD_Metadata content as XML element or None if not found (empty)
        
        """
        return self._getXML(elName="MD_Metadata",asString=asString)
        
        
    def getFeature(self,asString=False):
        
        """Makes an xpath query and returns an XML doc for FC_FeatureCatalogue. Also adds minimal namepsaces and uuif
        
        Arguments:
        asString -- If true it returns XML as string otherwise as XML Element (default: False)
        
        Output:
        XML FC_FeatureCatalogue content as XML element or None if not found (empty)

        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xsi:schemaLocation="http://www.isotc211.org/2005/gfc/gfc.xsd"
        xmlns="http://www.isotc211.org/2005/gfc"
        uuid = "<uuid>" 

        """ 
        #ET.register_namespace(prefix, uri)
        
        xmlDoc = self._getXML(elName="FC_FeatureCatalogue",asString=False)
        if xmlDoc:
            #xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlDoc.attrib['{http://www.w3.org/2001/XMLSchema-instance}schemaLocation']= "http://www.isotc211.org/2005/gfc http://www.isotc211.org/2005/gfc/gfc.xsd"
            xmlDoc.attrib['xmlns'] = "http://www.isotc211.org/2005/gfc"
            xmlDoc.attrib["uuid"] = self.getFeatureName()
            if asString:
                etree.register_namespace("xsi","http://www.w3.org/2001/XMLSchema-instance")
                return etree.tostring(xmlDoc, encoding='UTF-8', xml_declaration=True,pretty_print=True)
            else:
                return xmlDoc
               
        else:
            return None

    def getFeatureName(self):
        """Makes an xpath query to get the feature name if not proper file or not found will return []
        
        Output:
        String
        
        """
        XPATH_EXPR = "//*[local-name() = 'FC_FeatureCatalogue']/featureType/name/text()"
        
        result = self.xmlDoc.xpath(XPATH_EXPR)
        if len(result)>0:
            return result[0]
        else:
            return None
    
    @staticmethod    
    def addFC(metadata,featureUUID):
        
        elIdentificationInfo = metadata.xpath("//*[local-name() = 'identificationInfo']")[0]
        elMD_Metadata = elIdentificationInfo.getparent()

        fcCitationEl = etree.Element('featureCatalogueCitation', nsmap=XMLParser.NS_METADATA)
        
        fclink = XMLParser.csw_link.format(xlink_href,featureUUID)
        
        fcCitationEl.attrib['{http://www.w3.org/1999/xlink}href'] = fclink
        fcCitationEl.attrib['uuidref'] = featureUUID

        MD_FCDescriptionEl = etree.Element('MD_FeatureCatalogueDescription')
        MD_FCDescriptionEl.append(fcCitationEl)
        contentInfoEl = etree.Element('contentInfo')
        contentInfoEl.append(MD_FCDescriptionEl)

        #adding everything into place
        elMD_Metadata.insert(elMD_Metadata.index(elIdentificationInfo)+1,contentInfoEl)
        
        return metadata
        
        
