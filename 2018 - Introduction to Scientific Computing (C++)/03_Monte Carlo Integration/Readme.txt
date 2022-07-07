Here's a summary of my program
It uses monte carlo methods to figure out the distance of points from the origin of a circle inscribed on a square. The user is prompted to input the number of montecarlo points. Dividing the number of points in the circle by the number of points in the square (same as the number of monte carlo points) and multiplying by pi gives you a rough estimation of pi which is printed to the screen.

Here's how to run my program

STEP 1: In terminal, cd to the directory you extracted the zip file into.
STEP 2: cd into Abelardo2
STEP 3: run the command g++ HW2Q1.cpp -o HW2Q1
STEP 4: run the command ./HW2Q1
STEP 5: Follow the commands promted to you in the command line.

Here's my stream of consciousness

I struggled a lot in the program when it came to figuring out how to cast floats as floats and when I needed to do so.
In the beta versions of my program, I had it print out the random x and y values and the total circle/squarepoints just to make sure things were running like the should.
I ended up with an interger for my estimation of pi, even though I went through the process of fixing the precision of pi within my cout function.
It was only when I realized that I had to cast the calculation of pi as a float "float pi = 4 * (float) (circlepoints/squarepoints);" that my program printed out an interger value.
Lesson learned: math operators will always always always retrun intergers unless you tell them to!