# Part 2: Data from Social Media

## 2.1: Web data collection 
library(rvest)
library(stringr)

file_name <- "C:/Users/Nazira/Desktop/Rome classes/SMAN/SMAN_Project_Nazira/instanew.html"
i_doc <- read_html(file_name, encoding = "UTF-8") # reading html

# extracting info from each post: URL and PostText
posts <- i_doc %>%
  html_nodes("div._ac7v") %>%
  lapply(function(post) {
    url <- post %>% html_node("a") %>% html_attr("href")
    post_text <- post %>% html_node("div._aagu") %>% html_node("img") %>% html_attr("alt")
    data.frame(URL = url,PostText = post_text)
  })

final <- do.call(rbind, posts) # combining all 
myfile <- "instagram_posts_raw.csv" # raw data
write.csv(final, myfile, row.names = FALSE) # saving to CSV

## 2.2: Data Cleaning/Preprocessing & Feature Engineering
df <- read.csv("C:/Users/Nazira/Desktop/Rome classes/SMAN/instagram_posts_raw.csv")

# getting rid of non-necessary observations that include ads
ads <- c(14,15,16,31,32,33,35,47,48,49,51,61,62,67,69,79,
                    80,89,95,96,105,111,114,115,121,127,130,131,
                    134,135,136,141,145,146,149,150,151,156,158,
                    162,165,172,174,178,181,186,189,195,202,
                    206,207,214,215)
df <- df[-ads, ]

## Feature Engineering:
df$Author <- regmatches(df$PostText, regexpr("^(.*?) \\|", df$PostText, perl = TRUE))

df$Description <- regmatches(df$PostText, regexpr("\\| (.+?) \\|", df$PostText, perl = TRUE))
df$Description <- trimws(df$Description) # removing leading and trailing spaces

df$Price <- gsub(".*💶[ ~]*(\\d+).*", "\\1", df$PostText)
df$Price <- as.numeric(gsub(",", "", df$Price)) # removing commas, converting to numerical

df$Price[5] <- 11000 # i manually changed to 11000 since original price was presented as 11 000
df$Price <- as.numeric(df$Price) # to numerical
df$Price[df$Price == 11] <- 11000

df$City <- 'Warsaw' # constant for every observation

library(dplyr)

# extracting number of rooms to a new column 'Rooms'
df <- df %>%
  mutate(Rooms = as.numeric(str_extract(Description, "\\d+")),
         Rooms = ifelse(is.na(Rooms), 1, Rooms))

df <- df %>%
  mutate(EstateType = ifelse(grepl("Квартира", Description), "Квартира", "Комната"))

df <- df %>%
  mutate(Address = sub(".*[🚩📍]\\s*[^,]+\\s*,\\s*([^,]+).*", "\\1", PostText))
df <- df %>%
  mutate(Address = str_extract(Address, "\\b\\w+\\b"))

df$EstateType <- ifelse(df$EstateType == "Квартира", "Apartment", "Room")

write.csv(df, "insta_df.csv", row.names = FALSE)

# The dataset is ready and saved into 'insta_df.csv'

## 2.3: Visualization
dfs <- df[,c('EstateType', 'Rooms', 'Address', 'City', 'Price')]

library(ggplot2)

# Plot 1: Histogram for Price
ggplot(dfs, aes(x = Price)) +
  geom_histogram(binwidth = 500, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Prices", x = "Price", y = "Frequency")

# Plot 2: Boxplot for the Number of Rooms
ggplot(dfs, aes(y = Rooms)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(title = "Boxplot of Number of Rooms", y = "Number of Rooms")

# Plot 3: Bar plot for EstateType
ggplot(dfs, aes(x = EstateType, fill = EstateType)) +
  geom_bar() +
  labs(title = "Distribution of Estate Types", x = "Estate Type", y = "Count")

# Plot 4: Bar plot for Apartments Region 
ggplot(dfs, aes(x = Address, fill = Address)) +
  geom_bar() +
  labs(title = "Distribution of Properties by Region", x = "Address", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot 5: Scatter plot for Rooms vs Price
ggplot(dfs, aes(x = Rooms, y = Price)) +
  geom_point(color = "darkorange") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Scatter plot of Rooms vs Price", x = "Number of Rooms", y = "Price")

# Plot 6: Boxplot for EstateType vs Price
ggplot(dfs, aes(x = EstateType, y = Price, fill = EstateType)) +
  geom_boxplot() +
  labs(title = "Boxplot of Estate Type vs Price", x = "Estate Type", y = "Price")

# Plot 7: Violin plot for EstateType vs Price
ggplot(dfs, aes(x = EstateType, y = Price, fill = EstateType)) +
  geom_violin() +
  labs(title = "Violin plot of Estate Type vs Price", x = "Estate Type", y = "Price")

# Plot 8: Boxplot for Address vs Price (top 10 addresses)
top_addresses <- dfs$Address[dfs$Price > quantile(dfs$Price, 0.9)]
df_top_addresses <- dfs[dfs$Address %in% top_addresses, ]

ggplot(df_top_addresses, aes(x = Address, y = Price, fill = Address)) +
  geom_boxplot() +
  labs(title = "Boxplot of Top Addresses vs Price", x = "Address", y = "Price") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Visualization 10: Violin plot for Address vs Price (top 10 addresses)
ggplot(df_top_addresses, aes(x = Address, y = Price, fill = Address)) +
  geom_violin() +
  labs(title = "Violin plot of Top Addresses vs Price", x = "Address", y = "Price") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## 2.4: Data preprocessing
# converting categorical data into numerical
dfs$EstateType <- as.numeric(factor(dfs$EstateType))
dfs$Address <- as.numeric(factor(dfs$Address))
dfs$City <- as.numeric(factor(dfs$City))

write.csv(dfs, "insta_final.csv", row.names = FALSE)

## 2.5: Modeling

# Linear Regression Model 1: Specific variables
model <- lm(Price ~ Rooms + Address + EstateType, data = dfs)
summary(model)
summary(model)$r.squared

# Linear Regression Model 2: All variables
model <- lm(Price ~ ., data = dfs)
summary(model)
summary(model)$r.squared

# Random Forest Model 1: All variables
library(randomForest)

model_rf <- randomForest(Price ~ ., data = dfs)
print(model_rf)
predicted_values <- predict(model_rf, dfs)
r_squared <- cor(dfs$Price, predicted_values)^2
cat("R-squared value:", r_squared, "\n")

# Random Forest Model 2: Specific variables
model_rf <- randomForest(Price ~ Rooms + Address + EstateType, data = dfs)
print(model_rf)
predicted_values <- predict(model_rf, dfs)
r_squared <- cor(dfs$Price, predicted_values)^2
cat("R-squared value:", r_squared, "\n")

## 2.5: Conclusion
results <- data.frame(
  Model = c("LR with all variables", "LR with specific variables", "RF with all variables", "RF with specific variables"),
  RSquared = c(0.434, 0.434, 0.722, 0.839)
)

print(results)

ggplot(results, aes(x = Model, y = RSquared)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Accuracy for Models",
       x = "Model",
       y = "R-Squared") +
  theme_minimal()





