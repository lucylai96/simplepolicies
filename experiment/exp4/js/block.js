// Instantiate block conditions and variables

// Define the probability matrices for each condition

const rewardMatrices = [
  [
    [
      [0.8, 0.2 ,0.2],
      [0.2, 0.8, 0.2],
      [0.2, 0.2, 0.8] 
      ]
  ], // first condition

  [
    [
      [0.8, 0.2 ,0.2],
      [0.2, 0.8, 0.2],
      [0.2, 0.2, 0.8] 
      ],
    [
      [0.2, 0.2 ,0.8],
      [0.8, 0.2, 0.2],
      [0.2, 0.8, 0.2] 
      ],
    [
      [0.2, 0.8 ,0.2],
      [0.2, 0.2, 0.8],
      [0.8, 0.2, 0.2] 
      ]
  ] // second condition

  ]// rewardMatrices

const rewardMatricesFixed = [
  [
    [0.8, 0.2 ,0.2],
      [0.2, 0.8, 0.2],
      [0.2, 0.2, 0.8] 
    ],
  [
    [0.8, 0.2 ,0.2],
      [0.2, 0.8, 0.2],
      [0.2, 0.2, 0.8] 
    ]
  ];

/*const rewardMatrices = [
  [
    [
      [1, 0.5 ,0.5],
      [0.5, 1, 0.5],
      [0.5, 0.5, 1] 
      ]
  ], // first condition

  [
    [
      [1, 0.5 ,0.5],
      [0.5, 1, 0.5],
      [0.5, 0.5, 1] 
      ],
    [
      [0.5,  0.5  ,1],
      [1,  0.5,  0.5],
      [0.5,  1,  0.5] 
      ],
    [
      [0.5, 1 , 0.5],
      [0.5, 0.5, 1],
      [1, 0.5, 0.5] 
      ]
  ] // second condition

  ]// rewardMatrices

const rewardMatricesFixed = [
  [
    [1, 0.5 ,0.5],
      [0.5, 1, 0.5],
      [0.5, 0.5, 1] 
    ],
  [
    [1, 0.5 ,0.5],
      [0.5, 1, 0.5],
      [0.5, 0.5, 1] 
    ]
  ];*/

    // Define the states and actions
const stimuli = ['img/land1.png', 'img/land2.png', 'img/land3.png','img/land4.png', 'img/land5.png', 'img/land6.png']; //,'img/land7.png', 'img/land8.png', 'img/land9.png']
const actions = [74,75,76]; // ASCII values for "J", "K", "L"
shuffleArray(stimuli);

    // Create an array to keep track of stimulus presentation counts
const stimulusCounts = [0, 0, 0, 0, 0, 0];
const firstHalf = [30, 30, 30];
const secondHalf = [90, 30, 30];

// Randomly determine the order
const randomOrder = Math.random() < 0.5;

// Combine the halves based on the random order
const stimuliRepeats  = randomOrder ? secondHalf.concat(firstHalf):firstHalf.concat(secondHalf);
console.log(stimuliRepeats)
console.log(randomOrder)


