// Instantiate block conditions and variables

// Define the probability matrices for each condition

const rewardMatrices = [
  [
          // version 1
    [1, 0.5, 0],
    [1, 0.5, 0],
    [0.5, 0, 1]
    ],
  [
          // version 2
    [0.5, 0, 1],
    [0.5, 0, 1],
    [ 0,  1, 0.5]

    ],
  [
          // version 3
    [0, 1, 0.5],
    [0, 1, 0.5],
    [1, 0.5, 0]

    ]

  ];

const rewardMatricesFixed = [
  [
    [1, 0.5, 0],
    [1, 0.5, 0],
    [0.5, 0, 1]
    ]
  ]// rewardMatrices

/*const rewardMatrices = [
  [
          // version 1
    [1, 0.7, 0],
    [1, 0.7, 0],
    [0.7, 0, 1]
    ],
  [
          // version 2
    [0.7, 0, 1],
    [0.7, 0, 1],
    [ 0,  1, 0.7]

    ],
  [
          // version 3
    [0, 1, 0.7],
    [0, 1, 0.7],
    [1, 0.7, 0]

    ]

  ];

const rewardMatricesFixed = [
  [
    [1, 0.7, 0],
    [1, 0.7, 0],
    [0.7, 0, 1]
    ]
  ]// rewardMatrices*/


    // Define the states and actions
const stimuli = ['img/food1.png', 'img/food2.png', 'img/food3.png','img/food4.png', 'img/food5.png', 'img/food6.png'];
const actions = [74,75,76]; // ASCII values for "J", K", "L"

    // Create an array to keep track of stimulus presentation counts
const stimulusCounts = [0, 0, 0, 0, 0, 0];
const stimuliRepeats = 30;

    // Shuffle the order of experiment conditions and stimuli
shuffleArray(stimuli);