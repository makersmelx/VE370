`timescale 1ns / 1ps
`include "singleCycle.v"

module singleCycleTestBench;

    integer i = 0;
	reg clk;

	singleCycle uut (
		.clk(clk)
	);

	initial begin
		clk = 0;
        $dumpfile("singleCycle.vcd");
        $dumpvars(1, uut);
        $display("Result of single cycle simulation:");
        $display("==========================================================");
        #500;
        $stop;
	end

    always #10 begin
        $display("Time: %d ns, Clock = %d, PC = 0x%H", i, clk, uut.pc_out);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.ktt.regs[16], uut.ktt.regs[17], uut.ktt.regs[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.ktt.regs[19], uut.ktt.regs[20], uut.ktt.regs[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.ktt.regs[22], uut.ktt.regs[23], uut.ktt.regs[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.ktt.regs[9], uut.ktt.regs[10], uut.ktt.regs[11]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        i = i + 10;
    end

endmodule
