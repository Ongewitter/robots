<h1> MARS ROVERS </h1>

<h2> Description </h2>
A squad of robotic rovers are to be landed by NASA on a plateau on Mars. This plateau, which is curiously rectangular, must be navigated by the rovers so that their on-board cameras can get a complete view of the surrounding terrain to send back to Earth.

A rover’s position and location is represented by a combination of x and y co-ordinates and a letter representing one of the four cardinal compass points. The plateau is divided up into a grid to simplify navigation. An example position might be 0, 0, N, which means the rover is in the bottom left corner and facing North.

In order to control a rover, NASA sends a simple string of letters. The possible letters are ‘L’, ‘R’ and ‘M’. ‘L’ and ‘R’ makes the rover spin 90 degrees left or right respectively, without moving from its current spot. ‘M’ means move forward one grid point, and maintain the same heading.

Assume that the square directly North from (x, y) is (x, y+1).

INPUT: The first line of input is the upper-right coordinates of the plateau, the lower-left coordinates are assumed to be 0,0.

The rest of the input is information pertaining to the rovers that have been deployed. Each rover has two lines of input. The first line gives the rover’s position, and the second line is a series of instructions telling the rover how to explore the plateau.

The position is made up of two integers and a letter separated by spaces, corresponding to the x and y co-ordinates and the rover’s orientation.

Each rover will be finished sequentially, which means that the second rover won’t start to move until the first one has finished moving.

OUTPUT The output for each rover should be its final co-ordinates and heading.

<h2> Test Data </h2>

<h3> Test Input: </h3>
5 5

1 2 N

LMLMLMLMM

3 3 E

MMRMMRMRRM

<h3> Expected Output: </h3>
1 3 N

5 1 E  

<h2> How to run </h2>

Check out this repo (duh)

Then run either `ruby main.rb` for manual input 

or

`ruby main.rb input.txt` for automatic input

<h2> Assumptions </h2>

* Ruby only, no Rails
* Minimal gem usage (I used rspec for testing, that's it)
* There is a basic set of safeguards, but I assume breaking the program is still possible. This is fine as it is a test project.
* Tests are written very WET, because <a href="https://thoughtbot.com/blog/lets-not">Let's not</a>
* There are two commented tests which I would use <a href="https://github.com/thoughtbot/factory_bot">factory_bot</a> for, but since we're trying to keep gems at a minimum, we chose not to actually implement them. For now.
* If wanted, a user could keep adding rovers and moving them around, this is intentional
* There are a lot of prompts, in case the user forgets what they are doing, so they wouldn't have to guess at what input is expected
* A user can type "exit" at any moment to quit the program and flip the table
* For that matter, if a user provides wrong input, we quit the program and flip the table
* Alternatively, one could run the program and provide an input file, much like the included `input.txt` file. This is why we use `gets`. We chose not to disable the prompts for this method of input.
