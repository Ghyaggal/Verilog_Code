// megafunction wizard: %LPM_MULT%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_mult 

// ============================================================
// File Name: mul.v
// Megafunction Name(s):
// 			lpm_mult
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 15.0.0 Build 145 04/22/2015 SJ Full Version
// ************************************************************

//Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus II License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.

module mul (
	dataa,
	datab,
	result);

	input	[23:0]  dataa;
	input	[23:0]  datab;
	output	[39:0]  result;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AutoSizeResult NUMERIC "0"
// Retrieval info: PRIVATE: B_isConstant NUMERIC "0"
// Retrieval info: PRIVATE: ConstantB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: Latency NUMERIC "0"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: SignedMult NUMERIC "1"
// Retrieval info: PRIVATE: USE_MULT NUMERIC "1"
// Retrieval info: PRIVATE: ValidConstant NUMERIC "0"
// Retrieval info: PRIVATE: WidthA NUMERIC "24"
// Retrieval info: PRIVATE: WidthB NUMERIC "24"
// Retrieval info: PRIVATE: WidthP NUMERIC "40"
// Retrieval info: PRIVATE: aclr NUMERIC "0"
// Retrieval info: PRIVATE: clken NUMERIC "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: PRIVATE: optimize NUMERIC "0"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=5"
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MULT"
// Retrieval info: CONSTANT: LPM_WIDTHA NUMERIC "24"
// Retrieval info: CONSTANT: LPM_WIDTHB NUMERIC "24"
// Retrieval info: CONSTANT: LPM_WIDTHP NUMERIC "40"
// Retrieval info: USED_PORT: dataa 0 0 24 0 INPUT NODEFVAL "dataa[23..0]"
// Retrieval info: USED_PORT: datab 0 0 24 0 INPUT NODEFVAL "datab[23..0]"
// Retrieval info: USED_PORT: result 0 0 40 0 OUTPUT NODEFVAL "result[39..0]"
// Retrieval info: CONNECT: @dataa 0 0 24 0 dataa 0 0 24 0
// Retrieval info: CONNECT: @datab 0 0 24 0 datab 0 0 24 0
// Retrieval info: CONNECT: result 0 0 40 0 @result 0 0 40 0
// Retrieval info: GEN_FILE: TYPE_NORMAL mul.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mul.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mul.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mul.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL mul_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL mul_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
