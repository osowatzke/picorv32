`timescale 1ns/1ns

module fpu (
    clkIn,
    rstLowIn,
    pcpiValidIn,
    pcpiInstIn,
    pcpiRs1In,
    pcpiRs2In,
    pcpiWrOut,
    pcpiRdOut,
    pcpiWaitOut,
    pcpiReadyOut
);

    input         clkIn;
    input         rstLowIn;
    input         pcpiValidIn;
    input [31:0]  pcpiInstIn;
    input [31:0]  pcpiRs1In;
    input [31:0]  pcpiRs2In;

    output        pcpiWrOut;
    output [31:0] pcpiRdOut;
    output        pcpiWaitOut;
    output        pcpiReadyOut;
    
    // Supported Instruction formats
    // fadd.s    rd rs1 rs2      31..27=0x00 rm       26..25=0 6..2=0x14 1..0=3
    // fsub.s    rd rs1 rs2      31..27=0x01 rm       26..25=0 6..2=0x14 1..0=3
    // fmul.s    rd rs1 rs2      31..27=0x02 rm       26..25=0 6..2=0x14 1..0=3 
    
    // Indices into instruction
    localparam OPCODE_LO    = 0;
    localparam OPCODE_HI    = 6;
    localparam FUNCT7_LO    = 25;
    localparam FUNCT7_HI    = 31;
    
    // Floating-point opcode
    localparam [6:0] FPU_OPCODE = 7'b1010011;
    
    // Function bits for each operation type
    localparam [6:0] FADDS_FUNCT7 = 7'b0000000;
    localparam [6:0] FSUBS_FUNCT7 = 7'b0000100;    
    localparam [6:0] FMULS_FUNCT7 = 7'b0001000;
    
    // Subregions of instruction
    wire [6:0] opcodeIn;
    wire [6:0] funct7In;
    
    wire rst;
    
    reg faddInstR;
    reg fmulInstR;
    reg faddInst2R;
    reg fmulInst2R;
    
    reg [31:0] rs1R;
    reg [31:0] rs2R;
    
    wire faddStart;
    wire fmulStart;
    wire faddDone;
    wire fmulDone;
    wire [31:0] faddData;
    wire [31:0] fmulData;
    
    reg pcpiWaitR;
    reg doneR;
    
    reg [31:0] pcpiRdDataR;
    
    // Extract subregions of instruction
    assign opcodeIn = pcpiInstIn[OPCODE_HI:OPCODE_LO];
    assign funct7In = pcpiInstIn[FUNCT7_HI:FUNCT7_LO];
    
    // Determine when instruction is a valid floating point operation
    always @(posedge clkIn) begin
        faddInstR                <= 0;
        fmulInstR                <= 0;
        faddInst2R               <= 0;
        fmulInst2R               <= 0;
        if (rstLowIn) begin            
            if (pcpiValidIn && opcodeIn == FPU_OPCODE) begin
                if ((funct7In == FADDS_FUNCT7) || (funct7In == FSUBS_FUNCT7)) begin
                    faddInstR    <= 1;
                end else if (funct7In == FMULS_FUNCT7) begin
                    fmulInstR    <= 1;
                end
            end
            faddInst2R           <= faddInstR;
            fmulInst2R           <= fmulInstR;
        end
    end
    
    assign faddStart = faddInstR & !faddInst2R;
    assign fmulStart = fmulInstR & !fmulInst2R;
    
    always @(posedge clkIn) begin
        rs1R            <= pcpiRs1In;
        rs2R            <= pcpiRs2In;
        if (funct7In == FSUBS_FUNCT7) begin
            rs2R[31]    <= !pcpiRs2In[31];
        end
    end
    
    assign rst = !rstLowIn;
    
    floating_point_multiply #(
        .FRAC_WIDTH(24),
        .EXP_WIDTH(8)
    ) mult_i (
        .clkIn(clkIn),
        .rstIn(rst),
        .dataAIn(rs1R),
        .dataBIn(rs2R),
        .validIn(fmulStart),
        .dataOut(fmulData),
        .validOut(fmulDone));
        
    floating_point_add #(
        .FRAC_WIDTH(24),
        .EXP_WIDTH(8)
    ) add_i (
        .clkIn(clkIn),
        .rstIn(rst),
        .dataAIn(rs1R),
        .dataBIn(rs2R),
        .validIn(faddStart),
        .dataOut(faddData),
        .validOut(faddDone));
    
    always @(posedge clkIn) begin        
        if (rstLowIn == 0) begin
            pcpiWaitR       <= 0;
            doneR           <= 0;
        end else begin
            doneR           <= faddDone || fmulDone;
            pcpiWaitR       <= faddInstR || fmulInstR;
            /*if (faddDone || fmulDone) begin
                pcpiWaitR   <= 0;
                doneR       <= 1;
            end
            if (faddStart || fmulStart) begin
                pcpiWaitR   <= 1;
            end*/
        end 
    end
    
    always @(posedge clkIn) begin
        if (faddDone) begin
            pcpiRdDataR     <= faddData;
        end else begin
            pcpiRdDataR     <= fmulData;
        end
    end    
    
    assign pcpiWaitOut  = faddInstR || fmulInstR; // pcpiWaitR;
    assign pcpiReadyOut = doneR;
    assign pcpiWrOut    = doneR;
    assign pcpiRdOut    = pcpiRdDataR;

endmodule