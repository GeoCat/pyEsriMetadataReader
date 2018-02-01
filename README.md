# General

Generic script for xml processing from arcgis metadata to iso 19115 and 191110 

* arcmap2gn


Scripts use python3 and it better to have pip3 installed for package installation (management)

Mac install: (http://itsevans.com/install-pip-osx/)

Linux install: `apt install python3-pip`

Windows: (https://stackoverflow.com/questions/24285508/how-to-use-pip-with-python-3-4-on-windows)


On the folder or each script the necessary python packages are in the `requirements.txt` file to install them:
```
pip3 -r requirements.txt
```



The script will process a zip files with XML content and will extract the metadata and features from the metdata ESRI file

The output will be dropped on a output folder

e.g:
```
python3 arcmap2gn.py -i ./data/metadataportaal.zip  -p ./output
```

For help:
```
python3 arcmpa2gn.py -h
```
Note: There is no installer