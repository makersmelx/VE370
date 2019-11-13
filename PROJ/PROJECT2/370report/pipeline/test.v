`timescale 1ns / 1ps

module pipeline_tb;

    integer ins = 6'b0;//instruction number
    integer pc = 0;//pc address


	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	PipelinedProcessor uut (
		.clk(clk)

	);

	initial begin
		// Initialize Inputs
		clk = 0;
        $dumpfile("pipeline.vcd");
        $dumpvars(1, uut);
        $display("Textual result of pipeline:");
        $display("==========================================================");
        #800;
        $stop;
	end

    always #10 begin
        $display("Time:%d, CLK = %d, PC = 0x%H", ins, clk, uut.PCout);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.theRegister.registers[16], uut.theRegister.registers[17], uut.theRegister.registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.theRegister.registers[19], uut.theRegister.registers[20], uut.theRegister.registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.theRegister.registers[22], uut.theRegister.registers[23], uut.theRegister.registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.theRegister.registers[9], uut.theRegister.registers[10], uut.theRegister.registers[11]);
        $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H", uut.theRegister.registers[12], uut.theRegister.registers[13], uut.theRegister.registers[14]);
        $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H", uut.theRegister.registers[15], uut.theRegister.registers[24], uut.theRegister.registers[25]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        if (~clk) ins = ins + 1;
        pc = uut.PCout;
    end



endmodule
