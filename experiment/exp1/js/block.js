// Instantiate block conditions and variables

// Define the probability matrices for each condition

const rewardMatrices = [
  [
    [
      [1, 0.333 ,0.333],
      [0.333, 1, 0.333],
      [0.333, 0.333, 1]
      ]
  ], // first condition

  [
    [
    [1, 0, 0],
    [1, 1, 0],
    [1, 0, 1]
     ],

  [// version 2
    [0, 0, 1],
    [1, 0, 1],
    [0, 1, 1]

    ],
  [ // version 3
   [0, 1, 0],
   [0, 1, 1],
   [1, 1, 0]
   ]
  ] // second condition

  ]// rewardMatrices

const rewardMatricesFixed = [
  
    [
      [1, 0.333 ,0.333],
      [0.333, 1, 0.333],
      [0.333, 0.333, 1]
      ],
    [
     [1, 0, 0],
     [1, 1, 0],
     [1, 0, 1]
     ]
  
  ]// rewardMatrices


    // Define the states and actions
const stimuli = shuffleArray(['img/flower1.png', 'img/flower2.png', 'img/flower3.png','img/flower4.png', 'img/flower5.png', 'img/flower6.png']);
const actions = [74,75,76]; // ASCII values for "J", "K", "L"

// Create an array to keep track of stimulus presentation counts
const stimulusCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0];

const stimuliRepeats = 30;
const stimuliRepeatsP = 10;

    // Shuffle the order of experiment conditions and stimuli
console.log(stimuli)
