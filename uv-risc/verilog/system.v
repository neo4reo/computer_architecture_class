// DO NOT EDIT THIS FILE
// Top-level synthesis module
module system(
 input 	       clk,
 output [6:0]  seg,
 output [3:0]  an, 
 output        dp
);

   wire        reset, cpu_clk;
   
   auto_reset reset_gen (.clock(clk), .reset(reset));

   //cpu_clk cpuclk0 (.reset(reset),.clk_in1(clk),.clk_out1(cpu_clk));
   assign cpu_clk = clk;
      
   // Instruction memory
   wire [15:0] pc, instr;

   wire mem_we, dummy_we;
   wire [15:0] mem_in, mem_out, mem_addr;
   
   assign dummy_we = (instr[15:13] == 3'b101) && ~instr[6];
   
   instr_mem imem (.clk(cpu_clk),.we(dummy_we),.data_in(mem_in),.addr(pc),.data_out(instr));

   // Data memory
   data_mem dmem (.clk(cpu_clk),.we(mem_we),
		  .addr(mem_addr),.data_in(mem_in),.data_out(mem_out));

   wire        halt;

   // Processor
   uvrisc uvrisc0 (.reset(reset),.clk(cpu_clk),.pc(pc),.instr(instr),
		   .mem_we(mem_we),.mem_addr(mem_addr),
		   .mem_in(mem_in),.mem_out(mem_out),
		   .halt(halt));

   // Display
   wire [27:0] digits;
   word_to_7seg decoder (.word(pc), .digits(digits));

   strobe strobe0 (.reset(reset), .clock(clk), .digits(digits), .seg(seg), .an(an));

   assign dp = halt;
   
endmodule
