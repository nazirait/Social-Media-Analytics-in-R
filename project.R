# Part 1: Quantitative Analysis of Scenario Data

df <- read.csv("C:/Users/Nazira/Desktop/Rome classes/SMAN/Houses.csv")

# 1.1: Dataset Overview
str(df)
summary(df)
cat('The dataset contains', nrow(df), 'data observations within', ncol(df), 
      'columns')

# 1.2: Descriptive Statistics

prices <- summary(df$price)
hist(df$price, main = "Distribution of House Prices", xlab = "Price")

stats <- summary(df[, c("price", "floor", "latitude", "longitude", "rooms", "sq", "year")])

df$city[df$city == 'Krak\xf3w'] <- 'Krakow'
df$city[df$city == 'Pozna\xf1'] <- 'Poznan'
# par(mfrow = c(2, 4))
hist(df$floor, main = "Distribution of Floor", xlab = "Floor")
hist(df$latitude, main = "Distribution of Latitude", xlab = "Latitude")
hist(df$longitude, main = "Distribution of Longitude", xlab = "Longitude")
hist(df$rooms, main = "Distribution of Rooms", xlab = "Rooms")
hist(df$sq, main = "Distribution of Square Footage", xlab = "Square Footage")
hist(df$year, main = "Distribution of Year", xlab = "Year", xlim = c(1800,2300), breaks = 50)

barplot(table(df$city), main = "Distribution of Houses by City", xlab = "City", ylab = "Count")

# 1.3: Correlation Analysis
cor_matrix <- cor(df[, c("price", "floor", "latitude", "longitude", "rooms", "sq", "year")])
print(cor_matrix)
pairs(df[, c("price", "floor", "latitude", "longitude", "rooms", "sq", "year")])

library(corrplot)
corrplot(cor_matrix, method = "color")

boxplot(price ~ city, data = df, main = "Box Plot of Price by City")

# 1.4: Data Preprocessing & Feature Engineering
missing_values <- colSums(is.na(df))
print(missing_values)

df$price_sq <- df$price / df$sq
df$city <- as.numeric(factor(df$city))

# 1.5: Data Prediction & Modeling
numeric_vars <- sapply(df, is.numeric) # getting numeric vars

model1 <- lm(price ~ ., data = df[, numeric_vars]) # Linear Regression
summary(model1)
r1 <- summary(model1)$r.squared


library(rpart)
dt <- rpart(price ~ ., data = df[, numeric_vars]) # Decision Tree
print(dt)
r2 <- 1 - dt$cptable[dt$cptable[, "xerror"] == min(dt$cptable[, "xerror"]), "xerror"]


## 1.6: Conclusion
results <- data.frame(
  Model = c("Linear Regression", "Decision Tree"),
  RSquared = c(r1, r2)
)

print(results)

library(ggplot2)
ggplot(results, aes(x = Model, y = RSquared)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Accuracy for Models",
       x = "Model",
       y = "R-Squared") +
  theme_minimal()



