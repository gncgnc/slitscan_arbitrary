abstract class Slitscan {
	/*
	// setup
	// draw frames...

	Slitscan ss = new Slitscan(frames);
	
	// draw 
	ss.computeFrame(time);
	ss.drawFrame();
	*/

	PGraphics pg; // dpg
	PImage[] frames;
	int frameWidth;
	int frameHeight;

	Slitscan(PImage[] frames) {
		this.frames = frames;
		this.frameWidth = frames[0].width; 
		this.frameHeight = frames[0].height; 

		this.pg = createGraphics(frameWidth, frameHeight);

		this.pg.beginDraw();
		this.pg.endDraw();

	}

	public void drawFrame() {
		image(this.pg, 0, 0, width, height);
	}
	
	public void computeFrame(float time) {
		this.pg.loadPixels();

		for (int i=0; i<this.pg.width; i++) {
			for (int j=0; j<this.pg.width; j++) {
				int ind = i + j * pgWidth;
				// determine which frame to take the pixel from in this location:
				int f = f(i,j,time); 
				PImage frame = frames[f];
				frame.loadPixels();
				this.pg.pixels[ind] = frame.pixels[ind];
			}
		}

		this.pg.updatePixels();	
	}

	public void computeFrameWColor(float time, float toff) {
		this.pg.loadPixels();

		for (int i=0; i<pgWidth; i++) {
			for (int j=0; j<pgHeight; j++) {
				int ind = i + j * pgWidth;
				int rf = f(i,j,time,toff);
				int gf = f(i,j,time);
				int bf = f(i,j,time, -toff);

				PImage rframe = frames[rf];
				PImage gframe = frames[gf];
				PImage bframe = frames[bf];
				
				rframe.loadPixels(); gframe.loadPixels(); bframe.loadPixels();
				color col = color(rframe.pixels[ind] >> 16 & 0xFF,
								  gframe.pixels[ind] >>  8 & 0xFF, 
								  bframe.pixels[ind] >>  4 & 0xFF);
				this.pg.pixels[ind] = col;
			  }
		}

		this.pg.updatePixels();
	}

	public int f(int x, int y, float time, float toff) {
		// toff is normalised
		int f = f(x,y,time);
		return (f + mod(int(toff * pgNumFrames), pgNumFrames)) % pgNumFrames;
	}

	public abstract int f(int x, int y, float time);
}