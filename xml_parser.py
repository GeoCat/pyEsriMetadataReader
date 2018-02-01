#/usr/bin/env python3
#-*- coding: utf-8 -*-
"""Module for xmp parsing and extraction of metadata and features from Arcmap metadata XML"""

from lxml import etree

class XMLParser(object):
    """Arcmap XML parser.
    It parses the XML I/O object. Splits into md_metadata and fc_featurecatalog xml object
    
    Arguments:
    xmlFile -- XML file I/O object with read() method
    
    """
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
        """Makes an xpath query and returns an XML doc for FC_FeatureCatalogue
        
        Arguments:
        asString -- If true it returns XML as string otherwise as XML Element (default: False)
        
        Output:
        XML FC_FeatureCatalogue content as XML element or None if not found (empty)
        
        """ 
        return self._getXML(elName="FC_FeatureCatalogue",asString=asString)
