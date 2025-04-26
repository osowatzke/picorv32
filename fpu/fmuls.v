`timescale 1 ns / 1 ns

module fmuls (
    clkIn;
    rstLowIn;
    pcipValidIn;
    pcipInstIn;
    pcipRs1In;
    pcipRs2In;
    pcipWrIn;
    pcipRdOut;
    pcipWaitOut;
    pcipReadyOut)
    
    input         pcipValidIn;
    input [31:0]  pcipInstIn;
    input [31:0]  pcipRs1In;
    input [31:0]  pcipRs2In;
    input         pcipWrIn;
    
    output        pcipWrIn;
    output [31:0] pcipRdOut
    output        pcipWaitOut;
    output        pcipReadyOut;

    // Instruction format
    // fmul.s    rd rs1 rs2      31..27=0x02 rm       26..25=0 6..2=0x14 1..0=3

    // Indices into instruction
    localparam OPCODE_LO    = 0;
    localparam OPCODE_HI    = 6;
    localparam FUNCT7_LO    = 25;
    localparam FUNCT7_HI    = 31;

    // Relevant fields of fmuls instruction
    localparam [6:0] FMULS_FUNCT7 = 7'b1010011;
    localparam [6:0] FMULS_OPCODE = 7'b0001000;

    // Subregions of instruction
    wire [6:0] opcodeIn;
    wire [6:0] funct7In;

    reg instMatchR;
    reg instMatch2R;
    
    wire start;
    wire rst;
    wire done;
    
    reg [31:0] rs1R, rs2R;
    
    reg initR;
    reg pcpiReadyR;
    
    /// Multiplier Configuration
    /*localparam NUM_ADDERS_PER_STAGE = (FRAC_WIDTH + MULT_CYCLES - 1) / MULT_CYCLES; // Ceiling division
    localparam NUM_ADDER_STAGES     = $clog2(NUM_ADDERS_PER_STAGE);

    wire adderStageResult[FRAC_WIDTH+1:0] = */

    // Extract subregions of instruction
    assign opcodeIn = pcipInstIn[OPCODE_HI:OPCODE_LO];
    assign funct7In = pcipInstIn[FUNCT7_HI:FUNCT7_LO];

    // Determine whether instruction is a floating point multiply
    always @(posedge clk) begin
        if (rstLowIn) begin
            instMatchR      <= 0;
            if (pcipValidIn && funct7In == FMULS_FUNCT7 && opcodeIn == FMULS_OPCODE) begin
                instMatchR  <= 1;
            end
            instMatch2R     <= instMatchR;        
        end
        else
            instMatchR      <= 0;
            instMatch2R     <= 0;
        end
    end

    always @(posedge clk) begin
        rs1R            <= pcpiRs1In;
        rs2R            <= pcpiRs2In;
    end

    assign start         = instMatchR & (!instMatch2R || done);
    assign rst           = !rstLowIn;

    floating_point_multiply #(.FRAC_WIDTH(24), .EXP_WIDTH(8)) mult_i (
        .clkIn(clkIn),
        .rstIn(rst),
        .dataAIn(rs1R),
        .dataBIn(rs2R),
        .validIn(start),
        .dataOut(pcpiRdOut),
        .validOut(done));

    always @(posedge clk) begin
        if (rstLowIn) begin
            initR           <= 0;
            if (start) begin
                pcpiReadyR  <= 0;
            end
            else if (done || initR) begin
                pcpiReadyR  <= 1;
            end
        end
        else
            pcpiReadyR      <= 0;
            initR           <= 1;
        begin
    end

    assign pcpiWaitOut  = instMatchR;
    assign pcpiReadyOut = pcpiReadyR;
    assign pcipWrOut    = done;

endmodule
// Determine whether instruction is a floating 
/*generate
    for (stage = 0; stage < NUM_ADDER_STAGES; stage = stage + 1) begin
        
        prodR[mantissaAR 
    end 
end*/

