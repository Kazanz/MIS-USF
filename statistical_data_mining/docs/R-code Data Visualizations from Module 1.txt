##Note: the symbol "#" denotes a comment and everything that follows
##after that symbol - within the same line - will be ignored by R


##Let's assume that you have saved the datafile "HousePrices.csv" in
##the directory "MyData" on your C-drive; i.e assume it's located in
##C:\\MyData. Then, we first have to point R to this directory; we
##do this with the command "setwd()"

setwd("C:\\MyData");

data <- read.csv("HousePrices.csv");
attach(data);

# Histograms:
    hist(Price,  xlim=c(60000,80000))

# Boxplots:
    boxplot(Price,horizontal=T)   # if  'horizontal=T', the boxplot should be horizontal.

# Side-by-side boxplots
    library(lattice)
    bwplot(Price~Brick)

# Scatterplots:
    plot(Price~SqFt);
    library(lattice);
    xyplot(Price~SqFt|Bedrooms);
    xyplot(Price~SqFt|Brick*Neighborhood);

# Scatterplot Matrices:
    pairs(Price~SqFt+Bedrooms+Bathrooms+Offers);

##correlation matrix
  cor(data[,2:6]);

##visualizing the correlation matrix
  library(ellipse);
  cor.data <- cor(data[,2:6]);
  plotcorr(cor.data);

##And a very powerful scatterplot matrix
  library(YaleToolkit);
   gpairs(data[,2:6], upper.pars=list(scatter="stats"));

# 3-d Scatterplots:
    library(lattice)
    cloud(Price~SqFt+Bedrooms)

#Some summary statistics
mean(Price)

median(Price)

range(Price)

sd(Price)

summary(Price)

quantile(Price,probs=seq(0,1,0.25))