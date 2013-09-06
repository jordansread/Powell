
masl.offset	<-	1149
root.dir	<-	'../data/'
data	<-	read.table(paste(root.dir,'Powell.wtr.txt',sep=''),header=TRUE,sep='\t',
	as.is=TRUE)
require(rLakeAnalyzer)

bathy.fPath	<-	paste(root.dir,'Wahweap.bth.txt',sep='')
Wahweap.bth	<-	load.bathy(bathy.fPath)

names(Wahweap.bth)
powell.lvl	<-	read.table(paste(root.dir,'Powell.lvl.txt',sep=''),header=TRUE,sep='\t')	
names(powell.lvl)
powell.lvl$Date	<-	as.Date(powell.lvl$Date,"%Y-%m-%d")
un.dates	<-	sort(unique(data$Date))

St	<-	vector(length=length(un.dates))
time	<-	St
uStar	<-	St
LA	<-	St
epi.temp	<-	St
hypo.temp	<-	St
ave.temp	<-	St
therm.depth	<-	St
meta.bot	<-	St
meta.top	<-	St
srt.time	<-	St # sorter for time

# from Dale: scuclp12 and lpcr0024 sites combined for Wahweap
for (j in 1:length(un.dates)){
	

	pos.date	<-	as.Date(un.dates[j],"%m/%d/%Y %H:%M:%S")#"%Y-%m-%d %H:%M:%S"
	
	
	# -- find dates matching single date
	useI	<-	which(un.dates[j]==data$Date)
	wtr	<-	data$T[useI]
	depth	<-	data$Depth[useI]
	
	# - sort - 
	indx	<-	order(depth)
	print(un.dates[j])
	meta.depths	<-	meta.depths(wtr[indx], depth[indx], slope=0.01, seasonal=TRUE)
	
	# -- interpolate temporally for surface height
	surf.masl	<-	approx(x=powell.lvl$Date,y=powell.lvl$masl,xout=pos.date,rule=2)$y
		
	bthA	<-	Wahweap.bth$areas
	# -- offset bathy for surface height
	# (bthZ=0 is equivalent to 1149 masl)
	bthZ	<-	Wahweap.bth$depths-(masl.offset-surf.masl)	# check this!!!!
	
	# -- interpolate bth file for depths
	bthD	<-	c(0,bthZ[bthZ>0])
	bthA	<-	approx(x=bthZ,y=bthA,xout=bthD)$y
	epi.rho	<-	layer.density(0, meta.depths[1], wtr[indx], depth[indx], bthA, bthD)
	epi.temp[j]	<-	layer.temperature(0, meta.depths[1], wtr[indx], depth[indx], bthA, bthD)
	hypo.temp[j]<-	layer.temperature(meta.depths[2], max(bthD), wtr[indx], depth[indx], bthA, bthD)
	hyp.rho	<-	layer.density(meta.depths[2], max(bthD), wtr[indx], depth[indx], bthA, bthD)
	ave.temp[j]	<-	layer.temperature(0,max(bthD), wtr[indx], depth[indx], bthA, bthD)
	
	therm.depth[j]	<-	thermo.depth(wtr[indx],depth[indx])
	uStar[j]	<-	uStar(wndSpeed=2, wndHeight=10, epi.rho)
	
	St[j]	<-	schmidt.stability(wtr[indx], depth[indx], bthA, bthD)
	time[j]	<-	un.dates[j]
	srt.time[j]	<-	pos.date
	LA[j]	<-	lake.number(bthA, bthD, uStar[j], St[j], meta.depths[1], meta.depths[2], hyp.rho)
	meta.top[j]	<-	meta.depths[1]
	meta.bot[j]	<-	meta.depths[2]
}	


indx	<-	order(srt.time)
#plot(srt.time[indx],ave.temp[indx])
la.out	<-	data.frame(DateTime=time[indx],lake.number=LA[indx],Schmidt.Stability=St[indx],
	epi.temp=epi.temp[indx],hypo.temp=hypo.temp[indx],
	ave.temp=ave.temp[indx],thermo.depth=therm.depth[indx],meta.top=meta.top[indx],meta.bot=meta.bot[indx])
output = "../data/LakeAnalyzer_Powell.txt"
write.table(la.out,file=output,col.names=TRUE, quote=FALSE, row.names=FALSE, sep="\t")
