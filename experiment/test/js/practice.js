// Practice block //


var practice_block2 = {
  timeline: [trial, feedback],
  timeline_variables: practice_block_stim[1],
  randomize_order: false,
  repetitions: 20
};

var practice_block = {
  timeline: [practice_instructions1, practice_block1, practice_instructions2, practice_block2],
  repetitions: 1
};



var practice_end = {
  type: 'instructions',
  pages: [ 
  '<p> You have completed the practice block.</p>' +
  '<p> Press "Begin game!" to start the game.</p>'],
  show_clickable_nav: true,
  button_label_next: 'Begin game!'
};

function create_practice() {
  console.log("Creating practice block!");
  return practice_block;
};

function finish_practice() {
  console.log("Finishing practice trials.");
  return practice_finished;
}