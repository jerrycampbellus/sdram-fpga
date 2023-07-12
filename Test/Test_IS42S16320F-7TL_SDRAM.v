module IS42S16320F_7TL_SDRAM_test;
`timescale	1ns/100ps

/////////// SDRAM controller for DE-10 Lite /////////// 32Mx16, 2 banks total 64Mbits
localparam 	CLK_PERIOD	=	7;	// SDRAM clock at 143 MHz, 7 ns period (6.993 ns)

//					INPUTS
reg 			clk;
reg				controller_RST;

reg		[22:0]	address;
reg				data_Write_Enable;

reg 	[31:0]	data_Write_In;
reg				operation_Request;
wire			acknowledge;

//					OUTPUTS
wire 	[31:0]	data_Read_Out;
wire			data_Read_Valid;

//					SDRAM Signals
wire	[12:0]	dram_ADDR;			
wire	[1:0]	dram_Bank;
wire			dram_CAS_N;
wire			dram_CKE;
wire			dram_Clk;
wire			dram_CS_N;
wire	[15:0]	dram_DQ;
wire			dram_LDQM;
wire			dram_RAS_N;
wire			dram_HDQM;
wire			dram_WE_N;

integer			CurrentTestCase	=	0;

IS42S16320F_7TL_SDRAM DUT
(
	// reset
    .reset(controller_RST),

    // clock
    .clk(clk),

    // address bus
    .addr(address),

    // input data bus
    .data(data_Write_In),

    // When the write enable signal is asserted, a write operation will be performed.
    .we(data_Write_Enable),

    // When the request signal is asserted, an operation will be performed.
    .req(operation_Request),

    // The acknowledge signal is asserted by the SDRAM controller when
    // a request has been accepted.
    .ack(acknowledge),

    // The valid signal is asserted when there is a valid word on the output
    // data bus.
    .valid(data_Read_Valid),

    // output data bus
    .q(data_Read_Out),
	
	// SDRAM interface IS42S16320F_7TL
    .sdram_a(dram_ADDR),
    .sdram_ba(dram_Bank),
    .sdram_dq(dram_DQ),
    .sdram_cke(dram_CKE),
    .sdram_cs_n(dram_CS_N),
    .sdram_ras_n(dram_RAS_N),
    .sdram_cas_n(dram_CAS_N),
    .sdram_we_n(dram_WE_N),
    .sdram_dqml(dram_LDQM),
    .sdram_dqmh(dram_HDQM)
);

	initial											// Generate clock
		begin
			clk = 1'b0;
			forever
				#(CLK_PERIOD/2) clk = ~clk;
		end
	initial
		begin
			#CLK_PERIOD
			controller_RST 		= 	1'b1;
			#(1*CLK_PERIOD)
			controller_RST 		= 	1'b0;
		end
	
	always @(negedge clk)
		begin
				#100000;
				case (CurrentTestCase)
					0:
						begin
							address				= 25'h1FF;
							#(10*CLK_PERIOD)
							operation_Request	= 1'b1;
							data_Write_Enable	= 1'b0;
							CurrentTestCase		= 2;
						end
					2:	
						begin
							#(5*CLK_PERIOD)
							$stop;
						end
					default:
						begin
							$display("Time = %0t", $time, " ns");
						end
				endcase
		end
		
	always @(posedge operation_Request)
		begin

			$display("************************");
			$display("**                    **");
			$display("** Operation Requested**");
			$display("**                    **");
			$display("************************");
			$display("Time = %0t", $time, " ns");
		end
	
	always @(posedge data_Read_Valid)
		begin

			$display("************************");
			$display("**                    **");
			$display("**  Data Read Valid	**");
			$display("**                    **");
			$display("************************");
			$display("Time = %0t", $time, " ns");
			$stop;
		end
	always @(negedge acknowledge)
		begin

			$display("************************");
			$display("**                    **");
			$display("**    Acknowledged    **");
			$display("**                    **");
			$display("************************");
			$display("Time = %0t", $time, " ns");
			operation_Request	= 1'b0;
		end
		
endmodule