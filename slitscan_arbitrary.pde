float numFrames = 50;
float duration = 1200;
boolean recording = false;
float time = 0;

PGraphics pg; // for actual animation
int pgWidth = 700;
int pgHeight = pgWidth;
int pgNumFrames = 300;
int pgFrameCount = 0;
float pgtime;

PGraphics dpg; // for drawing onto canvas

PImage[] frames;

void setup(){
	size(600,600);
	frameRate(numFrames/duration*1000);

	dpg = createGraphics(pgWidth, pgHeight);
	dpg.beginDraw();
	dpg.endDraw();

	pg = createGraphics(pgWidth, pgHeight);
	
	frames = new PImage[pgNumFrames];

	for (int i=0; i<pgNumFrames; i++) {
		pgdraw();
		frames[i] = pg.get();
	}

	noSmooth();
}

void draw(){
	time = (frameCount%numFrames)/numFrames;
	
	// the actual "slitscanning" code
	dpg.loadPixels();

	for (int i=0; i<pgWidth; i++) {
		for (int j=0; j<pgHeight; j++) {
			int ind = i + j * pgWidth;
			// determine which frame to take the pixel from in this location:
			int f = f(i,j); 
			PImage frame = frames[f];
			frame.loadPixels();
			dpg.pixels[ind] = frame.pixels[ind];
		  }
	}

	dpg.updatePixels();
 	
 	image(dpg, 0, 0, width, height);
	image(frames[floor(time*pgNumFrames)%pgNumFrames],0,0, 100, 100);

	if(recording) {
		if (frameCount<=numFrames) saveFrame("frames/slitscan_arbitrary###.png");
		else exit();
	}
}

// determine which frame to take the pixel from at a given location
int f(int x, int y) {
	// normalize
	float xn = 1f*x/pgWidth;
	float yn = 1f*y/pgHeight;
	// translate to center
	xn = (xn-1f*mouseX/width);	
	yn = (yn-1f*mouseY/width);


	float f = 2 * noise(1/(xn*xn + yn*yn + map(mouseX,0,width,0.05,0.8)),mouseY/width) + time;
	//float f = 10 * noise(sqrt(xn*xn + yn*yn)*2,1-xn*0.5) + time;
	return mod(int(f * pgNumFrames), pgNumFrames);
}

// do actual animation here
// void pgdraw() {
// 	pg.beginDraw();
// 	pgtime = 1f*pgFrameCount/pgNumFrames;

// 	pg.pushMatrix();
// 	pg.noStroke();	
// 	pg.background(0);
// 	// pg.translate(pgWidth*0.5, pgHeight*0.5);
// 	// pg.rotate(map(sin(pgtime*TWO_PI),-1,1,PI*0.1,-PI*0.1));
// 	// pg.translate(-pgWidth*0.5, -pgHeight*0.5);
// 	float numStripes = 20;
// 	for (int i = -3; i < numStripes+3; i++) {
// 		float x = (i+2*pgtime)/numStripes * pgWidth;
// 		float w = 1f*pgWidth/numStripes;
// 		pg.fill((i+10)%2 * 255);
// 		pg.rect(x, -pgHeight, w, pgHeight*3);
// 	}
	

// 	pg.popMatrix();

// 	pg.endDraw();
// 	pgFrameCount++;
// }


int mod(int n, int m) {
    return ((n % m) + m) % m;
}


void pgdraw() {
	pg.beginDraw();
	pgtime = 1f*pgFrameCount/pgNumFrames;

	pg.pushMatrix();
	pg.translate(pgWidth * 0.5, pgHeight * 0.5);
	pg.strokeWeight(pgWidth*0.02);
	pg.rectMode(CENTER);	


	pg.background(0);
	int numSqs = 10;
	float r = 0.3 * pgWidth;
	float w = 0.2 * pgWidth;

	for (int i=0; i<numSqs; i++) {
		pg.pushMatrix();
	
		float a = 3 * i * TWO_PI/numSqs + pgtime * TWO_PI/numSqs;
		float R = r * map(sin(3*a+pgtime*TWO_PI),-1,1,0.5,1);
		float x = R * cos(a);
		float y = R * sin(a);
	
		pg.translate(x,y);
		pg.rotate(a+QUARTER_PI);
		pg.rect(0,0,w,w);
	
		pg.popMatrix();
	}

	pg.popMatrix();

	pg.endDraw();
	pgFrameCount++;
}