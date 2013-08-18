# Lake Powell data manipulation

# need to find all unique stations, and unique dates on those stations,
# format and write to csv (or tsv?)

file.list	<-	list(
	'samples'='tblSamples.csv',
	'nutrients'='tblNutrients.csv',
	'ions'='tblMajor Ions.csv',
	'profiles'='tblProfiles.csv',
	'secchi'='tblSecchi.csv',
	'surface'='tblSurface.csv',
	'alkalinity'='tblAlkalinity.csv'
	)

num.files	<-	length(file.list)
root.dir	<-	'../data/'
# find unique date, location, depth; build from there. 

full.file	<-	data.frame('Station'=NULL,'Date'=NULL,'Depth'=NULL)

for (i in 1:num.files){
	data	<-	read.table(paste(root.dir,file.list[[i]],sep=''),header=TRUE,sep=',',colClasses='character')
	val.count	<-	table(names(data) %in% c('Depth','Date','Station.ID'))["TRUE"]
	if (!is.na(val.count) && val.count[[1]]==3){
		append.vals	<-	data.frame('Station'=data$Station.ID,'Date'=data$Date,'Depth'=data$Depth)
		full.file	<-	rbind(full.file,append.vals)
    print(paste(root.dir,file.list[[i]],' yes',sep=''))
	}
}
unique.file	<-	subset(full.file,!duplicated.data.frame(full.file))

# now, transform lab results (nutrients and ions) to date and depth information
# match samples$Lab.Maj with nutrients$Lab.Maj etc.
samples	<-	read.table(file.path(root.dir,file.list$samples),header=TRUE,sep=',',colClasses='character')
nutrients	<-	read.table(file.path(root.dir,file.list$nutrients),header=TRUE,sep=',',colClasses='character')
ions	<-	read.table(file.path(root.dir,file.list$ions),header=TRUE,sep=',',colClasses='character')



# loop through nutrients, add date and depth
for (j in 1:nrow(nutrients)){
	comp.val	<-	nutrients$Lab.Nut[j]
	sample.idx	<-	which(samples$Lab.Nut==comp.val)
	file.idx	<-	which(full.file$Station==samples$Station.ID[sample.idx] & 
						full.file$Date==samples$Date[sample.idx] &
						full.file$Depth==samples$Depth[sample.idx])
}
print(comp.val)

unique(samples$Lab.Maj)
length(samples$Lab.Maj)
length(unique(samples$Lab.Maj))
# what vars do we want to add?
nrow(unique.file)