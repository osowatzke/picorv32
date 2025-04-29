module file_source (
    clkIn,
    rstIn,
    validIn,
    validOut,
    doneOut,
    dataOut);
    
    
    parameter DATA_WIDTH = 32;
    parameter FILE_NAME  = "data.txt";
    
    input clkIn;
    input rstIn;
    input validIn;
    
    output reg validOut;
    output reg doneOut;
    
    output reg [DATA_WIDTH-1:0] dataOut;
    
    integer file, stat;
    
    initial begin
        dataOut     <= 0;
        doneOut     <= 0;
        validOut    <= 0;
        file = $fopen(FILE_NAME, "r");
        if (file == 0) begin
            $display("Error: Could not open \"%s\"", FILE_NAME);
            $finish;
        end
        while (!$feof(file)) begin
            @(posedge clkIn)
            if (rstIn == 0 && validIn) begin
                stat = $fscanf(file, "%h\n", dataOut);
                validOut <= 1;
            end else begin
                validOut <= 0;
            end
        end
        $fclose(file);
        doneOut <= 1;
    end
        
endmodule
    