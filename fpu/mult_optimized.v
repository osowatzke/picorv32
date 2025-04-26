module mult_optimized (
	rstLowIn;
	clkIn;
	dataAIn;
	dataBIn
	validIn);
	
	parameter DATA_WIDTH	 = 32;
	parameter MULT_CYCLES	 = 4;
	parameter USE_ADDER_TREE = 1;	 
	
	generate
		if (USE_ADDER_TREE) begin
		end
		else begin
		
			// 
			parameter NUM_ADDERS = (DATA_WIDTH + MULT_CYCLES - 1)/MULT_CYCLES; // Ceiling Division
			parameter NUM_STAGES = $clog2(NUM_ADDERS);
			for 
		end
	endgenerate
endmodule
	
module partial_prod_tree (
	rstLowIn;
	clkIn;
	dataAIn;
	dataBIn;
	validIn);
	
	parameter DATA_WIDTH	= 32;
	parameter MULT_CYCLES	= 4;
	
	localparam NUM_ADDERS	= (DATA_WIDTH + MULT_CYCLES - 1)/MULT_CYCLES; // Ceiling Division
	localparam NUM_STAGES	= $clog2(NUM_ADDERS);
	
	genvar i, j;  
	
	parameter PROD_WIDTH	= 2*DATA_WIDTH;
	parameter SUM_WIDTH		= DATA_WIDTH - 1;
	
	reg [PROD_WIDTH-1:0] prodR;
	reg
	prodR 
	
	assign start = validIn && (!validR || doneR);
	
	always @(posedge clkIn) begin
		validR		<= 0;
		if (resetLowIn) begin
			validR	<= validIn;
		end
	end
	
	generate
		if (MULT_CYCLES > 1) begin
			always @(posedge clkIn) begin
				if (start) begin
					dataBR	<= {1'b0, dataBIn[DATA_WIDTH-NUM_ADDERS:0]};
				else begin
					dataBR	<= {1'b0,  dataBR[DATA_WIDTH-NUM_ADDERS:0]};
				end
			end
			assign dataB	 = start ? dataBIn : dataBR;
		else
			assign dataB	 = dataBIn;
		end
	endgenerate
	
	generate
		for (i = 0; i < NUM_STAGES; i = i + 1) begin
			
			assign dataA = dataB[j] ? dataAIn : 0;
			
			for (j = 0; j < NUM_ADDERS; j = j + 1) begin
				
				sumData[j]	   = dataB[j] ? dataAIn : 0;
				sumData[j]	   = dataB[j] ? dataAIn : 0;
				
				if (i == 0) begin
					assign sumData[j]	  = dataB[j] ? dataAIn : 0;
				end
				else begin
					assign sumData[2*j]	  = (dataB[j]) ? dataAIn : 0;
					assign sumData[2*j]	  = (dataB[j]) ? 
				end
				
				
				if (start) begin
					dataBIn[j] ? dataAIn : 0
					dataBIn[j] ? dataBIn : 0
				else
					
				begin
			end
		end
	end generate
	
endmodule

module adder_tree (
	dataAIn
	dataBIn)
	
	assign DATA_WIDTH  = 32;
	assign NUM_ADDERS	= 8;
	
	for (num
endmodule
	