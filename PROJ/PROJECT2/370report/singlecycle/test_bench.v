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
        #720;
        $stop;
	end

    always #10 begin
        $display("Time: %d ns, Clock = %d, PC = 0x%H", i, clk, uut.pc_out);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.ktt.regs[16], uut.ktt.regs[17], uut.ktt.regs[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.ktt.regs[19], uut.ktt.regs[20], uut.ktt.regs[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.ktt.regs[22], uut.ktt.regs[23], uut.ktt.regs[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.ktt.regs[9], uut.ktt.regs[10], uut.ktt.regs[11]);
        $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H", uut.ktt.regs[12], uut.ktt.regs[13], uut.ktt.regs[14]);
        $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H", uut.ktt.regs[15], uut.ktt.regs[24], uut.ktt.regs[25]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        i = i + 10;
    end

endmodule
