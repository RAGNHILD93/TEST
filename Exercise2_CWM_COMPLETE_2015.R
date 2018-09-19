###################################################################################################
#__________________________________R for Community Ecology BI2034__________________________________
#_______Exercise 2 - Statistical methods in community ecology: Community weighted traits__________
###################################################################################################

#################################################################
# 1: Things that you should always start all your R-scripts with
#################################################################
#_____________________________________
#Remove junk from previous R sessions 
#_____________________________________
# This is in case that you have saved your workspace from previous session 
# (we DO NOT recommend you to save your workspace)
rm(list = ls()) 

#_____________
#set directory 
#______________
#Point out the address to the folders where you have the relevant data files:
#->Copy the lines from the crashcourse that worked for you last time. 
dat.dir <- "C:\\Users\\miavs\\Documents\\R\\BI2034\\2015\\Datafiles\\"
#Point out the address to the folders where you want your graphs to go:
#-> you dont need to do this step. I just always assign a directory to save my plots as well. 
plot.dir <- "C:\\Users\\miavs\\Documents\\R\\BI2034\\2015\\Plots\\"

#____________________
#Import datasets
#_____________________
traits_full = read.table (file=paste (dat.dir, "trait_data_full_2015.txt", sep=""), 
                          sep = "\t", header=T, as.is=T)
# Since the dataset from this is not fully ready yet, we will use the biomass data from 2013
# for this exercise
biomass2013 = read.table (file=paste (dat.dir, "CE2013.txt", sep=""), sep="", header=TRUE)
# Check that you have importet the right files
head(traits_full)
head(biomass2013)

#________________
#Libraries
#________________

#First time you use a package that is not part of the base R, you have to download this package.
#For me it works doing the following:
# to go to Bottom right window -> click on Packages -> choose Install packages
#In the Install packages window choose:
#Under "Install from" <- Repository (CRAN)
#Under packages write <- name of package (here either "plyr", "FD", "fBasics", "reshape2")
#When all the below packages are installted load them in by executing each of the below lines. 

#Import all relevant packages that you will use. For this exercise we will use the following:
library(plyr) # package relevant for rearranging of data.  
?plyr
library(FD) # package containing tools for functional ecology
?FD
library(fBasics)
?fBasics
library(reshape2) # to melt together two dataframes. 
??reshape2
?dcast


################################################################
# 2: Dataset cleaning and adjustments
################################################################
# There might be different typo's and other things to be corrected, eg., inconsequent naming etc.  
# In this step you should try to identity those things.
# Also this is where you prepare the data for analysis. For certain functions you often need a 
# distinct data-setup 
#____________
# Trait data
#_____________
names(traits_full)
head(traits_full)
# Data check
#___________
# Check wether we have 4 unique communities
unique(traits_full$community)
# Check whether we have 3 unique growth forms
unique(traits_full$GF)

#There is one mistake. DS is called booth "DS" and "dS". 
#Therefore We first have to identify where the problem is, then we can change it afterwards. 
#In what rows is habitat dS:
traits_full[traits_full$GF %in% "dS", ]
#Now we tell those rows to change dS to DS. 
traits_full[c(473, 474), 6] <- "DS"
#Check that we only have 4 categories of habitat now:
unique(traits_full$GF)

#Check species names. We know there should be 13 species. 
unique(traits_full$species)
#The problem here is difference in lower and upper case letters for betula nana. 
#This can be solved by the same method as before, og all letters can be changed to lower case:
#Make all species have the same names, make all the letters lower case:
traits_full[1] <- tolower(traits_full$species)  
head(traits_full)
unique(traits_full$species)

#_______________________________________
# Data exploration
#_______________________________________
#It is always a good idea to get an overview of what the data looks like beforehand. 
# A simple boxplot (which is the default plotting by R) illustrates that fine here.
head(traits_full)
#First convert community to a factor, otherwise the plot will not work. 
community <- factor(traits_full$community)
plot(community, traits_full$LA)
plot(community, traits_full$SLA)
plot(community, traits_full$LDMC)

#____________________________________________________________________
# Rearrange the data so that we get the mean trait per species
#____________________________________________________________________
#Then get the summaries of the trait data per species per habitat:
head(traits_full)
# First read about the function ddply from the plyr package. If you thought that Pivot tables were 
# smart but quite ennyoing to make, then this is the solution. This is smart, and easy to make!
?ddply
#ddply is a function that can the same as a pivot table. 

#A dataframe with means per species per community
head(traits_full)
trait.mean.per.species.community = ddply((traits_full), .(species, community), summarize, 
                                         height_mean= mean(height, na.rm=T),
                                         LA_mean = mean (LA,na.rm=T), 
                                         LDMC_mean = mean (LDMC,na.rm=T),
                                         SLA_mean = mean(SLA, na.rm=T))
#Check the newly made dataframe
trait.mean.per.species.community 

#Here we see that only Betula nana is present in all three communities, and to simplify things 
# we will here just work with an average trait per species:
trait.mean.per.species = ddply((traits_full), .(species), summarize, 
                               height_mean= mean(height, na.rm=T),
                               LA_mean = mean (LA,na.rm=T), 
                               LDMC_mean = mean (LDMC,na.rm=T),
                               SLA_mean = mean(SLA, na.rm=T))
#Check the newly made dataframe
trait.mean.per.species



#Now we have what corresponds to the effect trait. 
# Then to calculate CWM's we need to get species abundances and for that we use the biomass data.


#Biomass data
#________________
# For using the function ?dbFD that we will use late we need to reorganise the biomass data
# So that rows are sites and species are columns
#(now rownames are 12345..., and columnnames are very divers)
head(biomass2013)
# To modify the biomass data so we can calculate species abundances, we will use the funtion dcast 
# in the reshape2 package. 
?dcast

# We will first sort the data on linelevel, so species name is column name, 
# and row name corresponds to the lines (remember that lines are each transect)
head(biomass2013)
linedat = (dcast(biomass2013, line~species, sum, value.var="biomass"))[,-1]
head(linedat)
#Make a characterstring of the line names (here rownames), this is to use later
linenames = as.character((dcast(biomass2013, line~species, sum, value.var="biomass"))[,1])
linenames

# Rename the columns so we dont have full species names, but three first letters of 
# genus and species name: 
# First create species list and then make short names with Øysteins 
# homemade special equation, and change columnnames of the linedat:
# Go and fine the line in the COMPLETE file, and copy it in here. 
splist = sub("\\."," ", colnames(linedat)) #List species in community
newnames = paste(substr(make.cepnames(splist),1,3), substr(make.cepnames(splist),5,7), sep="_")
colnames(linedat) = tolower(newnames)
#Check out the first two columns:
linedat[1:8]

# Trait data and biomass data
#_____________________________
# Now rearrange the trait data so that it can be compared with our abundance data
# Because we are calculating community weighted means, we are using the means that we found before
trait.mean.per.species

# Name the rows with species names instead of numbers. The reason for this is that this is the way 
# the the function to calculate CWM's work. The function uses a species-by-species distance matrix.
# You don't need to bother too much about this, but if you want to understand it, read on the 
# specifications on the dbFD function. 
?dbFD
rownames(trait.mean.per.species)= trait.mean.per.species[,1]
#Check the changes that you made
trait.mean.per.species
# you see that you now have species names twice, because we named the rows with species names 
# instead of numbers.
# Therefore we have to remove first column now:
trait.mean.per.species = trait.mean.per.species[,-1]
trait.mean.per.species
# Change the species names so they correspond to columnnames of linedat
 # First make a species list from the newly created rownames:
# Go and find the line in the COMPLETE file, and copy it in here. 
splist1 = sub("\\."," ", rownames(trait.mean.per.species)) #List species in community
splist1
#Then use Øysteins home made line to get same naming as for the biomass data:
newnames1 = paste(substr(make.cepnames(splist1),1,3), substr(make.cepnames(splist1),5,7), sep="_")
newnames1
#then assign the newnames to the rownames:
rownames(trait.mean.per.species) = newnames1
trait.mean.per.species

#Extract the data from the community table that we need. We only need the biomass data (linedat)
#for the species we have traits for, which are the most abundant ones.  
reddat1 = linedat[,colnames(linedat) %in% rownames(trait.mean.per.species)] 
colnames(linedat)
colnames(reddat1)
rownames(trait.mean.per.species)
#To remove nardus stricta from the traitsdata
trait <- trait.mean.per.species[- 8,]
trait

################################################################
# 3:  Calculations of community weighted means (CWM)
################################################################


# Calculate relative abundances
#_____________________________
#To get the cwm's we first need to get the proportional abundance.
#We basically divide our biomass data with sums of abundance for each line, as the formula tells us.
# For this we will use the function rowSums()
?rowSums
abundance = reddat1/rowSums(reddat1) #Transform to proportional abundance
abundance
#remove NA's
which(is.na(rowSums(abundance))) #Check for lines with no species present
#This time we have no NA's
#Otherwise to remove NA's:
#props1 = props1[- 22,] #Remove empty line 22

# Calculate CWM's
#_________________
#Now we will calculate CWM's. For this we will use the dbFD package. 
?dbFD

# Run the dbFD funtion of the FD package with the traits and the proportional abundances.

fd = dbFD(trait, abundance) #The main function of the FD package

#Check out the results from the dfFD-function with str()
str(fd)
#in str() note where FDis and CWM are

#Put the results in a dataframe 
#_______________________________________
#To collect the data in a nice dataframe, extract the cwm data from the dbFD -analysis, and put 
#it together with a vector of the habitats. 
#Look at the community weighted means:
fd$CWM
fd$FDis

#First make a vector with habitat names
community = c(rep("H",5), rep("R",5), rep("SB",5), rep("WS",5))#New habitat vector

#Collect it all in one dataframe, with the use of linenames that we created earlier:
FDdata_cwm = data.frame(linenames, community, fd$CWM, FDis = fd$FDis)
FDdata_cwm 
#Now we have a dataframe with cwm and functional dispersion (FDis). 


################################################################
# 4:  Plot the data 
################################################################

# Plot the data to look at interspecific variation of the community weighted means
#___________________________________________________________________________________

#Make a boxplot from the newly made dataframe
# Because community is a character this has to be converted to a factor to be able to plot it.
FDdata_cwm 
community <- factor(FDdata_cwm$community)
plot(community, FDdata_cwm$LA_mean)

# To add axis labels and a title:
plot(community, FDdata_cwm$LA_mean, xlab = "Community", ylab= "CWM LA(mm^2)", 
     main= "Community versus CWM_LA")
#To get milimeters squared use the expression-function before the axis name:
?expression()
plot(community, FDdata_cwm$LA_mean, xlab = "Community", 
     ylab= expression(CWM ~ LA (mm^2)), main= "Community versus CWM_LA")

#This is a line to play around with what you can do in the axis table. 
plot(1:10, xlab=expression('hi'[5]*'there'[6]^8*'you'[2]))


################################################################
# 5a:  Simple statistics - ANOVA and Tukey
################################################################

#Perform an analysis of variance (ANOVA)
#________________________________________
# Test if there is a statistically significant difference between the 4 communities
# community is going to be the explanatory variable 
# CWM_LA is going to be the response variable
# null hypothesis: there is no difference between the means of CWM_LA
# alternative hypothesis: there will difference between means of CWM_LA
# The ANOVA is basically testing wether the variance among the samples is bigger or smaller
# than the variance between the samples. 
# aov() is the function for a one-way ANOVA in R. 

?aov()
anova1 <- aov(lm(LA ~ community, data=FDdata_cwm))
summary(anova1)

# Here is the results that I got:

# Df Sum Sq Mean Sq F value   Pr(>F)    
# community    3 191344   63781    10.4 0.000487 ***
#  Residuals   16  98133    6133                     
#---
#  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

#What you should read from this is the "Pr(>F) " which corresponds to the p-value. 
#In this case we can conclude that there is a significant difference between the means of
# the three communities because pr(>F)=0.000487, thus p < 0.0005.

# However We CANNOT conclude anything on where the differences are. 
# Therefore that we should perform a post hoc test, such as a Tukey HSD test

#Perform a Tukey HSD test
#_______________________
#This is the function for a Tukeys test: TukeyHSD()
?TukeyHSD
tukey1 <- TukeyHSD(anova1)
tukey1

#These were my results:
#Tukey multiple comparisons of means
#95% family-wise confidence level

#Fit: aov(formula = lm(LA ~ community, data = FDdata_cwm))

#$community
#diff         lwr      upr     p adj
#R-H   -21.84374 -163.553348 119.8659 0.9704107
#SB-H   83.79115  -57.918463 225.5008 0.3597370
#WS-H  227.36882   85.659213 369.0784 0.0015462
#SB-R  105.63489  -36.074722 247.3445 0.1849698
#WS-R  249.21256  107.502953 390.9222 0.0006406
#WS-SB 143.57768    1.868068 285.2873 0.0465044

# Here you should look at the "p adj" to get the p-value. 
# Which community traits are significantly different from each other?

################################################################
# 5b:  Simple statistics - linear model lm()
################################################################

# Make a simple correlation and plot it. 
#______________________________________________________________________________________________
#Make a linear model to see how CWM_LA and CWM_height are correlated. 
#A linear model is basically where we fit a straight line to the datapoints, and we get a measure
#on how well this straight line fits the data. 
#In physics and math we often can get r2 close to 1, and when r2=1 the straight line fits perfect to 
#The data points. 
#In biology and ecology however, we are just happy when r2 is above 0.5. Because that means that 
#there is more than a random relationship between the two variables. 
#To do a linear model or a correlation on two variables,you first have to plot the data, and then 
#use the function lm(). Because the values are so different in size for the two variables we will 
#additionally log-transform them,  

#--Plot LA against height:

plot(FDdata_cwm$height ~ FDdata_cwm$LA)

#-- Use lm() to make a regression line and extract the r2 values, by using abline() and summary() 
# on the linear model 
?lm()
#To be able to extract values from the lm() function we need to name our model, say m. 
m <- lm(height ~ LA, data=FDdata_cwm)
abline(m)
summary(m)
rsqd <- summary(m)$r.sq
rsqd
#To add the r2 value on the plot use bquote()
mylabel = bquote(italic(R)^2 == .(format(rsqd, digits = 3)))
legend('top', legend = mylabel, bty = 'n')
# To check whether all the assumptions of the linear models are correct 
plot(m)
#Click in the console with the curser and hit enter.

################################################################
# 6:  Assignments
################################################################

# 1) Calculate community weighted variance for the 4 leaf traits. 
# (use the same method as for means, but use variances instead of means)
# Extra challange: see if you can do means and variance in the same step. 


# 2) Is CWM_height correlated with CWM_LDMC?
# What is r2? 

