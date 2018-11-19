// create references to page elements
var addButton = document.getElementById("add") ;
var taskInput = document.getElementById("task");
var taskList = document.getElementById("taskList");

// add new item to task list
addButton.addEventListener("click", function(){
    var task = taskInput.value;

    // do not add an empty string, if user clicks without entring anything
    if(task.trim()){

        // add new task list item
        var newItem = document.createElement("LI");
        var taskText = document.createTextNode(task);
        newItem.appendChild(taskText);

        // clear text input box
        taskInput.value = "";
        taskList.appendChild(newItem);
    }
    else{
        alert("Task cannot be empty");
    }
});