
root.dir	<-	'../data/'
data	<-	read.table(paste(root.dir,'Powell.wtr.txt',sep=''),header=TRUE,sep='\t',
	as.is=TRUE)
require(rLakeAnalyzer)

bathy.fPath	<-	paste(root.dir,'Wahweap_bathy.csv',sep='')
Wahweap.bth	<-	load.bathy(bathy.fPath)

powell.lvl	<-	read.table(paste(root.dir,'Powell.lvl.txt',sep=''),header=TRUE,sep='\t')	

un.dates	<-	sort(unique(data$Date))
for (j in 1:10){#length(un.dates)){
	
	# -- find dates matching single date
	useI	<-	which(un.dates[j]==data$Date)
	wtr	<-	data$T[useI]
	depth	<-	data$Depth[useI]
	
	# - sort - 
	indx	<-	order(depth)
	meta.depths	<-	meta.depths(wtr[indx], depth[indx], slope=0.01, seasonal=TRUE)
	
	# -- interpolate temporally for surface height
	
		
	# -- interpolate bth file for depths
	# bthZ=0 is equivalent to 1149 masl
	
	
	# -- offset bathy for surface height
	
	
	schmidt.stability(wtr[indx], depth[indx], bthA, bthD)
	print(meta.depths	)
	#lake.number(bthA, bthD, uStar, St, meta.depths[1], meta.depths[2], averageHypoDense)
}	
