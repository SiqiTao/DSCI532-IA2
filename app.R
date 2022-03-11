library(dash)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyverse)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

data <- read_csv("cleaned_salaries.csv")

app$layout(
    dbcContainer(
        list(
            dccGraph(id='box-plot'),
            dccDropdown(
                id='con-select',
                options = data$Country %>%
                    purrr::map(function(con) list(label = con, value = con)), 
                value='Canada')
        )
    )
)

app$callback(
    output('box-plot', 'figure'),
    list(input('con-select', 'value')),
    function(con) {
        p <- data %>%
            mutate(GenderSelect = factor(GenderSelect)) %>%
            filter(Country == con) %>%
            ggplot(aes(y = Salary_USD,
                       x = GenderSelect,
                       fill = GenderSelect,
                       text = GenderSelect)) +
            geom_boxplot() +
            coord_flip() +
            theme(legend.position="none") +
            ggthemes::scale_color_tableau() 
        ggplotly(p)
    }
)

# app$run_server(debug = T)
app$run_server(host = '0.0.0.0')
