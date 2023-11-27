// Instantiate block conditions and variables

// Define the probability matrices for each condition
const rewardMatrices = [
      [
        [1, 0.7, 0],
        [0, 1, 0.7],
        [0.7, 0, 1]
      ],
      [
        [1,0.7, 0],
        [1,0.7, 0],
        [0.7, 0, 1]
      ]
    ];

    // Define the states and actions
const stimuli = ['img/animal1.png', 'img/animal2.png', 'img/animal3.png','img/animal4.png', 'img/animal5.png', 'img/animal6.png'];
const actions = [74,75,76]; // ASCII values for "J", "K", "L"

    // Create an array to keep track of stimulus presentation counts
const stimulusCounts = [0, 0, 0, 0, 0, 0];
const stimuliRepeats = 30;

    // Shuffle the order of experiment conditions and stimuli
shuffleArray(rewardMatrices);
shuffleArray(stimuli);