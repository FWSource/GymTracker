library(shiny)
library(dplyr)
library(tidyverse)

server<-function(input, output, session) {
  load("workouts/workout_list.RData")
  
  
  this_workout <- reactiveValues(
    table1 = tibble(Set = character(), Exercise = character(), Weight=numeric(), Reps=integer())
  )
  past_workout <- reactiveValues(
    table1 = tibble(Set = character(), Exercise = character(), Weight=numeric(), Reps=integer())
  )
  set<-reactiveVal(0)

  # what happens when `add_data` is clicked?
  observeEvent(input$add_set, {
    set(set()+1)
    this_workout$table1 <- this_workout$table1 |> 
      add_row(Set = paste(set()), Exercise = input$exercise, Weight = input$weight, Reps = input$reps)
  })
  
  observeEvent(input$delete_set, {
    if(set()==0){
        showModal(modalDialog(
          title = "Moron!",
          "There's no set to delete you moron!",
          easyClose = TRUE,
          footer = NULL
        ))
    }
    else{
    this_workout$table1 <- this_workout$table1[-set(),]
    set(set()-1)
    }
  })
  
  output$setText <- renderText({
    paste("Set", set()+1)
  })
  
  output$workout <- renderTable({
    this_workout$table1
  },
  align="c")
  

  observeEvent(input$finishWorkout, {
    final_workout<-list(name = paste(input$ex_date,"_", paste(input$tags,collapse=""),sep=""),
                        
                        date = input$ex_date,
                        tags = input$tags,
                        workout = this_workout)
    # showModal(modalDialog(
    #   title = "Test",
    #   renderText({final_workout$name}),
    #   easyClose = TRUE,
    #   footer = NULL
    # ))
    save(final_workout, file = paste("workouts/",final_workout$name,".RData",sep=""))
    workout_list<-add_row(workout_list,Name=final_workout$name[1],Date=final_workout$date[1],Tags =paste(final_workout$tags,collapse = " "))
    workout_list<-workout_list[order(desc(workout_list$Date)),]
    save(workout_list, file = "workouts/workout_list.RData")
    
  })
  
  observeEvent(input$load_workout,{#
    showModal(modalDialog(
      title = "Test",
      #renderText({input$prev_workout}),
      #paste("workouts/",input$prev_workout,".RData",sep=""),
      easyClose = TRUE,
      footer = NULL
    ))
               load(paste("workouts/",input$prev_workout,".RData",sep=""))
               loaded_workout<-final_workout$workout
            past_workout$table1 <- loaded_workout$table1
  })

  output$past_workout<-renderTable({
    past_workout$table1
  },
  align="c"
  ) 
  
}