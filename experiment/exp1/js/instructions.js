var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content"><b>Welcome! </b> </p>' +
    '<p class="center-content">This is a refresher of the instructions for this study. The instructions are always the same, except that the pictures in each part will change.</p>' +
    '<p class="center-content">If you do not need a refresher, you can click through the instructions to begin the task! </p>'+
    '<p class="center-content">Press "Next" to review the instructions.</p>',
    // Instructions (page 2)
    '<p class="center-content"> <b>The instructions are the same for each part (1-3) of the study.</b> </p>' +
    '<p class="center-content">Imagine you are a photographer taking photos of different landscapes, animals, flowers, and food.</p>' +
    '<p class="center-content">However, you are using a special camera that requires you to use specific buttons depending on the subject of your capture.</p>',
    // Instructions (page 2)
    '<p class="center-content"> <b> The instructions are the same for each part (1-3) of the study.</b> </p>' +
    '<p class="center-content">Imagine you are a photographer taking photos of different landscapes, animals, flowers, and food.</p>' +
    '<p class="center-content">However, you are using a special camera that requires you to use specific buttons depending on the subject of your capture.</p>',
    // Instructions (page 3)
    '<p class="center-content">In each part of the study, you will learn which key ("camera button") to press in response to each picture that appears on the screen.  </p>' +
    '<p class="center-content">After each key press, you will be told whether you "captured" the image by choosing the correct key.</p>' +
    '<p class="center-content"><b>You will obtain monetary reward based on how how many "correct" responses you make.</b> </p>' ,
    // Instructions (page 4)
    '<p class="center-content">Each time you see a picture, </p>' +
    '<p class="center-content">you will have <b>2 seconds</b> to decide which one of the following keys: <b>[J]</b>, <b>[K]</b>, or <b>[L]</b> to press.</p>' +
    '<p class="center-content">Here are some examples of pictures you will see this part of the study: </p>' +
    '<p> <img src= img/flower1.png style="width:150px;"> <img src= img/flower2.png style="width:150px;"> <img src= img/flower3.png style="width:150px;"></p>',
    // Instructions (page 5)
    '<p class="center-content"> After each key press, you will receive feedback as to whether your key press was "correct" or "incorrect".</p>' +
    '<p class="center-content"> If your key press is correct, you will see a <b style="color:#32CD32">green border</b> appear around the image, like this:</p>' +
    '<p> <img src= img/flower3.png style="border:14px solid green; width:150px; height:150px;"></p>'+ 
    '<p class="center-content">  If your key press is incorrect, you will see a <b style="color:red">red border</b> appear around the image, like this:</p>'+
    '<p> <img src= img/flower3.png style="border:14px solid red; width:150px; height:150px;"> </p>'+
    '<p> If you fail to press a button within <b>2 seconds</b>, it will be counted as <b style="color:red">"incorrect"</b>.</p>',
    
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

