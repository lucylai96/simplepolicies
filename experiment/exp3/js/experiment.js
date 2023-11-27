// Create a timeline for the experiment
const timeline = [];


// Push consent and instruction blocks

timeline.push(fullscreen);
timeline.push(instructions)

// Randomly shuffle the condition order
   const randomizedConditions = shuffleArray([0, 1]); // Change the order of 0 and 1 as needed

// Iterate over conditions
   for (let conditionIndex of randomizedConditions) {

if (conditionIndex == 1){ // for time pressure condition
 timeline.push(time_pressure_instructions);
};
if (randomizedConditions[0] == 1 && conditionIndex == 0){
    timeline.push(normal_instructions);
};

// Randomly select a reward matrix for this condition
const randomMatrixIndex = Math.floor(Math.random() * rewardMatrices.length);
const selectedRewardMatrix = rewardMatrices[randomMatrixIndex];
const conditionStimuli = stimuli.splice(0, 3);
const randomizedStimuli = jsPsych.randomization.repeat(conditionStimuli, stimuliRepeats)
console.log(randomMatrixIndex)
console.log(conditionStimuli)
console.log(selectedRewardMatrix)
console.log(conditionIndex)

// Iterate over trials within the condition
for (let stimulusIndex = 0; stimulusIndex < randomizedStimuli.length; stimulusIndex++) {
  const stimulus = randomizedStimuli[stimulusIndex];

  const trial = {
    type: 'image-keyboard-response',
    stimulus: stimulus,
    choices: actions,
    stimulus_width: 200,
    stimulus_height: 200,
    //trial_duration: 2000, // Set the time limit 
    on_start: function() {
            // Record trial start time
      trial.startTime = performance.now();
    },
    on_finish: function(data) {
      // Record key press reaction time
      const endTime = performance.now();
      data.reactionTime = endTime - trial.startTime;

      if (data.key_press.length == 0) {
         data.a = -1;
         data.r = 0;
       } else {
            
      const chosenActionIndex = actions.indexOf(data.key_press[0]);
      const probability = selectedRewardMatrix[conditionStimuli.indexOf(stimulus)][chosenActionIndex];
      const reward = Math.random() < probability ? 1 : 0;
      data.a = actions[chosenActionIndex]-73;
      data.r = reward;
      }

      data.s = conditionStimuli.indexOf(stimulus)+1;
      data.cond = conditionIndex+1;
      data.reward_cond = rewardMatricesFixed[0];
      data.reward_cond_actual = [selectedRewardMatrix];
      data.reward_matrix_idx = randomMatrixIndex+1;
        console.log(data)
      trial_node_id = jsPsych.currentTimelineNodeID()

            // Update stimulus presentation count
      stimulusCounts[stimulusIndex]++;

    }
  }; // Trial


  const trial_tp = {
    type: 'image-keyboard-response',
    stimulus: stimulus,
    choices: actions,
    stimulus_width: 200,
    stimulus_height: 200,
      trial_duration: 1000, // Set the time limit to 800 milliseconds
      on_start: function() {
            // Record trial start time
        trial.startTime = performance.now();
      },
      on_finish: function(data) {
        // Record key press reaction time
        const endTime = performance.now();
        data.reactionTime = endTime - trial.startTime;

        if (data.key_press.length == 0) {
         data.a = -1;
         data.r = 0;
         data.warning = true;
       } else {
        const chosenActionIndex = actions.indexOf(data.key_press[0]);
        const probability = selectedRewardMatrix[conditionStimuli.indexOf(stimulus)][chosenActionIndex];
        const reward = Math.random() < probability ? 1 : 0;
        data.a = actions[chosenActionIndex]-73;
        data.r = reward;
        data.warning = false;
        } // If response / no response

        data.s = conditionStimuli.indexOf(stimulus)+1;
        data.cond = conditionIndex+1;
        data.reward_cond = rewardMatricesFixed[0];
        data.reward_cond_actual = [selectedRewardMatrix];
        data.reward_matrix_idx = randomMatrixIndex+1;
        console.log(data)
        trial_node_id = jsPsych.currentTimelineNodeID();

            // Update stimulus presentation count
        stimulusCounts[stimulusIndex]++;


      }// On finish
    }; // Trial

    const feedback = {
      type: 'html-keyboard-response',
      stimulus: function(){
        var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
        var reward = prev_trial.select('r').values[0];
        var feedback_img = prev_trial.select('stimulus').values[0];
        if (reward == 1){
         return  '<img src="' + feedback_img + '" style="width:200px; border:14px solid green;">';
       }else{
        return '<img src="' + feedback_img + '" style="width:200px;border:14px solid red;">';}
      },
      choices: jsPsych.NO_KEYS,
         trial_duration: 300 // Display feedback for 300 milliseconds
       }; // Feedback


       const warning = {
        type: 'html-keyboard-response',
        stimulus: "<p>Warning: Please try to make a key press within the time limit. If you continue to miss trials, we reserve the right to withhold your bonus pay.</p><button onclick='jsPsych.finishTrial()'>I understand, proceed to next trial</button>",
        choices: jsPsych.NO_KEYS
      }; // Warning



      var conditional = {
        timeline: [warning],
        conditional_function: function(){
        // get the data from the previous trial,
        // and check which key was pressed
          var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
          console.log(prev_trial.select('warning').values[0])
          return prev_trial.select('warning').values[0];

        }
  }// Conditional


    if (conditionIndex == 0){ // for control condition
     timeline.push(trial);
     timeline.push(feedback);
     }else{ // for TIME PRESSURE condition
      timeline.push(trial_tp);
      timeline.push(feedback);
      timeline.push(conditional);
     }; // if statement

     }; // for loop - for each stimulus

// Add a break after each reward condition
     if (conditionIndex < 1) {
       const breakTrial = {
        type: 'html-keyboard-response',
        stimulus: "<p>You have completed a block! Take a break if you would like and press the button below when you're ready to continue to the next block.</p><button onclick='jsPsych.finishTrial()'>Continue</button>",
        choices: jsPsych.NO_KEYS
      };
      timeline.push(breakTrial);
    }
}; // For each reward condition



// Define redirect link for Qualtrics and add Turk variables
var urlVar = jsPsych.data.urlVariables();
var turkInfo = jsPsych.turk.turkInfo();

// Add MTurk info to CSV
jsPsych.data.addProperties({
  assignmentID: turkInfo.assignmentId
});
jsPsych.data.addProperties({
  mturkID: turkInfo.workerId
});
jsPsych.data.addProperties({
  hitID: turkInfo.hitId
});


// End of all block conditions
var end_all = {
  type: 'instructions',
  pages: [
    '<p class="center-content"> <b>And...that was the last block!</b></p>' +
    '<p class="center-content"> On the next page, we will ask you to input your MTurk ID to save your data.</p>'
    ],
  show_clickable_nav: true,
  allow_backward: false,
};


// Save data
var save_data = {
  type: "survey-text",
  questions: [{prompt: 'Please input your MTurk Worker ID. Your ID will not be shared with anyone outside of our research team. Your data will now be saved.', value: 'Worker ID'}],
  on_finish: function(data) {
    var responses = JSON.parse(data.responses);
    var subject_id = responses.Q0;
    console.log(subject_id)
    saveData(subject_id, jsPsych.data.get().csv());;
  },
}

// End of experiment
var end_experiment = {
  type: 'instructions',
  pages: [
   '<p class="center-content"> <b>Please wait on this page for 2 minutes while your data saves.</b></p>'+
   '<p class="center-content"> Please email lucylai@g.harvard.edu if you have any questions or concerns. After 2 minutes, please return to the landing page for the next part of the experiment!</p>'
   ],
  show_clickable_nav: true,
  allow_backward: false,
  show_page_number: false
};

timeline.push(end_all)
timeline.push(save_data);
timeline.push(end_experiment);


// Initialize the experiment
function startExperiment(){
  jsPsych.init({
    timeline: timeline,
    show_progress_bar: true,
     //auto_update_progress_bar: false,
  })
};

jsPsych.pluginAPI.preloadImages(stimuli, function () {startExperiment();});
console.log('Images preloaded')

