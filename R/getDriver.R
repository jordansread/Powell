require(rGDP)
#-111.48,36.95, -111.481, 36.951, -111.482, 36.95,-111.481, 36.949,-111.48,36.95
rGDP	<-	setFeature(rGDP(),list(LinearRing=c(-111.48,36.95, -111.48, 36.92, -111.47, 36.93,-111.47, 36.95,-111.48,36.95)))
rGDP	<-	setAlgorithm(rGDP,getAlgorithms(rGDP)[4]) # feature unweighted

year	<-	2011

var	<-	'vwnd'
base.url	<-	'http://www.esrl.noaa.gov/psd/thredds/dodsC/Datasets/NARR/Dailies/monolevel/vwnd.10m.'
rGDP  <-  setPostInputs(rGDP,list('DATASET_ID'=var,
                                        'DATASET_URI'=paste(base.url,year,'.nc',sep=''),
                                        'TIME_START'=paste(year,'-01-01T00:00:00Z',sep=''),
                                        'TIME_END'=paste(year,'-12-31T23:00:00Z',sep=''),
                                        'DELIMITER'='TAB'))

rGDP	
rGDP	<-	executePost(rGDP)
checkProcess(rGDP)
rGDP

checkProcess(rGDP)