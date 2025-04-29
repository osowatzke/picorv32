// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

module testbench;
	reg clk = 1;
	reg resetn = 0;
	wire trap;

    parameter DATA_A_FILE = "dataA.txt";
    parameter DATA_B_FILE = "dataB.txt";
    parameter DATA_Y_FILE = "dataY.txt";
    
	always #5 clk = ~clk;

    wire validA, validB, validY;
    wire doneA, doneB, doneY;
    wire [31:0] dataA, dataB, dataY;
    
	initial begin
		if ($test$plusargs("vcd")) begin
			$dumpfile("testbench.vcd");
			$dumpvars(0, testbench);
		end
        /*fileA = $fopen(DATA_A_FILE, "r");
        if (fileA == 0) begin
            $display("Error: Could not open \"%s\"", DATA_A_FILE);
            $finish;
        end 
        fileB = $fopen(DATA_B_FILE, "r");
        if (fileB == 0) begin
            $display("Error: Could not open \"%s\"", DATA_B_FILE);
            $fclose(fileA);
            $finish;
        end 
        fileY = $fopen(DATA_Y_FILE, "r");
        if (fileY == 0) begin
            $display("Error: Could not open \"%s\"", DATA_Y_FILE);
            $fclose(fileA);
            $fclose(fileB);
            $finish;
        end*/
		repeat (100) @(posedge clk);
		resetn <= 1;
        repeat (10000) @(posedge clk);
        $display("Error: Timeout Reached");
        /*$fclose(fileA);
        $fclose(fileB);
        $fclose(fileY);*/
        $finish;
	end

	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;

    wire memUpdate;
    
    reg err;
    wire check;
    // wire [31:0] dataA, dataB, dataY;
    
	always @(posedge clk) begin
        if (resetn == 0) begin
            err         <= 0;
        end else if (mem_valid && mem_ready && mem_wstrb) begin
            if (dataY === mem_wdata) begin
                $display("Expected (0x%08x) = Measured (0x%08x)", dataY, mem_wdata);
            end else begin
                $display("Error :: Expected (0x%08x) != Measured (0x%08x)", dataY, mem_wdata);
                err     <= 1;
            end
            if (doneA | doneB | doneY) begin
                if (err) begin
                    $display("Errors Found :(");
                end else begin
                    $display("No Errors Found :)");
                end
                $finish;
            end
            /*if ($feof(fileA)) begin
                if (err) begin
                    $display("Errors Found :(");
                end else begin
                    $display("No Errors Found :)");
                end
                $fclose(fileA);
                $fclose(fileB);
                $fclose(fileY);
                $finish;
            end else begin
                $fscanf(fileA, "%h\n", dataA);
                $fscanf(fileB, "%h\n", dataB);
                $fscanf(fileY, "%h\n", expected);
            end*/
		end
	end

    wire memWrEn;
    assign memWrEn = mem_valid && mem_ready && mem_wstrb;
    
    reg memWrEnR;
    always @(posedge clk) begin
        memWrEnR <= 0;
        if (resetn) begin
            memWrEnR <= memWrEn;
        end
    end
    
    assign check = memWrEn;  // & !memWrEn;
    
    file_source #(
        .DATA_WIDTH(32),
        .FILE_NAME(DATA_A_FILE)
    ) source_a (
        .clkIn   (clk),
        .rstIn   (!resetn),
        .validIn (check),
        .validOut(validA),
        .doneOut (doneA),
        .dataOut (dataA)
    );
    
    file_source #(
        .DATA_WIDTH(32),
        .FILE_NAME(DATA_B_FILE)
    ) source_b (
        .clkIn   (clk),
        .rstIn   (!resetn),
        .validIn (check),
        .validOut(validB),
        .doneOut (doneB),
        .dataOut (dataB)
    );
    
    file_source #(
        .DATA_WIDTH(32),
        .FILE_NAME(DATA_Y_FILE)
    ) source_y (
        .clkIn   (clk),
        .rstIn   (!resetn),
        .validIn (check),
        .validOut(validY),
        .doneOut (doneY),
        .dataOut (dataY)
    );
    
    assign memUpdate = validA && validB && validY;
    
	picorv32 #(
        .ENABLE_PCPI(1),
        .ENABLE_FPU (1)
	) uut (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  )
	);

	reg [31:0] memory [0:255];

	initial begin
        // Instructions
		memory[0] = 32'h 20000093; //       li      x1,512
		memory[1] = 32'h 0000a103; // loop: lw      x2,0(x1)
        memory[2] = 32'h 0040a183; //       lw      x3,4(x1)
		memory[3] = 32'h 10310253; //       fmul.s  x4,x2,x3 // should be f4, f2, and f3 (but simplified arch)
		memory[4] = 32'h 0040a423; //       sw      x4,8(x1)
		memory[5] = 32'h ff1ff06f; //       j       <loop>
        // Data
        memory[128] = 32'h 00000000;
        memory[129] = 32'h 00000000;
	end

	always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			if (mem_addr < 1024) begin
				mem_ready <= 1;
				mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			end
			/* add memory-mapped IO here */
		end
        if (memUpdate) begin
            memory[128] <= dataA;
            memory[129] <= dataB;
        end
	end
endmodule
