
root.dir	<-	'../data/'
data	<-	read.table(paste(root.dir,'Powell.wtr.txt',sep=''),header=TRUE,sep='\t',
	as.is=TRUE)
require(rLakeAnalyzer)

un.dates	<-	sort(unique(data$Date))
for (j in 1:10){#length(un.dates)){
	
	
	useI	<-	which(un.dates[j]==data$Date)
	wtr	<-	data$T[useI]
	depth	<-	data$Depth[useI]
	indx	<-	order(depth)
	meta.depths	<-	meta.depths(wtr[indx], depth[indx], slope=0.01, seasonal=TRUE)
	
	# -- interpolate bth file for depths
	
	# -- interpolate temporally for surface height
	
	# -- offset bathy for surface height
	
	
	schmidt.stability(wtr[indx], depth[indx], bthA, bthD)
	print(meta.depths	)
	#lake.number(bthA, bthD, uStar, St, meta.depths[1], meta.depths[2], averageHypoDense)
}	
