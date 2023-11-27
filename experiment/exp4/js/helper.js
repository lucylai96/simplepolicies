// Helper functions

// Save data to CSV
function saveData(name, data) {
	var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
    	filename: name,
    	filedata: data
    }));
}

var finish = false;

// Practice blocks
  //var practice_block = create_practice();

// Full screen
var fullscreen = {
	type: 'fullscreen',
	fullscreen_mode: true
}


// Fisher-Yates shuffle algorithm
function shuffleArray(array) {
      for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
      }
      return array;
    }

var demographic_age = {
  type: 'survey-text',
  questions: [
  {prompt: 'What is your age?', required: true},
  ]}

var demographic_gender = {
    type: 'survey-multi-choice',
    questions: [
    {prompt: 'What is your gender?', options: ['M','F','non-binary','prefer not to say'], name: 'gender',  required: true}
    ]}
