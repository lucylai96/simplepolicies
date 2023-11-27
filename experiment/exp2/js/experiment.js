// Create a timeline for the experiment
const timeline = [];


// Push consent and instruction blocks

timeline.push(fullscreen);
timeline.push(instructions)
//timeline.push(practice_block);
//timeline.push(practice_finished);


      // Iterate over reward conditions
rewardMatrices.forEach((rewardMatrix, conditionIndex) => {

  const conditionStimuli = stimuli.splice(0, 3);
  const randomizedStimuli = jsPsych.randomization.repeat(conditionStimuli, stimuliRepeats)
      // Iterate over trials within the condition
  for (let stimulusIndex = 0; stimulusIndex < randomizedStimuli.length; stimulusIndex++) {
    const stimulus = randomizedStimuli[stimulusIndex];


    const trial = {
      type: 'image-keyboard-response',
      stimulus: stimulus,
      choices: actions,
      stimulus_width: 200,
      stimulus_height: 200,
      on_start: function() {
            // Record trial start time
        trial.startTime = performance.now();
      },
      on_finish: function(data) {
            // Record key press reaction time
        const endTime = performance.now();
        data.reactionTime = endTime - trial.startTime;
        const chosenActionIndex = actions.indexOf(data.key_press[0]);
        const probability = rewardMatrix[conditionStimuli.indexOf(stimulus)][chosenActionIndex];
        const reward = Math.random() < probability ? 1 : 0;
        data.a = actions[chosenActionIndex]-73;
        data.r = reward;
        data.s = conditionStimuli.indexOf(stimulus)+1;
        data.reward_cond = [rewardMatrix];
        console.log(data.reward_cond)
        console.log(data.s)
        console.log(data.a)
        trial_node_id = jsPsych.currentTimelineNodeID()

            // Update stimulus presentation count
        stimulusCounts[stimulusIndex]++;

      }
    };

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

       timeline.push(trial);
       timeline.push(feedback);
     };

// Add a break after each reward condition
     if (conditionIndex < rewardMatrices.length - 1) {
      const breakTrial = {
        type: 'html-keyboard-response',
        stimulus: "<p>You have completed a block! Take a break if you would like and press the button below when you're ready to continue to the next block.</p><button onclick='jsPsych.finishTrial()'>Continue</button>",
        choices: jsPsych.NO_KEYS
      };
      timeline.push(breakTrial);
    }

}); // For each reward condition



// // Define redirect link for Qualtrics and add Turk variables
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
    '<p class="center-content"> <b>And...that was the last block of Part 2!</b></p>' +
    '<p class="center-content"> On the next page, we will ask you to input your MTurk ID to save your data for Part 2.</p>'
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
   '<p class="center-content"> <b>Please wait on this page for 1 minute while your data saves.</b></p>'+
   '<p class="center-content"> Please email lucylai@g.harvard.edu if you have any questions or concerns. Please click "Next" to be redirected to Part 3 of the experiment!</p>'
   ],
  show_clickable_nav: true,
  allow_backward: false,
  show_page_number: false,
  on_finish: function(data) {
    window.location.href = "https://gershmanlab.com/experiments/lucy/bandits-roey/exp3/index.html?&workerId=" + turkInfo.workerId + "&assignmentId=" + turkInfo.assignmentId + "&hitId=" + turkInfo.hitId;
  },
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


