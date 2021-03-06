

ionPlot<-function(inputFile,outputFile,title){
	testCSV<-read.csv(inputFile, header = TRUE)
	i<-(grep("(1+)b",testCSV$Charge_IonType,fixed = TRUE)) 	# filter entries out from one csv column, in this case (1+) b ions from Charge_IonType column
		bMob<-testCSV$X3D_Mobility[i]
		bMZ<-testCSV$experimental.m.z..3D_m_z.[i]			# create a 2-D array of coordinates to be used on the plot
	j<-(grep("(1+)y",testCSV$Charge_IonType,fixed = TRUE))	# filter the second series of entries out
		yMob<-testCSV$X3D_Mobility[j]
		yMZ<-testCSV$experimental.m.z..3D_m_z.[j]
	k<-(grep("(2+)",testCSV$Charge_IonType,fixed = TRUE))	# filter the third series of entries out
		kMob<-testCSV$X3D_Mobility[k]
		kMZ<-testCSV$experimental.m.z..3D_m_z.[k]
	jpeg(filename = outputFile, width = 8, height = 8,
		 units = "in", pointsize = 12, quality = 75, bg = "white",
		 res = 300, restoreConsole = TRUE) 					# create a jpeg file for plotting
	
	rx<-range(bMob,yMob,kMob)								# define the range of axes according to the highest value in the data
	ry<-range(bMZ,yMZ,kMZ)
	
	#rx<-range(0,200)										# alternatively, define fix range axes
	#ry<-range(0,1800)
		
	plot(rx,ry, xlab="Mobility", ylab="M_Z", main=title) 
		points(bMob,bMZ, col="blue")						# assign colours to each data series
		points(yMob,yMZ, col="green")
		points(kMob,kMZ, col="red")							
		lineb <- lm(bMZ ~ bMob) 							# fit linear regression for b and y ions
		liney <- lm(yMZ ~ yMob)
		linek <- lm(kMZ ~ kMob)
		abline(lineb, col = "blue")
		abline(liney, col = "green")
		abline(linek, col = "red")
	lm_b<-round(coef(lineb),3) 								#round the coef value to three decimal
	mtext(bquote("b Ions (blue)": y == .(lm_b[2])*x + .(lm_b[1])), adj=1, padj=0, side = 1, line = 3)
	lm_y<-round(coef(liney),3) 	
	mtext(bquote("y Ions (green)": y == .(lm_y[2])*x + .(lm_y[1])), adj=1, padj=0, side = 1, line = 4)
	lm_k<-round(coef(linek),3) 	
	mtext(bquote("2+ Ions (red)": y == .(lm_k[2])*x + .(lm_k[1])), adj=1, padj=0, side = 1, line = 2)
															# the above line is to display equations at the bottom right corner of the plot
	dev.off()												#close plotting device
}







 ionPlot("data/BSA_DAFLGSFLYEYSR_01-1000counts_9000MSres-export_simple.csv","data/BSA_DAFLGSFLYEYSR_01-1000counts_9000MSres-export_simple_out.jpg","DAFLGSFLYEYSR")
