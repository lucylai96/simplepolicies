var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content"><b>Welcome to our study! </b> </p>' +
    '<p class="center-content">In this study, you will earn <b style="color:#32CD32">$1</b> base pay plus a bonus of <b style="color:#32CD32">$1-2</b> depending on your performance!</b></p>' +
    '<p class="center-content">In total, the study should take about 5 minutes total.</p>'+
    '<p class="center-content">Press "Next" to view the instructions.</p>',
    // Instructions (page 2)
    '<p class="center-content">Imagine you are a photographer taking photos of different landscapes, animals, flowers, and food.</p>' +
    '<p class="center-content">However, you are using a special camera that requires you to use specific buttons depending on the subject of your capture.</p>',
    // Instructions (page 3)
    '<p class="center-content">You will learn which key ("camera button") to press in response to each picture that appears on the screen.  </p>' +
    '<p class="center-content">After each key press, you will be told whether you "captured" the image by choosing the correct key.</p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on how how many "correct" responses you make.</b> </p>' ,
    // Instructions (page 4)
    '<p class="center-content">Each time you see a picture, </p>' +
    '<p class="center-content">you should decide which one of the following keys: <b>[J]</b>, <b>[K]</b>, or <b>[L]</b> to press.</p>' +
    '<p class="center-content">Here are some examples of pictures you will see in Part 1 of the study: </p>' +
    '<p> <img src= img/flower1.png style="width:150px;"> <img src= img/flower2.png style="width:150px;"> <img src= img/flower3.png style="width:150px;"></p>',
    // Instructions (page 5)
    '<p class="center-content"> After each key press, you will receive feedback as to whether your key press was "correct" or "incorrect".</p>' +
    '<p class="center-content"> If your key press is correct, you will see a <b style="color:#32CD32">green border</b> appear around the image, like this:</p>' +
    '<p> <img src= img/flower3.png style="border:14px solid green; width:150px; height:150px;"></p>'+ 
    '<p class="center-content">  If your key press is incorrect, you will see a <b style="color:red">red border</b> appear around the image, like this:</p>'+
    '<p> <img src= img/flower3.png style="border:14px solid red; width:150px; height:150px;"> </p>',
    //Instructions (page 6)
    '<p class="center-content"> However, there are some caveats to this feedback system: </p>'+
    '<p> (1) There can be multiple correct keys for each image. </p>'+
    '<p> (2) The feedback you receive will sometimes show <b style="color:red">"incorrect"</b> even though you have pressed the <b style="color:#32CD32">correct</b> key(s), or will sometimes show <b style="color:#32CD32">"correct"</b> even though you have pressed the <b style="color:red">incorrect</b> key(s)</p>' +
    '<p> (3) The correct key(s) for each image will <b>NOT</b> change within an experimental block.</p>' +
    '<p class="center-content"> Again, your job is to get as many "correct" responses as possible. </p>'+
    '<p> Click "Next" to begin the practice block, where you will get familiar with the task! </p>',
  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};

console.log('instructions loaded')


var practice_instructions1= {
  type: 'instructions',
  pages: [ 
  '<p> <b>You will now complete two practice blocks!</b></p>' +
  '<p> In this first practice block, the correct action for  <img src= img/flower4.png style="width:150px;"> is <b>[ J ]</b></p>' +
  '<p> The correct action for  <img src= img/flower5.png style="width:150px;"> is <b>[ K ]</b></p>' +
  '<p> And the correct action for  <img src= img/flower6.png style="width:150px;"> is <b>[ L ]</b></p>' +
  '<p> (In the real task, we will not tell you what the correct action is. We are telling you now just to familiarize you with the task.)</p>' +
  '<p> Notice how you will sometimes receive the <b style="color:red">"incorrect"</b> feedback even though you have pressed the <b style="color:#32CD32">correct</b> key(s), or will sometimes receive the <b style="color:#32CD32">"correct"</b> feedback even though you have pressed the <b style="color:red">incorrect</b> key(s)</p></p>' +
  '<p> Click "Begin" to start the <b>first</b> practice block. This block will last 30 trials.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};


var practice_instructions2 = {
  type: 'instructions',
  pages: [ 
  '<p> Great job! Now you will experience a practice block where there are two correct keys for each image.</p>',
  '<p> In this block, the correct actions for  <img src= img/flower4.png style="width:150px;"> are <b>[ J ]</b> and <b>[K]</b></p>' +
  '<p> The correct action for  <img src= img/flower5.png style="width:150px;"> are <b>[ K ]</b> and <b>[ L ]</b></p>' +
  '<p> And the correct action for  <img src= img/flower6.png style="width:150px;"> are <b>[ J ]</b> and <b>[ L ]</b></p>' +
   '<p> Again, notice how you will sometimes receive the <b style="color:red">"incorrect"</b> feedback even though you have pressed the <b style="color:#32CD32">correct</b> key(s), or will sometimes receive the <b style="color:#32CD32">"correct"</b> feedback even though you have pressed the <b style="color:red">incorrect</b> key(s)</p></p>' +
  '<p> Click "Begin" to start the <b>second</b> practice block. This block will last 30 trials.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};

var practice_end = {
  type: 'instructions',
  pages: [ 
  '<p> You have completed the practice block.</p>' +
  '<p> Press "Begin game!" to start the game.</p>'],
  show_clickable_nav: true,
  button_label_next: 'Begin game!'
};

