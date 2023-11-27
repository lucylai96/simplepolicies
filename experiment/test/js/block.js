// Instantiate block conditions and variables

// Define the probability matrices for each condition

const rewardMatrices = [
  [
    [0.7, 0.2, 0],
    [0, 0.7, 0.2],
    [0.2, 0, 0.7]

    ],
  [
    [0.7, 0.2, 0],
    [0.7, 0, 0.2],
    [0.2, 0, 0.7]

    ]
  ];


    // Define the states and actions
const stimuli = ['img/flower1.png', 'img/flower2.png', 'img/flower3.png','img/flower4.png', 'img/flower5.png', 'img/flower6.png']; //,'img/flower7.png', 'img/flower8.png', 'img/flower9.png'
const actions = [74,75,76]; // ASCII values for "J", "K", "L"

// Create an array to keep track of stimulus presentation counts
const stimulusCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0];

const stimuliRepeats = 30;
const stimuliRepeatsP = 10;

    // Shuffle the order of experiment conditions and stimuli
shuffleArray(rewardMatrices);
shuffleArray(stimuli);
