// Testbench is default for DATA_WIDTH = 6

`timescale 1ns/1ps

module testbench #(parameter DEPTH = 8, DATA_WIDTH = 6)();

//parameter DEPTH = 8, DATA_WIDTH = 6;
parameter ptr_bits = $clog2(DEPTH);

reg clk, rst_n, wr_en, rd_en;
wire FULL, EMPTY;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;

wire [ptr_bits:0] wr_ptr, rd_ptr;

Synchronous_FIFO DUT (clk, rst_n, wr_en, rd_en, FULL, EMPTY, data_in, data_out, wr_ptr, rd_ptr);

always #5 clk = ~clk;
	
initial
	begin
			 clk = 1'b0;
		#1  rst_n = 1'b0;
			 wr_en = 1'b0;
			 rd_en = 1'b0;
		#11 rst_n = 1'b1;
	end
	
initial
	begin
		#21 rd_en = 1'b1;
		#10 rd_en = 1'b0;
		#3  data_in  = 6'b101010;
		#7  wr_en  = 1'b1;
		#10 data_in  = 6'b010101;
		#10 data_in  = 6'b000001;
		#10 data_in  = 6'b000010;
		#10 data_in  = 6'b000100;
		#10 data_in  = 6'b001000;
		#10 data_in  = 6'b010000;
		#10 data_in  = 6'b100000;
		
		#10 data_in  = 6'b110011;	// These data shouldn't
		#10 data_in  = 6'b000111;	// be written to the FIFO
		#10 data_in  = 6'b111111;	// as the FIFO is FULL rn
		
		#10 rd_en = 1'b1;

		// Not disabling wr_en to make sure that the data rd and wr
		// keeps on happening simultaneously.
		
		#10 data_in  = 6'b100001;
		#10 data_in  = 6'b010000;
		#10 data_in  = 6'b001000;
		#10 data_in  = 6'b000100;
		#10 data_in  = 6'b000010;
		#10 data_in  = 6'b000001;
		#10 data_in  = 6'b000011;

		// Disabling the wr_en to check the EMPTY condition
		    wr_en    = 1'b0;
		
		#10 data_in  = 6'b000111;
		#10 data_in  = 6'b001111;		
		#10 data_in  = 6'b011111;		
		#10 data_in  = 6'b111111;
		
		#50 $stop;
	end

endmodule
