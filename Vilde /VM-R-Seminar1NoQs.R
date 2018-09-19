###### 1.1
###### Running code in R

3 +
  5 +
  9

# Now see what happens when you highlight one of the three lines. As you should be able to see, the 
# equation in the console is unfinished until you enter the last line. R notes that your code seems
# to be finished, and ends the equation.

# It's the same here.

3 + (exp(4/12)*6)

     
# The 'plus' sign indicates that R is still waitiing for something - in this case, another bracket.
# You can also see the red X's down the side of the console (though this isn't present in some
# versions). They will clear up once we add in the bracket.


###### 1.2
###### Assigning value to objects

# Basic math is easy in R
3+5  
12/7
log(10)
exp(8)
sin(3.142)+cos(3.142/2)
5^2

# We can assign values to objects in r using the arrow '<-' or the equals sign. 
# Value to be assigned on the right, object on the left.
# To create <- push "alt + understrek", like to use <- instead of =. 

weight_kg <- 55
weight_kg

# Note that 'weight_kg' now appears in your environment.

# Rules for objects
# Cannot start with a number, case sensitive, cannot be fundamental functions
# 1OBJECT <- 1 is not possible, need to be 

OBJECT <- 1

# Let's try editing an object
weight_lb <- 2.2*weight_kg    
weight_kg <- 200                  #what is weight_lb now?

# To alter the actual value of weight_lb, you need to run the line of code that defines 
# weight_lb once more. Note the change in your values in the environment.

###### 1.2
###### Functions and their arguments
# functions are pre-defined scripts

b <- sqrt(9)
round(3.14159, 2) # rounding a number, you can put any amount of digits after the comma 

# If you need to understand how a function works, you can use 'args',
# itself a function. This shows you what values need to be plugged into
# a function to make it work.
args(round)  
args(as.HMSCdata)

# Sometimes this doesn't work though, for more complex functions. 
# So the full complexity of the function can be displayed using the following...
round
as.HMSCdata

# The help screen is also great... most of the time.
?round

# order doesn't matter if you name the arguments....

round(digits = 2, x = 3.14159)

# If you keep them in the order shown in the previous command, 
# you don't need to write 'x='. But if you'd rather learn the names of the arguments than the order
# that they go in, then you can write everything in the order you'd like, and long as you list the 
# arguments. It's also important to note that many function have arguments not commonly used
# that have default values you wish to change.

####### 1.3
####### Vectors
# A vector contains a group of values, either numbers or characters
weights_g <- c(50,60,65,82)
weights_g

# The function c() binds together items, which can be single integers/numbers/characters or vectors
# thereof, into a vector.
animals1 <- c("mouse", "rat", "dog")       

# The quotation marks are necessary. Try without them.

animals2 <- c(mouse, rat, dog)
# Error: object 'animals' not found, R will look through objects you have already defined  
# They do work if values are already assigned to your words.

mouse <- "House mouse"
rat <- "Massive rat"
dog <- "Pit bull"
animals2 <- c(mouse, rat, dog)

# You can also add multiple vectors together like this.
animals3 <- c(animals1, animals2)

animals3

# The following gives you information about your vectors
# Length of the vector 
length(weights_g)
length(animals3)

# Tells you if it is e.g numeric or character
class(weights_g)
class(animals3)

# Structure of the vector 
str(weights_g)
str(animals3)

# Editing vectors is easy
weights_g <- c(weights_g, 90) # adding at the end of the vector
weights_g <- c(30, weights_g) # adding at the beginning of the vector
weights_g


# Let's create a few mixed vectors
num_char <- c(1, 2, 3, 'a')                   # The characher "a" will here overrule the number - viktig om du plutselig har en bokstav i dataene dine
num_logical <- c(1, 2, 3, TRUE)               # TRUE and FALSE are boolean values, and are case sensitive.
char_logical <- c('a', 'b', 'c', TRUE)        
tricky <- c(1, 2, 3, '4')                     # 4 is read as a character 
tricky2 <- c('TRUE', TRUE)                    # TRUE is here read as a character 

# As you can see below, certain classes of values will overrule others
class(num_char)
class(num_logical)
class(char_logical)
class(tricky)
class(tricky2)

# class is an important function. Try running tricky2. Can you see any difference in the 2 TRUE values?
# Probably not. But 'class' tells you that you have an error (if you want boolean values).

####### 1.4
####### Subsetting vectors
animals <- c("mouse", "rat", "dog", "cat")
# You can select an item from your vectors easily, if you use (2) instead of [2], R will think its a function
animals[2]
# You can also reorder them based on your command
animals[c(3,2)]
# If you want to exclude certain values, you can use the minus sign.
animals[-c(3,2)]
# And if you want to find a certain animal, we can do that too.
animals[animals=="dog"]   # More on how this works later.
length(animals[animals=="dog"]) # how many times is "dog" in the vector

# Here you can construct a longer vector from your original vector
more_animals <- animals[c(1, 2, 3, 2, 1, 4)] # you choose from the original vector 
more_animals


weights_g <- c(21, 34, 39, 54, 55)
weights_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)]      
# This produces another vector using only your "true" objects.

# Let's identify all values above 50 - will result in a series of TRUE and FALSE 
weights_g > 50 
# You can see that this produces a vector of boolean values which dictate whether or not
# the corresponding value from the vector is above 50 or not.

weights_g[weights_g > 50] # You define what you want from your vector                    
# We add the above expression into our square brackets. This does the same as we have
# on line 176.

# Some more options.
weights_g[weights_g < 30 | weights_g > 50]
# | is the or function, so smaller then 30 OR larger then 50
weights_g[weights_g >= 30 & weights_g != 21]        
# & is the and function, and != is NOT equal to 

animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"]     # returns both rat and cat

# Next bit is a little tricky. Note that this returns which of the values on the left
# are found in the values on the right, not the other way around. Try reversing the vectors and see what
# happens.
animals %in% c("dog", "duck") 
# %in% is used when you want to check the whole vector in front, here "animals" - and check animals for "dog" and "duck"

# Now we produce a subset giving us the values that were marked true before.
animals[animals %in% c("rat", "cat", "dog", "duck")]

# New vector.
heights <- c(2, 4, 4, NA, 6)

# Let's try and find the average, mean cant deal with NA  
mean(heights)                                    

# We can't calculate the mean as there is an NA in the string, so we use the na.rm argument 
# to exclude NAs from the equation. NAs pop up for a number of reasons, one of the most common 
# being that a data import read something incorrectly.
mean(heights, na.rm = TRUE)
max(heights)
max(heights, na.rm = TRUE)

# You can also use the is.na function to extract those elements which are NAs.
# And you can add the ! in front of the function to isolate functions which are NOT. 
heights[is.na(heights)]  # number of NAs
heights[!is.na(heights)] # numbers that are NOT NA 

#### Exercises ####

# Rounding numbers: 
# Which of the following will give the same result?
# A. round(4.3111,2)
# B. round(digits=4.3111, x=2)
# C. round(digits=2, x=4.3111)

# A and C 

# Which of the following will give you the same result? 

fish <- c("trout", "perch", "bleak", "goldfish", "shark")

# A. fish[c(2,5)]
# B. fish[fish=="shark"|fish=="Perch"]
# C. fish[fish %in% c("perch", "bullhead", "nemo", "salmon", "shark")]
# D. fish [fish == "shark" & fish == "perch"]

# A and B 

#3. What is the class of the following vector?
# Ex3 <- c('TRUE', FALSE, FALSE, 'TRUE')

#CHALLENGE
#4. Reduce the following vector to only values below 10, then find the average in ONE LINE of R code.
challenge <- c(11,13,14,NA,3,7,2,8,12,NA,NA)




