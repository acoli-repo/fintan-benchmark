### INIT GGPLOT ###
# load package and data
library(ggplot2)
#data(mpg, package="ggplot2") # alternate source: "http://goo.gl/uEeRGu")
theme_set(theme_bw())  # pre-set the bw theme.

### READ TSV ###
# https://bjoernwalther.com/daten-in-r-importieren/

tsv <- read.table("statistics.tsv", sep="\t", header=TRUE, dec=".")



# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}













############ NOTES ###########################


### CREATE SUBSETS ###

epyc_avg_50 <- subset(tsv, tsv$cpu=="epyc" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")


### PLOT graphs ###
# https://r-coder.com/line-graph-r/

# fill variables from tsv
x <- epyc_avg_50$thr
y <- epyc_avg_50$time
x2 <- epyc_avg_50$log

# plot graph / first line
# add more lines or curves

# First line
plot(x, y, type = "l")

# Second line
lines(x2, y, type = "l", col = 2) # Same Y values

# Legend
legend("topleft", legend = c("line 1", "line2"), lty = 1, col = 1:2)


### CREATE FUNCTIONS ###
# https://www.dataquest.io/blog/write-functions-in-r/
plot_subset <- function(src, col1, col2) {
	x <- epyc_avg_50$col1
	y <- epyc_avg_50$col2
	plot(x, y, type = "l")
}

############# NOTES END #######################






########## PLOT time/threads @ Size50 FOREACH server/strategy #########
#200 tp
subs <- subset(tsv, tsv$cpu=="epyc" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")
plot(subs$thr, subs$time, type = "o", xlim = c(0, 128), ylim = c(0, 800)
		, xlab="Threads on 50*200K triples", ylab="Execution time (sec)")

subs <- subset(tsv, tsv$cpu=="xeon" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=2)

subs <- subset(tsv, tsv$cpu=="ryzen" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=3)

subs <- subset(tsv, tsv$cpu=="aplm2" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=4)

subs <- subset(tsv, tsv$cpu=="i7q-vm" & tsv$strategy=="###AVG#CORPUS#200tp##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=5)

#200K tp
subs <- subset(tsv, tsv$cpu=="epyc" & tsv$strategy=="###FULL#CORPUS#200K##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=1)

subs <- subset(tsv, tsv$cpu=="xeon" & tsv$strategy=="###FULL#CORPUS#200K##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=2)

subs <- subset(tsv, tsv$cpu=="ryzen" & tsv$strategy=="###FULL#CORPUS#200K##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=3)

subs <- subset(tsv, tsv$cpu=="aplm2" & tsv$strategy=="###FULL#CORPUS#200K##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=4)

subs <- subset(tsv, tsv$cpu=="i7q-vm" & tsv$strategy=="###FULL#CORPUS#200K##" & tsv$siz=="50")
lines(subs$thr, subs$time, type = "o", col=5)

legend("topright", legend = c("epyc","xeon","ryzen","aplm2","i7q-vm"), lty = 1, col = 1:5)


##GGPLOT Fintan time/threads @size=20 FOREACH strategy
##(can be adjusted to display single lines per processor)
subs <- subset(tsv, 
			tsv$cpu=="xeon" & 
			tsv$siz==20 &
			(	(
					tsv$comment!="-- heap space" 
					& (
						tsv$strategy=="arq.update" 
						| tsv$strategy=="tdb.tdbupdate"
						| tsv$strategy=="tdb2.fuseki"
					)
					& tsv$tool=="arq5.1"
				) | (	
					(tsv$strategy=="###FULL#CORPUS#200K##" | tsv$strategy=="###AVG#CORPUS#200tp##") 
				)
				& tsv$thr<=tsv$log
			)
		)
arqMax <- subset(subs, subs$strategy=="arq.update")
tdbMax <- subset(subs, subs$strategy=="tdb.tdbupdate")
tdb2Max <- subset(subs, subs$strategy=="tdb2.fuseki")

ggplot(subs, aes(x=thr, y=time)) + 
	geom_line(aes(color=strategy)) +
	geom_point(aes(color=strategy)) +
	geom_hline(yintercept=arqMax$time) +
	geom_hline(yintercept=tdbMax$time) +
	geom_hline(yintercept=tdb2Max$time) +
	#geom_smooth(aes(color=strategy), method="lm", se=T) +
	#geom_smooth(aes(color=strategy), se=T) +
	scale_color_manual(name='Strategy',
		labels=c('280 tp partitions', '200K tp partitions', 'ARQ 5.1', 'TDB Fuseki 5.1', 'TDB2'),
        values=c('red', 'purple', 'steelblue', "green", "lightgreen")) +
	labs(title=paste("Fintan scalability for CPU '",subs$cpu,"' on dataset size ",c(subs$siz)), 
		subtitle="Performance with increasing updater threads", 
		y="Execution time (sec.)", 
		x="Updater threads", 
		caption="Source: fintan-eval")


##GGPLOT Fintan time/threads @size=50 FOREACH cpu
##(switch between FULL and AVG)
subs <- subset(tsv, 
			#tsv$cpu=="xeon" & 
			(	
				#tsv$strategy=="###FULL#CORPUS#200K##" 
				tsv$strategy=="###AVG#CORPUS#200tp##" 
				& tsv$siz==50
				#& tsv$thr<=tsv$log
			)
		)
ggplot(subs, aes(x=thr, y=time)) + 
	geom_line(aes(color=cpu)) +
	geom_point(aes(color=cpu)) +
	#geom_smooth(aes(color=cpu), method="lm", se=T) +
	#geom_smooth(method="lm", se=T) +
	scale_color_manual(values=c('purple', 'red', 'steelblue', "green", "blue"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Machine',
		labels=c('Apple M2 8/4 16GB', 'AMD Epyc 2*32/64 1TB', 'Intel i7 4/4 16GB', 'AMD Ryzen 6/12 32GB', 'Intel Xeon 2*24/48 1TB')
       ) +
	labs(
		title=paste("Fintan scalability (small segments) on dataset size ",c(subs$siz)), 
		#title="Fintan scalability (large segments)", 
		subtitle="Performance with increasing updater threads", 
		y="Execution time (sec.)", 
		x="Updater threads", 
		caption="Source: fintan-eval")












########## PLOT Time / Size #########


##GGPLOT ARQ versions
subs <- subset(tsv, (
						tsv$strategy=="arq.update" 
						#| tsv$strategy=="arq.update.256" 
						#| tsv$strategy=="arq.update.512"
					) & tsv$comment!="-- heap space")
ggplot(subs, aes(x=siz, y=time)) + 
	geom_smooth(aes(color=tool), se=T) +
	scale_color_manual(values=c('purple', 'green', "steelblue", "blue", "lightblue"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Apache Jena version',
		#labels=c('Apple M2 8/4 16GB', 'Intel i7 4/4 16GB', 'AMD Ryzen 6/12 32GB', 'Intel Xeon 2*24/48 1TB')
       ) +
	labs(title="ARQ versions in comparison", 
		subtitle="Performance with increasing dataset size", 
		y="Execution time (sec.)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval")


##GGPLOT ARQ per processor
subs <- subset(tsv, tsv$strategy=="arq.update" & tsv$tool=="arq5.1" & tsv$comment!="-- heap space")
ggplot(subs, aes(x=siz, y=time)) + 
	geom_line(aes(color=cpu)) +
	geom_point(aes(color=cpu)) +
	geom_smooth(method="lm", se=T, color=1) +
	scale_color_manual(values=c('purple', 'steelblue', "green", "blue"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Machine',
		labels=c('Apple M2 8/4 16GB', 'Intel i7 4/4 16GB', 'AMD Ryzen 6/12 32GB', 'Intel Xeon 2*24/48 1TB')
       ) +
	labs(title="ARQ scaling on various CPUs", 
		subtitle="Performance with increasing dataset size", 
		y="Execution time (sec.)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval")

##GGPLOT TDB vs ARQ vs Fintan strategies 
##(can be adjusted to display single lines per processor)
subs <- subset(tsv, 
			tsv$cpu=="i7q-vm" & 
			#tsv$cpu=="xeon" & 
			#tsv$cpu=="ryzen" & 
			(	(
					tsv$comment!="-- heap space" 
					& (
						tsv$strategy=="arq.update" 
						| tsv$strategy=="tdb.tdbupdate"
						| tsv$strategy=="tdb2.fuseki"
					)
					& tsv$tool=="arq5.1"
				) | (	
					(tsv$strategy=="###FULL#CORPUS#200K##" | tsv$strategy=="###AVG#CORPUS#200tp##") 
					& tsv$thr==tsv$log
			)	)
		)

tdb2Max <- subset(subs, subs$strategy=="tdb2.fuseki")
arqMax <- subset(subs, subs$strategy=="arq.update")
		
ggplot(subs, aes(x=siz, y=time)) + 
	geom_point(fill="grey", color="red", shape=23, size=10, x=max(tdb2Max$siz), y=max(tdb2Max$time)) +
	geom_point(fill="grey", color="red", shape=23, size=10, x=max(arqMax$siz), y=max(arqMax$time)) +
	#geom_line(aes(color=strategy)) +
	geom_point(aes(color=strategy)) +
	#geom_smooth(aes(color=strategy), method="lm", se=T) +
	geom_smooth(aes(color=strategy), se=T) +
	scale_color_manual(values=c('red', 'purple', 'steelblue', "green", "lightgreen"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions', '200K tp partitions', 'ARQ', 'TDB1', 'TDB2 Fuseki 5.1')
       ) +
	#scale_fill_discrete(limits=c('TDB', 'ARQ', '200K tp partitions','280 tp partitions'))+
	labs(title="ARQ compared to Fintan", 
		subtitle="Performance with increasing dataset size", 
		y="Execution time (sec.)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval")




########## PLOT Memory / Size #########

##GGPLOT TBD vs ARQ vs Fintan strategies 
##(can be adjusted to display single lines per processor)
subs <- subset(tsv, 
			tsv$cpu %in% list("xeon", "xeon256", "xeon512")
			#tsv$cpu=="xeon" 
			#tsv$cpu=="i7q-vm" 
			&(	(
					tsv$comment!="-- heap space" 
					& (
						tsv$strategy=="arq.update" 
						| tsv$strategy=="arq.update.256" 
						| tsv$strategy=="arq.update.512"
						| tsv$strategy=="tdb2.fuseki"
					)
					& (
						tsv$tool=="arq5.1"
						| tsv$tool=="arq5.1-Xmx256g"
						| tsv$tool=="arq5.1-Xmx512g"
					)
				) | (	
					(tsv$strategy %in% list("###FULL#CORPUS#200K##", "###AVG#CORPUS#200tp##")) 
					& tsv$thr==tsv$log
			)	)
		)
ggplot(subs, aes(x=siz, y=mem)) + 
	#geom_line(aes(color=strategy)) +
	geom_point(aes(color=strategy)) +
	#geom_smooth(aes(color=strategy), method="lm", se=T) +
	geom_smooth(aes(color=strategy), se=T) +
	scale_color_manual(values=c('red', 'purple', 'steelblue', "lightblue", "blue", "green"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions', '200K tp partitions', 'ARQ default', 'ARQ Xmx256g', 'ARQ Xmx512g', 'TDB2 Fuseki')
       ) +
	labs(title="ARQ compared to Fintan", 
		subtitle="Memory consumption with increasing dataset size", 
		y="Memory consumption (GB)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval")




####BARPLOT SPEED
subs <- subset(tsv, 
			tsv$cpu %in% list("xeon", "xeon256", "xeon512")
			#tsv$cpu=="xeon" 
			#tsv$cpu=="i7q-vm" 
			&siz %in% list(10,30,50)
			&(	(
					#tsv$comment!="-- heap space" &
					(
						tsv$strategy=="arq.update" 
						| tsv$strategy=="arq.update.256" 
						| tsv$strategy=="arq.update.512"
						| tsv$strategy=="tdb2.fuseki"
					)
					& (
						tsv$tool=="arq5.1"
						| tsv$tool=="arq5.1-Xmx256g"
						| tsv$tool=="arq5.1-Xmx512g"
					)
				) | (	
					(tsv$strategy %in% list("###FULL#CORPUS#200K##", "###AVG#CORPUS#200tp##")) 
					& tsv$thr==tsv$log
			)	)
		)

ggplot(subs, aes(x=siz, y=time, fill=strategy)) +
	geom_bar(aes(fill=strategy), stat = "identity", position="dodge", width=18) +
	#geom_col(position="dodge") +
	geom_text(aes(label = paste(time,"s")), vjust = -0.5, colour = "black", size=2.9, position = position_dodge(18)) +
	scale_fill_manual(values=c('red', 'purple', 'steelblue', "lightblue", "blue", "green"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions', '200K tp partitions', 'ARQ default', 'ARQ Xmx256g', 'ARQ Xmx512g', 'TDB2 Fuseki 5.1')
	   ) +
	labs(title="ARQ compared to Fintan", 
		subtitle="Performance with increasing dataset size", 
		y="Execution time (sec.)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval") +
	theme_minimal()
  

####BARPLOT MEM
subs <- subset(tsv, 
			tsv$cpu %in% list("xeon", "xeon256", "xeon512")
			#tsv$cpu=="xeon" 
			#tsv$cpu=="i7q-vm" 
			&siz %in% list(10,30,50)
			&(	(
					#tsv$comment!="-- heap space" &
					(
						tsv$strategy=="arq.update" 
						| tsv$strategy=="arq.update.256" 
						| tsv$strategy=="arq.update.512"
						| tsv$strategy=="tdb2.fuseki"
					)
					& (
						tsv$tool=="arq5.1"
						| tsv$tool=="arq5.1-Xmx256g"
						| tsv$tool=="arq5.1-Xmx512g"
					)
				) | (	
					(tsv$strategy %in% list("###FULL#CORPUS#200K##", "###AVG#CORPUS#200tp##")) 
					& tsv$thr==tsv$log
			)	)
		)

ggplot(subs, aes(x=siz, y=mem, fill=strategy)) +
	scale_x_continuous(breaks=seq(10,50,20), labels=c("10 datasets", "30 datasets", "50 datasets")) +
	geom_bar(aes(fill=strategy), stat = "identity", position="dodge", width=18) +
	#geom_col(position="dodge") +
	geom_text(aes(label = paste(mem,"GB")), vjust = -0.5, colour = "black", size=2.9, position = position_dodge(18)) +
	scale_fill_manual(values=c('red', 'purple', 'steelblue', "lightblue", "blue", "green"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions', '200K tp partitions', 'ARQ default', 'ARQ Xmx256g', 'ARQ Xmx512g', 'TDB2 Fuseki 5.1')
	   ) +
	labs(title="ARQ compared to Fintan", 
		subtitle="Memory consumption with increasing dataset size", 
		y="Memory consumption (GB)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval") +
	theme_minimal()



###MULTIPLOT



subs <- subset(tsv, 
			tsv$cpu %in% list("xeon", "xeon256", "xeon512")
			#tsv$cpu=="xeon" 
			#tsv$cpu=="i7q-vm" 
			&siz %in% list(10,30,50)
			&(	(
					#tsv$comment!="-- heap space" &
					(
						tsv$strategy=="arq.update" 
						| tsv$strategy=="arq.update.256" 
						| tsv$strategy=="arq.update.512"
						| tsv$strategy=="tdb2.fuseki"
					)
					& (
						tsv$tool=="arq5.1"
						| tsv$tool=="arq5.1-Xmx256g"
						| tsv$tool=="arq5.1-Xmx512g"
					)
				) | (	
					(tsv$strategy %in% list("###FULL#CORPUS#200K##", "###AVG#CORPUS#200tp##")) 
					& tsv$thr==tsv$log
			)	)
		)
		
####BARPLOT SPEED
p_time <- ggplot(subs, aes(x=siz, y=time, fill=strategy)) +
	geom_bar(aes(fill=strategy), stat = "identity", position="dodge", width=18) +
	#geom_col(position="dodge") +
	geom_text(aes(label = paste(time,"s")), vjust = -0.5, colour = "black", size=2.9, position = position_dodge(18)) +
	scale_fill_manual(values=c('red'
			, 'purple'
			, 'steelblue'
			, "lightblue"	#remove for i7q-vm
			, "blue"		#remove for i7q-vm
			, "green"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions'
			, '200K tp partitions'
			, 'ARQ default'
			, 'ARQ Xmx256g'	#remove for i7q-vm
			, 'ARQ Xmx512g'	#remove for i7q-vm
			, 'TDB2 Fuseki 5.1')
	   ) +
	labs(title="ARQ compared to Fintan", 
		subtitle="Performance with increasing dataset size", 
		y="Execution time (sec.)", 
		x="Datasets (200K triples)") +
	theme_minimal() +
	theme(axis.title.x = element_blank()
		#, axis.title.y = element_blank()
		, axis.text.x = element_blank()
		, axis.ticks.x = element_blank()
		, plot.margin = unit(c(2,1,0,1), "mm"))
		
####BARPLOT MEM
p_mem <- ggplot(subs, aes(x=siz, y=mem, fill=strategy)) +
	scale_y_reverse(limits=c(100,0)) +
	geom_bar(aes(fill=strategy), stat = "identity", position="dodge", width=18) +
	#geom_col(position="dodge") +
	geom_text(aes(label = paste(mem,"GB")), vjust = 1.5, colour = "black", size=2.8, position = position_dodge(18)) +
	scale_fill_manual(values=c('red'
			, 'purple'
			, 'steelblue'
			, "lightblue"	#remove for i7q-vm
			, "blue"		#remove for i7q-vm
			, "green"),
	#scale_colour_grey(start = 0.0, end = .9,
		name='Strategy',
		labels=c('280 tp partitions'
			, '200K tp partitions'
			, 'ARQ default'
			, 'ARQ Xmx256g'	#remove for i7q-vm
			, 'ARQ Xmx512g'	#remove for i7q-vm
			, 'TDB2 Fuseki 5.1')
	   ) +
	scale_x_continuous(breaks=seq(10,50,20), labels=c("10 datasets", "30 datasets", "50 datasets")) +
	labs(y="Memory consumption (GB)", 
		x="Combined dataset size (1 ds = 235.217 triples)", 
		caption="Source: fintan-eval") +
	theme_minimal() +
	theme(legend.position="bottom"
		#, axis.title.x = element_blank()
		#, axis.title.y = element_blank()
		, axis.text.x = element_text(face = 'bold')
		#, axis.ticks.x = element_line(color = 'black', size = 1.25, linetype = 2)
		#, axis.line.x = element_line(color = 'black', size = 1.25, linetype = 2)
		, plot.margin = unit(c(2,42.6,1,1), "mm"))

multiplot(p_time, p_mem)
