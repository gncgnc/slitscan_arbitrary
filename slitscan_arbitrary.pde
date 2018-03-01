float numFrames = 50;
float duration = 2000;
boolean recording = false;
float time = 0;

// drawing canvas
int pgWidth = 100;
int pgHeight = pgWidth;
int pgNumFrames = 100;
int pgFrameCount = 0;
float pgtime;

PImage[] frames;
PGraphics pg; // for actual animation
Slitscan ss;


void setup(){
	size(500,500);
	frameRate(numFrames/duration*1000);

	pg = createGraphics(pgWidth, pgHeight);
	
	frames = new PImage[pgNumFrames];

	for (int i=0; i<pgNumFrames; i++) {
		pgdraw();
		frames[i] = pg.get();
	}

	ss = new TrySlitscan(frames);

	noSmooth();
}

void draw(){
	time = (frameCount%numFrames)/numFrames;
 	
 	ss.computeFrameWColor(time,0.05);
 	ss.drawFrame();

	if(recording) {
		if (frameCount<=numFrames) saveFrame("frames/slitscan_arbitrary###.png");
		else elsexit();
	} else {
		image(frames[floor(time*pgNumFrames)%pgNumFrames],0,0, 100, 100);
	}
}

int mod(int n, int m) {
    return ((n % m) + m) % m;
}

// int f(int x, int y) {
// 	// normalise
// 	float xn = (1.0*x)/pgWidth;
// 	float yn = (1.0*y)/pgHeight;
// 	// translate to center
// 	xn = (xn-0.5);	
// 	yn = (yn-0.5);

// 	// float f = noise(1/(xn*xn + yn*yn + map(mouseX,0,width,0.05,0.8)),mouseY/width) + time;
// 	float f = 7.5f*noise(sqrt(xn*xn + yn*yn)*5f) +  time;
// 	//float f = noise(5*xn,5*yn) + time;
// 	return mod(int(f * pgNumFrames), pgNumFrames);
// }


// void pgdraw() {
// 	pg.beginDraw();
// 	pgtime = 1f*pgFrameCount/pgNumFrames;

// 	pg.pushMatrix();
// 	pg.translate(pgWidth * 0.5, pgHeight * 0.5);
// 	pg.strokeWeight(pgWidth*0.01);
// 	pg.rectMode(CENTER);	

// 	pg.background(0);
// 	int numSqs = 10;
// 	float r = 0.3 * pgWidth;
// 	float w = 0.15 * pgWidth;

// 	for (int i=0; i<numSqs; i++) {
// 		pg.pushMatrix();

// 		float a = i * TWO_PI/numSqs + pgtime * TWO_PI/numSqs;
// 		float R = r * map(sin(3*a+pgtime*TWO_PI),-1,1,0.5,1);
// 		float x = R * cos(a);
// 		float y = R * sin(a);
	
// 		pg.translate(x,y);
// 		pg.rotate(a+QUARTER_PI);
// 		pg.rect(0,0,w,w);
	
// 		pg.popMatrix();
// 	}

// 	pg.popMatrix();

// 	pg.endDraw();
// 	pgFrameCount++;
// }