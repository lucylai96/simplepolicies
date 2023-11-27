var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content"><b>Welcome! </b> </p>' +
    '<p class="center-content"><b style="color:red">**PLEASE READ** the instructions for this part carefully, as there are some minor changes concerning response time in the task.</b> </p>' +
    '<p class="center-content">Press "Next" to review the instructions.</p>',
    // Instructions (page 2)
    '<p class="center-content">Imagine you are a photographer taking photos of different landscapes, animals, flowers, and food.</p>' +
    '<p class="center-content">However, you are using a special camera that requires you to use specific buttons depending on the subject of your capture.</p>',
    // Instructions (page 3)
    '<p class="center-content">In each part of the study, you will learn which key ("camera button") to press in response to each picture that appears on the screen.  </p>' +
    '<p class="center-content">After each key press, you will be told whether you "captured" the image by choosing the correct key.</p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on how how many "correct" responses you make.</b> </p>' ,
    // Instructions (page 4)
    '<p class="center-content">Each time you see a picture, </p>' +
     '<p class="center-content">you will have <b style="color:#32CD32">**unlimited time**</b> to decide which one of the following keys: <b>[J]</b>, <b>[K]</b>, or <b>[L]</b> to press.</p>' +
    '<p class="center-content">Here are some examples of pictures you will see this part of the study: </p>' +
    '<p> <img src= img/food1.png style="width:150px;"> <img src= img/food2.png style="width:150px;"> <img src= img/food3.png style="width:150px;"></p>',
    // Instructions (page 5)
    '<p class="center-content"> After each key press, you will receive feedback as to whether your key press was "correct" or "incorrect".</p>' +
    '<p class="center-content"> If your key press is correct, you will see a <b style="color:#32CD32">green border</b> appear around the image, like this:</p>' +
    '<p> <img src= img/food3.png style="border:14px solid green; width:150px; height:150px;"></p>'+ 
    '<p class="center-content">  If your key press is incorrect, you will see a <b style="color:red">red border</b> appear around the image, like this:</p>'+
    '<p> <img src= img/food3.png style="border:14px solid red; width:150px; height:150px;"> </p>',
    //Instructions (page 6)
    '<p class="center-content"> However, there are some caveats to this feedback system: </p>'+
    '<p> (1) Sometimes multiple images will share the same correct key.</p>'+
    '<p> (2) Sometimes there will be multiple correct keys per image.</p>'+
    '<p> (3) The feedback you receive will sometimes show <b style="color:red">"incorrect"</b> even though you have pressed the <b style="color:#32CD32">correct</b> key(s), or will sometimes show <b style="color:#32CD32">"correct"</b> even though you have pressed the <b style="color:red">incorrect</b> key(s)</p>' +
    '<p> (4) The correct key(s) for each image will <b>NOT</b> change within an experimental block.</p>' +
    '<p class="center-content"> Again, your job is to get as many "correct" responses as possible. </p>',
    //Instructions (page 7)
    '<p class="center-content"> Again, the experiment will have 3 parts. After each part, please return to the "Landing Page" for the next part.</p>' + 
    '<p class="center-content"> These instructions will be repeated at the beginning of each experiment part.</p>'+
    '<p> Click "Next" to begin!</p>',
     ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};

console.log('instructions loaded')


var time_pressure_instructions= {
  type: 'instructions',
  pages: [
  '<p class="center-content"><b>**PLEASE READ**: This block has a <b>different</b> rule! You must make your key press within <b style="color:red">**1 second**</b> of the image appearing. If you do not make a key press, we will give you a warning. Repeated failure to make key presses during the experiment will result in a withholding of bonus pay for this part. The rest of the instructions remain exactly the same as before.</b></p>',
  '<p> Click "Begin" to start the next block.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};

var normal_instructions= {
  type: 'instructions',
  pages: [
  '<p class="center-content"><b>**PLEASE READ**: The 1 second response rule <b>no longer applies!</b> You now have <b style="color:#32CD32">**unlimited time**</b> to make your response. The rest of the instructions remain exactly the same as before.</b></p>',
  '<p> Click "Begin" to start the next block.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};
 
