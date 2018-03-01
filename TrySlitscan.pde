class TrySlitscan extends Slitscan {
	TrySlitscan(PImage[] frames) {
		super(frames);
	}

	@Override
	int f(int x, int y, float time) {
		// normalise
		float xn = (1.0*x)/pgWidth;
		float yn = (1.0*y)/pgHeight;
		// translate to center
		xn = (xn-0.5);	
		yn = (yn-0.5);

		// float f = noise(1/(xn*xn + yn*yn + map(mouseX,0,width,0.05,0.8)),mouseY/width) + time;
		float f = 7.5f*noise(sqrt(xn*xn + yn*yn)*5f) +  time;
		//float f = noise(5*xn,5*yn) + time;
		return mod(int(f * pgNumFrames), pgNumFrames);
	}
}