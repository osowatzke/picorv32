`timescale 1 ns / 1 ps

module picorv32_with_fpu (
        input clk, resetn,
        output reg trap,

        // Look-Ahead Interface
        output            mem_la_read,
        output            mem_la_write,
        output     [31:0] mem_la_addr,
        output reg [31:0] mem_la_wdata,
        output reg [ 3:0] mem_la_wstrb,

        // Pico Co-Processor Interface (PCPI)
        output reg        pcpi_valid,
        output reg [31:0] pcpi_insn,
        output     [31:0] pcpi_rs1,
        output     [31:0] pcpi_rs2,
        input             pcpi_wr,
        input      [31:0] pcpi_rd,
        input             pcpi_wait,
        input             pcpi_ready,

        // IRQ Interface
        input      [31:0] irq,
        output reg [31:0] eoi,

        // Trace Interface
        output reg        trace_valid,
        output reg [35:0] trace_data
);

    // Memory signals.
    reg mem_valid, mem_instr, mem_ready;
    reg [31:0] mem_addr;
    reg [31:0] mem_wdata;
    reg [ 3:0] mem_wstrb;
    reg [31:0] mem_rdata;

    // No 'ready' signal in sky130 SRAM macro; presumably it is single-cycle?
    always @(posedge clk)
        mem_ready <= mem_valid;

    // (Signals have the same name as the picorv32 module: use '.*' to autofill)
    // Enable FPU
    picorv32 #(.ENABLE_FPU(1)) rv32_soc (.*);
   
endmodule