// DO NOT EDIT THIS FILE
// Top-level simulation module
module testbench;
   reg clk, reset;

   initial begin
      reset = 1;
      #12 reset = 0;
   end

   // 100MHz clock
   initial
     clk = 1;
   always #5 clk = ~clk;

   // Instruction memory
   wire [15:0] 		   pc, instr;
   
   instr_mem imem (.clk(clk),.addr(pc),.data_out(instr));

   // Data memory
   wire [15:0] 		   mem_in, mem_out, mem_addr;

   data_mem dmem (.clk(clk),.we(mem_we),
		  .addr(mem_addr),.data_in(mem_in),.data_out(mem_out));

   // Processor
   wire 		   halt;
   
   uvrisc uvrisc0 (.reset(reset),.clk(clk),.pc(pc),.instr(instr),
		   .mem_we(mem_we),.mem_addr(mem_addr),
		   .mem_in(mem_in),.mem_out(mem_out),
		   .halt(halt));

   always @(posedge clk)
     if (halt)
       $finish;
   
endmodule // testbench
