library(shiny)
library(dplyr)

server<-function(input, output, session) {
  
  this_workout <- reactiveValues(
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
    final_workout<-list(name = paste(input$ex_date, paste(input$tags,collapse=""),sep=""),
                        date = input$ex_date,
                        tags = input$tags,
                        workout = this_workout)
    showModal(modalDialog(
      title = "Test",
      renderText({final_workout$name}),
      easyClose = TRUE,
      footer = NULL
    ))
    save(final_workout, file = paste(final_workout$name,".RData",sep=""))
  })
}