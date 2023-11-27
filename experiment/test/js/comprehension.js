// comprehension check

// Define comprehension thresholds.
const max_errors = 0;
const max_loops = 10;
var n_loops = 0;

  var demographic_gender = {
    type: 'survey-multi-choice',
    questions: [
    {prompt: 'What is your gender?', options: ['M','F','non-binary','prefer not to say'], name: 'gender',  required: true},
    ]}


// Define section 1 comprehension check.
const quiz = {
  type: 'comprehension',
  prompts: [
    "To choose an alien to trade with, which keys do you use?",
    "<i>True</i> or <i>False</i>:&nbsp;Your goal is to figure out which aliens are most likely to give treasure.",
    "<i>True</i> or <i>False</i>:&nbsp;Some aliens may be more likely to give me treasue than others.",
  ],
  options: [
    ["a/d keys", "1/0 keys", "left/right arrow keys"],
    ["True", "False"],
    ["True", "False"],
  ],
  correct: [
    "left/right arrow keys",
    "True",
    "True"
  ],
  data: {quiz: 1}
}

const  instructions_help = {
  timeline: [{
    type: 'instructions',
    pages: [
      "<p>You did not answer all of the quiz questions correctly.</p><p>Please review the instructions carefully.</p>"
    ],
    show_clickable_nav: true,
  	button_label_next: 'Review instructions'
  }],
  conditional_function: function() {
  	console.log(jsPsych.data.get().filter({quiz: 1}).count())
    if (jsPsych.data.get().filter({quiz: 1}).count() > 0) {
      return true;
    } else {
      return false;
    }
  }
}

var instructions_loop = {
  timeline: [
    instructions_help,
    instructions_block,
    quiz,
  ],
  loop_function: function(data) {

    // Extract number of errors.
    const num_errors = data.values().slice(-1)[0].num_errors;

    // Check if instructions should repeat.
    n_loops++;
    if (num_errors > max_errors && n_loops >= max_loops) {
      return false;
    } else if (num_errors > max_errors) {
      return true;
    } else {
      return false;
    }

  }
}

