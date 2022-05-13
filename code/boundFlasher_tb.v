module boundFlasher_tb;

	parameter HALF_CYCLE = 5;
	parameter CYCLE = HALF_CYCLE * 2;

	reg flick, clk, rst;
	wire [15:0] leds;

	boundFlasher Bound_Flasher(.flick(flick), .clk(clk), .rst(rst), .LEDs(leds));

	// generate clock
	always begin
		clk = 1'b0;
		#HALF_CYCLE clk = 1'b1;
		#HALF_CYCLE;
	end

	initial begin
		rst = 0;		
		flick = 0; 		
		#2 rst = 1; 	
		
		#5 flick = 1;	// normal flow
		#1 flick = 0;	
		
		#580 flick = 1; // restart process
		#1 flick = 0;

		#30 flick = 1;	// flick at anytime slot, no change
		#1 flick = 0;

		#30 flick = 1;	// flick at fisrt state, no change
		#1 flick = 0;

		#115 flick = 1;	// flick at leds[5] in state 3 is on, go back
		#1 flick = 0;

		#169 flick = 1;	// flick at leds[10] in state 3 is on, go back
		#1 flick = 0;

		#289 flick = 1;	// flick at leds[5] in state 5 is on, go back
		#1 flick = 0;

		#68 flick = 1;	// flick at leds[10] in state 5 is on, go back
		#1 flick = 0;

		#259 rst = 0;	// reset anytime and restart process
		#50 rst = 1;
		#3 flick = 1;
		#1 flick = 0;

		#176 flick = 1; rst = 0;	// reset and flick same time
		#1 flick = 0; rst = 1;

		#(CYCLE*45) $finish;
	end

	initial begin
		$recordfile("waves");
		$recordvars("depth=0", boundFlasher_tb);
	end

endmodule