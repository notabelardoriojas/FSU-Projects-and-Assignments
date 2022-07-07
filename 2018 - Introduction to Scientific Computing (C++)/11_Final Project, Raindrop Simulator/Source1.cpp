//ISC 3313 Abelardo Riojas FSUID ar18aa
//Final Project
#include<iostream>
#include<cmath>
#include<vector>
#include<stdlib.h>
#include<math.h>
#include<fstream>

using namespace std;

class rainProblem {
	int wetness = 0;
	float time;
	//making a box
	float refresh = .1;
	float p1[3];
	float p2[3];
	float p3[3];
	float p4[3];
	//average male height 1.77m
	float height;
	//average male depth .26m
	float depth = .26;
	//average broadness .40 m
	float broadness = .4;
	//raindrops per second
	//drizzling = 15100 rps, moderate rain = 49500, heavy rain 81800 rps
	int rps;
	int raindrops = rps * time;
	vector< vector<float> > rd;
	
public:
	float dist(float a, float b) {
		return b - a;
	}
	float makeTime(float speed) {
		return dist(0, 100) / speed;
	}
	void makeitRain(int i, float time) {
		//raindrop, droptop, smoking on cookie in a hotbox
		int tInt = time;
		vector<float> raindrop;
		raindrop.push_back((rand() % 100) + ((float)rand() / RAND_MAX));
		raindrop.push_back(10);
		raindrop.push_back((rand() % tInt) + ((float)rand() / RAND_MAX));
		raindrop.push_back(((float)rand() / RAND_MAX));
		rd.push_back(raindrop);
	}
	void movebox(float rwspeed) {
		p1[0] += refresh*rwspeed;

		p2[0] = p1[0] + depth;

		p3[0] += refresh*rwspeed;

		p4[0] = p3[0] + depth;
	}
	void rainCheck(float i, float time) {
		raindrops = rd.size();
		for (int j = 0; j < raindrops; j++) {
			if (fabs(rd[j][2] - i) <= .001) {
				rd[j][1] -= 10 * refresh;
				rd[j][2] += refresh;
			}
			if (rd[j][0] >= p1[0] && rd[j][0] <= p2[0] && 
				rd[j][1] >= p1[1] && rd[j][1] <= p4[1] &&
				rd[j][3] <= p1[2] && rd[j][3] >= p4[2]) {
				wetness++;
				rd[j][1] == -1;
			}
		}
	}
	int simulation(float rwspeed, int rainper, float h) {
		time = makeTime(rwspeed);
		height = h;
		rps = rainper;
		p1[0] = 0; p1[1] = 0; p1[2] = .5 + (broadness/2);
		p2[0] = depth; p2[1] = 0; p2[2] = .5 - (broadness/2);
		p3[0] = 0; p3[1] = height; p3[2] = .5 + (broadness/2);
		p4[0] = depth; p4[1] = height; p4[2] = .5 - (broadness/2);
		wetness = 0;
		raindrops = rps * time;
		for (int i = 0; i < raindrops; i++) {
			makeitRain(i, time);
		}
		//terminal velocity for raindrops = 10 m/sD
		for (float i = 0; i <= time; i += refresh) {
			movebox(rwspeed);
			rainCheck(i, time);
			int k = i * 10;
			if (k % 10 == 0) {
				cout << "percentage time: " << (i / time) * 100 << endl;
			}
		}
		return wetness;
	}

};

int main() {
	rainProblem walk;
	rainProblem run;
	//average human walking speed is 1.4m/s
	//average human running speed is 6.7m/s
	float runspeed = 6.7;
	float walkspeed = 2.8;
	//cout << run.simulation(runspeed, 1000, 1.77);
	int countr = 0;
	ofstream myfile("plotrun.txt");
	myfile << "100" << "\n";
	myfile << "x y" << "\n";
	for (int i = 15100; i <= 81800; i += 6670) {
		cout << countr << "% complete " << endl;
		myfile << i*10 << " " << run.simulation(runspeed,i,1.77) << "\n";
		countr++;
	}
	int countw = 0;
	ofstream myfile1("plotwalk.txt");
	myfile << "100" << "\n";
	myfile << "x y" << "\n";
	for (int i = 15100; i <= 81800; i += 6670) {
		cout << countw << "% complete " << endl;
		myfile1 << i*10 << " " << walk.simulation(walkspeed, i, 1.77) << "\n";
		countw++;
	}
	return 0;
}