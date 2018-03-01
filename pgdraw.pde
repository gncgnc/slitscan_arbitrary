void pgdraw() {
	pg.beginDraw();
	pgtime = 1f*pgFrameCount/pgNumFrames;

	pg.pushMatrix();
	pg.noStroke();	
	pg.background(0);
	// pg.translate(pgWidth*0.5, pgHeight*0.5);
	// pg.rotate(map(sin(pgtime*TWO_PI),-1,1,PI*0.1,-PI*0.1));
	// pg.translate(-pgWidth*0.5, -pgHeight*0.5);
	float numStripes = 8	;
	for (int i = -3; i < numStripes+3; i++) {
		float x = (i+2*pgtime)/numStripes * pgWidth;
		float w = 1f*pgWidth/numStripes;
		pg.fill((i+10)%2 * 255);
		pg.rect(x, -pgHeight, w, pgHeight*3);
	}
	

	pg.popMatrix();

	pg.endDraw();
	pgFrameCount++;
}

