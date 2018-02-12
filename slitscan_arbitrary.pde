float numFrames = 50;
float duration = 2000;
boolean recording = false;
float time = 0;

PGraphics pg; // for actual animation
int pgWidth = 300;
int pgHeight = pgWidth;
int pgNumFrames = 100;
int pgFrameCount = 0;
float pgtime;

PGraphics dpg; // for drawing onto canvas

PImage[] frames;

void setup(){
	size(750,750);
	noiseSeed(12313);
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
			// int f = f(i,j); 
			// PImage frame = frames[f];
			// frame.loadPixels();
			// dpg.pixels[ind] = frame.pixels[ind];
			int rf = f(i,j,0.02);
			int gf = f(i,j);
			int bf = f(i,j,-0.02);
			PImage rframe = frames[rf];
			PImage gframe = frames[gf];
			PImage bframe = frames[bf];
			rframe.loadPixels();gframe.loadPixels();bframe.loadPixels();
			color col = color(rframe.pixels[ind] >> 16 & 0xFF,
							  gframe.pixels[ind] >>  8 & 0xFF, 
							  bframe.pixels[ind] >>  4 & 0xFF);
			dpg.pixels[ind] = col;
		  }
	}

	dpg.updatePixels();
 	
 	image(dpg, 0, 0, width, height);

	if(recording) {
		if (frameCount<=numFrames) saveFrame("frames/slitscan_arbitrary###.png");
		else exit();
	} else {
		image(frames[floor(time*pgNumFrames)%pgNumFrames],0,0, 100, 100);
	}
}

int f(int x, int y, float toff) { 
	int f = f(x,y);
	// toff is normalised
	return (f + mod(int(toff * pgNumFrames), pgNumFrames)) % pgNumFrames;
	// NOTE: the better way to do this would be to make this the encompassing
	// f(), and call this when no toff is given like f(x,y,0). 
}

// determine which frame to take the pixel from at a given location
int f(int x, int y) {
	// normalise
	float xn = (1.0*x)/pgWidth;
	float yn = (1.0*y)/pgHeight;
	// translate to center
	xn = (xn-0.5);	
	yn = (yn-0.5);


	//float f = 2 * noise(1/(xn*xn + yn*yn + map(mouseX,0,width,0.05,0.8)),mouseY/width) + time;
	//float f = 10 * noise(sqrt(xn*xn + yn*yn),1-xn*0.5) + time;
	float f = noise(5*xn,5*yn) + time;
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
	pg.strokeWeight(pgWidth*0.01);
	pg.rectMode(CENTER);	

	pg.background(0);
	int numSqs = 10;
	float r = 0.3 * pgWidth;
	float w = 0.15 * pgWidth;

	for (int i=0; i<numSqs; i++) {
		pg.pushMatrix();

		float a = i * TWO_PI/numSqs + pgtime * TWO_PI/numSqs;
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