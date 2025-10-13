#'---
#'Data-analysis module
#'13 October 2025
#'Introduction
#'---

#======================#

## Setting directory

#======================#

# search directory
getwd()

# create a directory for the exercise folder
dir.create("exercise_1") # creating directory

# set working directory
setwd("exercise_1")

# Check directory again
getwd()

# To remove all objects in the environment
rm(list = ls())

#========================================================#

## A few line of code demonstrate the layout of Rstudio

#========================================================#

a <- c(1,2,3,4,5) # assign a vector of values  1 to 5
b <- 1:5
c <- seq(from = 1, to = 5)
plot(x = a, y = b) # plot the relationship of a and b
?plot

# Show time in my computer
Sys.time()

# Force the system to use English
Sys.setenv(LANG="en")

# Create a variable and assign a value
area <- 2*5
height <- 6.1
volume <- area * height
volume # to see the value printed in the console

# New values can be assigned to variables (updating variable)
height <- 6.5
volume <- area * height
volume

#' working with operators
a <- c(1, 2, 3, 4, 5)
a - a
a + a 
a + 1
a/10
log(a)
exp(log(a))
a - 1 * 10^2 # R honors the order of operations
(a - 1)* 10^2

#' check the type and structure of objects
a <- c(1, 2, 3, 4, 5) # combine function create numeric (double) by default
str(a)
typeof(a)

b <- 1:5 # colon operator creates an integer sequence by default
str(b)
typeof(b) # integers can't have decimals; consume less memory

#' check the type and structure of objects
a
"a"
str("a")
text1 <- "hello"
text2 <- "world!"
paste(text1, text2)
paste("Ecosystem", "Atmosphere", sep = "-")

#' check the type of objects
1 == 1 # is 1 equal to 1?
1 >= 2 # is 1 equal to or greater than 2?
a == b # is each of the elements of a equal to those of b?
logi1 <- c(TRUE, FALSE) # assign a logical vector
as.numeric(logi1) # logical data can be converted to numeric

#' data type conversion
as.numeric("7.11")
as.logical("TRUE")
as.character()
as.numeric("Hello")

#' Special (NA- not available, NaN- Not a Number, and NULL- Nothingness)
n <- c(1, NA, NaN, 3) # missing data
sum(n) # arithmetic operations involving NA return NA
sum(n, na.rm = TRUE) # the argument na.rm = TRUE removes NA- and NaN- values before summing.

#========================================================#

## Vectors, lists, matrices, data frames and arrays

#========================================================#

#' Vectors
vec1 <- c("a", 2)
str(vec1) # numeric data was converted to character data
vec2 <- c("a", "3")
vec3 <- c(vec1, vec2) # combine two vectors
length(vec3) # vec3 is of length 4
vec3[3] # the third member of vec3 is "a
vec3[1] <- "EKA" # replace the first member of vec3 with the character string "EKA"
vec3

#' Lists
list1 <- list("a", 2)
str(list1) # both members retained their original types
str(list1[2]) # members of lists are also lists
list2 <- list("b", "c", c(3, 4, 5)) # Lists can hold objects of different lengths
list2
list2[[3]][[2]] # Access the third list member's second value
c(list1, list2) # Lists can be concatenated

#' Data frames
#' when creating data frames, you specify names for your variables:
x <- data.frame(variable1 = c(1, 2),
                variable2 = c("a", "b"))
x

## create a new data frame with variables 'name' and 'race'
creatures <- data.frame(name = c("Frodo", "Arwen", "Shelob"),
                        race = c("hobbit", "elf", "spawn of Ungoliant"))

## dividing long expressions on multiple rows helps maintain the readability of your code.
creatures$legs <- c(2, 2, 8) # add a new column
creatures$exists <- FALSE # vectors of length 1 are rotated to fill the column
creatures

str(creatures)
creatures[2, ] # second row

creatures[3, c(3, 4)] # row 3, columns 3 and 4
creatures$name[3] # third name in the data frame

str(rbind(creatures, creatures)) # combine data frames and look at the structure
str(cbind(creatures, creatures)) # combine columns
rbind(creatures, creatures) # stack rows
cbind(creatures, creatures) # combine columns

names(creatures) # Access the name of your variables names()
names(creatures)[2] <- "species" # change second column name
creatures
names(creatures) <- c("ID name", "R", "L", "E") # change column names
creatures

#' Matrices
data <- 1:12 # some data to fill the matrix
matrix(data, ncol = 4) # create a matrix with 4 columns
matrix(data, nrow = 3) # create a matrix with 3 rows
mat <- matrix(data, nrow = 3, byrow = TRUE) # insert data row-by-row
mat <- t(mat) # transpose (flip) matrix (flip the rows with columns)

colnames(mat) <- c("Neo", "Morpheus", "Trinity") # Name the columns of the matrix
mat

rownames(mat) <- c("B", "L", "D", "E") # Name the rows of the matrix
mat

rbind(mat[, "Trinity"], mat[, 3]) # can call by either name or position of the column

#' Arrays
arr <- array(data, dim = c(3, 2, 2)) # array has 3 rows, two columns and two "layers"
arr

#================#

## R packages

#================#

install.packages("<package name>")
install.packages("ggplot2")
library(ggplot2)

install.packages("cowsay") # install the cowsay tool
library(cowsay)
say("Hello!")










