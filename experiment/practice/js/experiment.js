// Create a timeline for the experiment
const timeline = [];


// Push consent and instruction blocks
timeline.push(fullscreen);
timeline.push(instructions)
timeline.push(practice_instructions1);

const practiceMatrix1 = [[0.8, 0.2, 0.2],
  [0.2, 0.8, 0.2],
  [0.2, 0.2, 0.8]];
// PRACTICE BLOCK 1 //
const conditionStimuli = ['img/animal4.png', 'img/animal5.png', 'img/animal6.png'];
const randomizedStimuliP1 = jsPsych.randomization.repeat(conditionStimuli, stimuliRepeatsP)
      // Iterate over trials within the condition
for (let stimulusIndex = 0; stimulusIndex < randomizedStimuliP1.length; stimulusIndex++) {
  const stimulus = randomizedStimuliP1[stimulusIndex];

  const trial = {
    type: 'image-keyboard-response',
    stimulus: stimulus,
    choices: actions,
    stimulus_width: 200,
    stimulus_height: 200,
    trial_duration: 2000, // Set the time limit 
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
      const probability = practiceMatrix1[conditionStimuli.indexOf(stimulus)][chosenActionIndex];
      const reward = Math.random() < probability ? 1 : 0;
      data.a = actions[chosenActionIndex]-73;
      data.r = reward;
    }
    data.s = conditionStimuli.indexOf(stimulus)+1;
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

     timeline.push(practice_instructions2);
     const practiceMatrix2 = [[0.2, 0.8, 0.8],
      [0.2, 0.2, 0.8],
      [0.2, 0.2, 0.8]];
// PRACTICE BLOCK 2 //
     const randomizedStimuliP2 = jsPsych.randomization.repeat(conditionStimuli, stimuliRepeatsP)
      // Iterate over trials within the condition
     for (let stimulusIndex = 0; stimulusIndex < randomizedStimuliP2.length; stimulusIndex++) {
      const stimulus = randomizedStimuliP2[stimulusIndex];

      const trial = {
        type: 'image-keyboard-response',
        stimulus: stimulus,
        choices: actions,
        stimulus_width: 200,
        stimulus_height: 200,
        trial_duration: 2000, // Set the time limit 
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
          const probability = practiceMatrix2[conditionStimuli.indexOf(stimulus)][chosenActionIndex];
          const reward = Math.random() < probability ? 1 : 0;
          data.a = actions[chosenActionIndex]-73;
          data.r = reward;
        }
        data.s = conditionStimuli.indexOf(stimulus)+1;
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

// End of experiment
var end_experiment = {
  type: 'instructions',
  pages: [
   '<p class="center-content"> <b>You have finished the practice block! You may repeat this practice block as many times as you would like throughout the study.</b></p>'+
   '<p class="center-content"> You may now exit this window and return to the "Landing Page" for the next part of the study!</p>'
   ],
  show_clickable_nav: true,
  allow_backward: false,
  show_page_number: false,
  on_finish: function(data) {
    window.location.href = "https://gershmanlab.com/experiments/lucy/bandits-roey/landing.html";
  },
};

timeline.push(end_experiment);

// Initialize the experiment
function startExperiment(){
  jsPsych.init({
    timeline: timeline,
    show_progress_bar: true,
  })
};

jsPsych.pluginAPI.preloadImages(stimuli, function () {startExperiment();});
console.log('Images preloaded')

