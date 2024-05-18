// Change the DEPTH parameter in DUT and TB
module Synchronous_FIFO #(parameter DEPTH = 7, DATA_WIDTH = 6)(clk, rst_n, wr_en, rd_en, FULL, EMPTY, data_in, data_out, wr_ptr, rd_ptr);

parameter ptr_bits = $clog2(DEPTH);

input clk, rst_n, wr_en, rd_en;
output FULL, EMPTY;
input [DATA_WIDTH-1:0] data_in;
output reg [DATA_WIDTH-1:0] data_out;

reg [DATA_WIDTH-1:0] fifo [DEPTH-1:0];

// For Full, empty condition, pointer width is 1-bit more
output reg [ptr_bits:0] wr_ptr, rd_ptr;

// WRITE
always@(posedge clk)
	begin
		if (!rst_n)
			wr_ptr <= {ptr_bits{1'b0}};
			
		else if (wr_en && !FULL)
			begin
				fifo[wr_ptr[ptr_bits-1:0]] <= data_in;
				wr_ptr <= wr_ptr + 1'b1;
				
				if (wr_ptr == DEPTH-1)
					begin
						wr_ptr[ptr_bits] <= ~wr_ptr[ptr_bits];
						wr_ptr[ptr_bits-1:0] <= {ptr_bits-1{1'b0}};
					end
			end
	end

// READ
always@(posedge clk)
	begin
		if (!rst_n)
			begin
				rd_ptr <= {ptr_bits{1'b0}};
				data_out <= {DATA_WIDTH{1'b0}};
			end
		
		else if (rd_en && !EMPTY)
			begin
				data_out <= fifo[rd_ptr[ptr_bits-1:0]];
				rd_ptr <= rd_ptr + 1'b1;
				
				if (rd_ptr == DEPTH-1)
					begin
						rd_ptr[ptr_bits] <= ~rd_ptr[ptr_bits];
						rd_ptr[ptr_bits-1:0] <= {ptr_bits-1{1'b0}};
					end
			end
	end
	
assign FULL = ({!wr_ptr[ptr_bits], wr_ptr[ptr_bits-1:0]} == rd_ptr[ptr_bits:0]);
assign EMPTY = (wr_ptr[ptr_bits:0] == rd_ptr[ptr_bits:0]);

endmodule
