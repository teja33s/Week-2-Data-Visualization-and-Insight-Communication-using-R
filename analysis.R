# ---- setup
# Install once if needed: install.packages(c("ggplot2", "dplyr"))
library(ggplot2)
library(dplyr)

data(mtcars)          # Dataset 1: 32 cars, 11 variables
data(AirPassengers)   # Dataset 2: monthly airline passengers, 1949-1960

# Prepare mtcars: readable labels and the car names as a column
cars <- mtcars %>%
  mutate(
    car   = rownames(mtcars),
    cyl_f = factor(cyl, levels = c(4, 6, 8), labels = c("4 cyl", "6 cyl", "8 cyl")),
    trans = factor(am,  levels = c(0, 1),    labels = c("Automatic", "Manual"))
  )

# Prepare AirPassengers: convert the time series to a data frame
ap <- data.frame(
  date       = seq(as.Date("1949-01-01"), by = "month", length.out = 144),
  passengers = as.numeric(AirPassengers)
)
ap$year  <- as.integer(format(ap$date, "%Y"))
ap$month <- factor(format(ap$date, "%b"), levels = month.abb)

# Colour palette used across the report
pal_cyl <- c("4 cyl" = "#2A9D8F", "6 cyl" = "#E9C46A", "8 cyl" = "#E76F51")
# ---- explore
summary(cars$mpg)
sd(cars$mpg)
table(cars$cyl_f)
summary(ap$passengers)
# ---- p1
avg_mpg <- cars %>%
  group_by(cyl_f) %>%
  summarise(mean_mpg = mean(mpg), n = n())

p1 <- ggplot(avg_mpg, aes(x = cyl_f, y = mean_mpg, fill = cyl_f)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = round(mean_mpg, 1)), vjust = -0.5, fontface = "bold") +
  scale_fill_manual(values = pal_cyl) +
  labs(title    = "Fewer cylinders, better fuel economy",
       subtitle = "Average mpg by engine size, 32 cars (mtcars)",
       x = "Number of cylinders", y = "Average miles per gallon") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p1_bar.png", p1, width = 8, height = 5, dpi = 300)
# ---- p2
p2 <- ggplot(cars, aes(x = mpg)) +
  geom_histogram(binwidth = 3, boundary = 10, closed = "left",
                 fill = "#264653", color = "white") +
  geom_vline(xintercept = mean(cars$mpg), linetype = "dashed",
             color = "#E76F51", linewidth = 0.9) +
  annotate("text", x = mean(cars$mpg) + 0.6, y = 8.4, hjust = 0,
           label = paste0("Mean = ", round(mean(cars$mpg), 1), " mpg"),
           color = "#E76F51", fontface = "bold") +
  labs(title    = "Most cars cluster between 15 and 25 mpg",
       subtitle = "Distribution of fuel economy (bin width = 3 mpg)",
       x = "Miles per gallon", y = "Number of cars") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p2_hist.png", p2, width = 8, height = 5, dpi = 300)
# ---- p3
fit <- lm(mpg ~ wt, data = cars)
coef(fit)                      # intercept and slope
summary(fit)$r.squared         # R-squared
cor(cars$wt, cars$mpg)         # correlation

label_cars <- c("Cadillac Fleetwood", "Lincoln Continental", "Toyota Corolla")

p3 <- ggplot(cars, aes(x = wt, y = mpg)) +
  geom_smooth(method = "lm", se = TRUE, color = "grey30",
              fill = "grey80", linetype = "dashed") +
  geom_point(aes(color = cyl_f), size = 3) +
  geom_text(data = subset(cars, car %in% label_cars),
            aes(label = car), size = 3, vjust = -1) +
  scale_color_manual(values = pal_cyl, name = "Cylinders") +
  labs(title    = "Heavier cars burn more fuel",
       subtitle = "Weight vs. mpg with linear trend",
       x = "Weight (1000 lbs)", y = "Miles per gallon") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p3_scatter.png", p3, width = 8, height = 5.4, dpi = 300)
# ---- p4
cars %>%
  group_by(trans) %>%
  summarise(n = n(), mean_mpg = mean(mpg), median_mpg = median(mpg),
            mean_wt = mean(wt))

t.test(mpg ~ trans, data = cars)   # Welch two-sample t-test

p4 <- ggplot(cars, aes(x = trans, y = mpg, fill = trans)) +
  geom_boxplot(width = 0.5, alpha = 0.85, outlier.shape = NA,
               show.legend = FALSE) +
  geom_jitter(width = 0.1, alpha = 0.6, size = 2) +
  scale_fill_manual(values = c("Automatic" = "#8ECAE6", "Manual" = "#FFB703")) +
  labs(title    = "Manual cars are more fuel efficient",
       subtitle = "mpg by transmission type (points = individual cars)",
       x = "Transmission", y = "Miles per gallon") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p4_box.png", p4, width = 7, height = 5, dpi = 300)
# ---- p5
p5 <- ggplot(ap, aes(x = date, y = passengers)) +
  geom_line(color = "#1D3557", linewidth = 0.9) +
  geom_smooth(method = "lm", se = FALSE, color = "#E63946",
              linetype = "dashed") +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(title    = "Air travel grew steadily through the 1950s",
       subtitle = "Monthly international airline passengers, 1949-1960",
       x = "Year", y = "Passengers (thousands)") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p5_line.png", p5, width = 9, height = 5, dpi = 300)
# ---- p6
p6 <- ggplot(ap, aes(x = month, y = passengers, group = year, color = year)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 1.2) +
  scale_color_viridis_c(name = "Year") +
  labs(title    = "Travel peaks every summer",
       subtitle = "Seasonal pattern: one line per year",
       x = "Month", y = "Passengers (thousands)") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

ggsave("p6_season.png", p6, width = 9, height = 5, dpi = 300)

# Average passengers per calendar month
aggregate(passengers ~ month, data = ap, FUN = mean)
# ---- p7
vars    <- c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec")
cor_mat <- round(cor(mtcars[, vars]), 2)
cor_df  <- as.data.frame(as.table(cor_mat))
names(cor_df) <- c("Var1", "Var2", "r")

p7 <- ggplot(cor_df, aes(x = Var1, y = Var2, fill = r)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", r)), size = 3.5) +
  scale_fill_gradient2(low = "#B2182B", mid = "white", high = "#2166AC",
                       midpoint = 0, limits = c(-1, 1),
                       name = "Correlation (r)") +
  scale_y_discrete(limits = rev) +
  coord_fixed() +
  labs(title    = "Weight, displacement and cylinders move together",
       subtitle = "Correlation matrix of mtcars variables",
       x = NULL, y = NULL) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"),
        panel.grid = element_blank())

ggsave("p7_heat.png", p7, width = 7.5, height = 6.4, dpi = 300)
