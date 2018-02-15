#/usr/bin/env python3
#-*- coding: utf-8 -*-
"""XML extractor for Arcmap metadata"""

__title__      = 'Arcmap metadata extractor'
__summary__    = """Arcmap metadata XML extractor of ISO 19115"""
__author__     = 'Jorge Samuel Mendes de Jesus'
__date__       = '27-JAN-2018'
__version__    = '1.0'
__email__      = 'jorge.dejesus@geocat.net'

import zipfile,argparse,os
from xml_parser import XMLParser
from lxml import etree

class iterXMLFile(object):
    """Iteractor class providing XML I/O files object from the input zip file for processing
    
    Arguments:  
    zipFile -- Zip file path/name containing XML files to process (e.g ./metadataportaal.zip) 
    
    """
    def __new__(cls,*args,**kwargs):
        """Testing zip file before class inst"""
        zipFile=args[0]
        with zipfile.ZipFile(zipFile, 'r') as xmlZip:
            xmlZip.testzip() 
        return super(iterXMLFile, cls).__new__(cls)
    
        
    def __init__(self,zipFile):
        """Setting zipfile as I/O object"""
        self.zipFile=zipfile.ZipFile(zipFile,'r')
    
    def __iter__(self):
        """Iteractor object yielding file object from zipfile collection """
        #return iter(self.zipFile.namelist())
        for x in self.zipFile.namelist():
             yield self.zipFile.open(x)
        


 
def main(args):
    """Main function and code runing"""
    
    INPUT_FILE = args.zipfile 
    OUTPUT_PATH = args.outputPath
    
    for xmlFileObj in iterXMLFile(INPUT_FILE):
        
        xmlData = XMLParser(xmlFileObj)
        metadata = xmlData.getMetadata(asString = False)
        
        
        
        if metadata is None:
            print("File {} has no metadata skipping it".format(xmlFileObj.name))
            continue

                     
        featureName = xmlData.getFeatureName() 
        if featureName:
            #static method
            feature =  xmlData.getFeature(asString = True)  
            metadata=XMLParser.addFC(metadata,featureName)
            fFeatureName = os.path.join(OUTPUT_PATH,xmlFileObj.name[:-4]+'_feature.xml')
            with open(fFeatureName,'wb') as outFeature:
                outFeature.write(feature)
                
            
        
        fMetadataName = os.path.join(OUTPUT_PATH,xmlFileObj.name[:-4]+'_metadata.xml')
        with open(fMetadataName,'wb') as outMetadata:
            metadataOut=etree.tostring(metadata, encoding='UTF-8', xml_declaration=True,pretty_print=True)
            outMetadata.write(metadataOut)

                    
        
        print("File {} has been processed".format(xmlFileObj.name))
    
    
if __name__ == "__main__": 
    
    parser = argparse.ArgumentParser(description = __summary__)
    parser.add_argument('-i','--zipfile',dest="zipfile", 
                        required=False,  default="./data/metadataportaal.zip", 
                        help = "Zipfile with Arcmap XML files to be processed e.g ./data/metadataportaal.zip")
    
    
    parser.add_argument('-p','--path',dest="outputPath",
                        required=False,default="./output",
                        help = "Output directory path e.g: ./output")
    
    main(args=parser.parse_args())

