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
        file = $fopen(FILE_NAME, "r");
        if (file == 0) begin
            $display("Error: Could not open \"%s\"", FILE_NAME);
            $finish;
        end
    end
    
    reg [DATA_WIDTH-1:0] fileData;
    
    always @(posedge(clkIn)) begin
        if (rstIn) begin
            dataOut     <= 0;
            doneOut     <= 0;
            validOut    <= 0;
        end else begin
            validOut    <= 0;
            if (file != 0 && !$feof(file)) begin
                if (validIn) begin
                    stat = $fscanf(file, "%h\n", fileData);
                    dataOut  <= fileData; // Must assign with block assignment
                    validOut <= 1;
                    if ($feof(file)) begin
                        $fclose(file);
                        file = 0;
                    end
                end
            end else begin
                doneOut <= 1;
            end
        end
    end
        
endmodule
    