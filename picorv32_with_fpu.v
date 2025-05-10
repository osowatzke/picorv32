`timescale 1 ns / 1 ps

module picorv32_with_fpu (
        input clk, resetn,
        output reg trap,

        // Memory Interface
        output reg        mem_valid,
        output reg        mem_instr,
        input             mem_ready,

        output reg [31:0] mem_addr,
        output reg [31:0] mem_wdata,
        output reg [ 3:0] mem_wstrb,
        input      [31:0] mem_rdata,

        // Look-Ahead Interface
        output            mem_la_read,
        output            mem_la_write,
        output     [31:0] mem_la_addr,
        output reg [31:0] mem_la_wdata,
        output reg [ 3:0] mem_la_wstrb,

        // IRQ Interface
        input      [31:0] irq,
        output reg [31:0] eoi,

        // Trace Interface
        output reg        trace_valid,
        output reg [35:0] trace_data
);

    // Pico Co-Processor Interface (PCPI)
    reg        pcpi_valid;
    reg [31:0] pcpi_insn;
    reg [31:0] pcpi_rs1;
    reg [31:0] pcpi_rs2;
    reg        pcpi_wr;
    reg [31:0] pcpi_rd;
    reg        pcpi_wait;
    reg        pcpi_ready;

    // (Signals have the same name as the picorv32 module: use '.*' to autofill)
    // Enable FPU
    picorv32 #(.ENABLE_PCPI(1)) rv32_soc (.*);

    fpu fpu_i(
        .clkIn       (clk       ),
        .rstLowIn    (resetn    ),
        .pcpiValidIn (pcpi_valid),
        .pcpiInstIn  (pcpi_insn ),
        .pcpiRs1In   (pcpi_rs1  ),
        .pcpiRs2In   (pcpi_rs2  ),
        .pcpiWrOut   (pcpi_wr   ),
        .pcpiRdOut   (pcpi_rd   ),
        .pcpiWaitOut (pcpi_wait ),
        .pcpiReadyOut(pcpi_ready)
    );

endmodule