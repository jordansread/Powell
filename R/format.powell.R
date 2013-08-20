# Lake Powell data manipulation

# need to find all unique stations, and unique dates on those stations,
# format and write to csv (or tsv?)

primary.key	<-	c('Depth','Date','Station.ID')
remove.names	<-	c('Lab.Maj','Lab.Nut','Observer','QA')

file.list	<-	list(
	'samples'='tblSamples.csv',
	'nutrients'='tblNutrients.csv',
	'ions'='tblMajor Ions.csv',
	'profiles'='tblProfiles.csv',
	'alkalinity'='tblAlkalinity.csv'
	)

num.files	<-	length(file.list)
root.dir	<-	'../data/'
# find unique date, location, depth; build from there. 

full.file	<-	data.frame('Station'=NULL,'Date'=NULL,'Depth'=NULL)
add.names	<-	c()

for (i in 1:num.files){
	data	<-	read.table(paste(root.dir,file.list[[i]],sep=''),header=TRUE,sep=',',
		as.is=TRUE)#colClasses='character',stringsAsFactors=FALSE,a
	val.count	<-	table(names(data) %in% primary.key)["TRUE"]
	if (!is.na(val.count) && val.count[[1]]==3){
		append.vals	<-	data.frame('Station.ID'=data$Station.ID,
			'Date'=data$Date,
			'Depth'=as.numeric(data$Depth))
		full.file	<-	rbind(full.file,append.vals)
    print(paste(root.dir,file.list[[i]],' yes',sep=''))
	}
	print(nrow(full.file))
	add.names	<-	c(add.names,names(data))
}
add.names	<-	unique(add.names[!add.names %in% c(primary.key,remove.names)])

full.file	<-	cbind(full.file,add=matrix(nrow=nrow(full.file),ncol=length(add.names)))
names(full.file) = c(names(full.file[1:3]),add.names)


# now, transform lab results (nutrients and ions) to date and depth information
# match samples$Lab.Maj with nutrients$Lab.Maj etc.
samples	<-	read.table(file.path(root.dir,file.list$samples),header=TRUE,sep=',',
	colClasses='character',stringsAsFactors=FALSE)
nutrients	<-	read.table(file.path(root.dir,file.list$nutrients),header=TRUE,sep=',',
		colClasses='character',stringsAsFactors=FALSE)
ions	<-	read.table(file.path(root.dir,file.list$ions),header=TRUE,sep=',',
			colClasses='character',stringsAsFactors=FALSE)


# loop through nutrients, add date and depth
for (j in 1:nrow(nutrients)){
	comp.val	<-	nutrients$Lab.Nut[j]
	sample.idx	<-	which(samples$Lab.Nut==comp.val)
	file.idx	<-	which(full.file$Station==samples$Station.ID[sample.idx] & 
						full.file$Date==samples$Date[sample.idx] &
						full.file$Depth==as.numeric(samples$Depth[sample.idx]))
	val.names<- names(nutrients)
	val.names.use <- val.names[val.names %in% names(full.file)]
	full.file[file.idx,val.names.use] <- nutrients[j,val.names.use]
}

print('done with nutrients')

# loop through major ions, add date and depth
for (j in 1:nrow(ions)){
	comp.val	<-	ions$Lab.Maj[j]
	sample.idx	<-	which(samples$Lab.Maj==comp.val)
	file.idx	<-	which(full.file$Station==samples$Station.ID[sample.idx] & 
						full.file$Date==samples$Date[sample.idx] &
						full.file$Depth==as.numeric(samples$Depth[sample.idx]))
 	val.names<- names(ions)
	val.names.use <- val.names[val.names %in% names(full.file)]
	full.file[file.idx,val.names.use] <- ions[j,val.names.use]
}
print('done with major ions')

# now, other files
profiles	<-	read.table(file.path(root.dir,file.list$profiles),header=TRUE,sep=',',
                       colClasses='character',stringsAsFactors=FALSE)
alkalinity	<-	read.table(file.path(root.dir,file.list$alkalinity),header=TRUE,sep=',',
                         colClasses='character',stringsAsFactors=FALSE)

file.use	<-	profiles
for (j in 1:nrow(file.use)){
	file.idx	<-	which(full.file$Station==file.use$Station.ID[j] & 
						full.file$Date==file.use$Date[j] &
						full.file$Depth==as.numeric(file.use$Depth[j]))
	val.names<- names(file.use)
	val.names.use <- val.names[val.names %in% names(full.file)]
	full.file[file.idx,val.names.use] <- file.use[j,val.names.use]
	print(paste(j,'of',nrow(file.use),'complete; profiles',sep=' '))
}
print('done with major profiles')
file.use	<-	alkalinity
for (j in 1:nrow(file.use)){
	file.idx	<-	which(full.file$Station==file.use$Station.ID[sample.idx] & 
						full.file$Date==file.use$Date[sample.idx] &
						full.file$Depth==as.numeric(file.use$Depth[sample.idx]))
	val.names<- names(file.use)
	val.names.use <- val.names[val.names %in% names(full.file)]
	full.file[file.idx,val.names.use] <- file.use[j,val.names.use]
	print(paste(j,'of',nrow(file.use),'complete; alkalinity',sep=' '))
}

unique.file	<-	subset(full.file,!duplicated.data.frame(full.file))


full.file	<-	unique.file

print('done with alkalinity')
write.table(full.file,file="output.csv",col.names=TRUE, quote=FALSE, row.names=FALSE, sep=",",na='')
