`ifndef MODULE_SIGN_EXTEND
`define MODULE_SIGN_EXTEND

module signExtend (
	input	[15:0]	in,
	output	[31:0]	out
);

	assign out = {{16{in[15]}},in[15:0]};

endmodule

`endif