library(shiny)
library(bslib)
library(htmltools)
exercises<-c("Dead lift","Squat","Bench press")
ui<-page_navbar(
  title = "Gym Tracker",
  theme = bs_theme(
    bootswatch = "minty"
    ),
  navbar_options = navbar_options(
    underline = TRUE
  ),
  # sidebar=selectInput(
  #   "exercise", "Excercise",
  #   exercises,
  #   selected = "Squat"
  # ),
  # sidebar=numericInput("weight", "Weight",value=0,min=0, max=999),
  
  nav_panel(
    title = "Workouts",
    navset_card_tab(
      title = "Workouts", 
      sidebar=sidebar(textOutput("setText"),
        selectizeInput(
          "exercise", "Excercise",
          exercises,
          selected = "Squat",
          options = list(create = TRUE)
        ),
        numericInput("weight", "Weight",value=0,min=0, max=999),
        numericInput("reps", "Reps",value=0,min=0, max=999),
        actionButton("add_set", "Add set"),
        actionButton("delete_set", "Delete last set")
        ),
      nav_panel(title = "This workout",
                fluidRow(selectizeInput("tags",
                               "Muscle groups",
                               c("Chest","Arms","Back","Shoulders","Legs","Core"),
                               multiple=TRUE,
                               options = list(create = TRUE)
                ),
                dateInput("ex_date","Date")),
                tableOutput("workout"),
                actionButton("finishWorkout", "Finish Workout")
      ),
      nav_panel(title = "Previous workouts", p("See what you did in a previous session"))
    )
  ),
  nav_panel(title = "PBs and graphs", p("Personal bests and graphs")),
  nav_spacer()
)
