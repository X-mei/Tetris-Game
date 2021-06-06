module processor_skeleton(
    input clock, reset,
    // self defined
    input  [2:0]  addPoints,
    input  [3:0]  blockType,
    input         rotate,
    input  [1:0]  fromGame,
    output [31:0] data_readReg1, data_readReg2, data_readReg3
    );

    wire clock_4;
    wire imem_clock, dmem_clock, processor_clock, regfile_clock;

    assign imem_clock = clock;
    assign processor_clock = ~clock_4;
    assign regfile_clock = clock_4;
    assign dmem_clock = clock;

    clock_divider clk_div(
        .clk        (clock),
        .clk_out    (clock_4)
    );

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;

    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (imem_clock),              // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (dmem_clock),         // may need to invert the clock
        .data       (data),      // data you want to write
        .wren       (wren),      // write enable
        .q          (q_dmem)     // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        regfile_clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
        // self defined
        addPoints,
        blockType,
        rotate,
        fromGame,
        data_readReg1,
        data_readReg2,
        data_readReg3
    );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        processor_clock,                // I: The master clock
        reset,                          // I: A reset signal
        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem
        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem
        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB                   // I: Data from port B of regfile
    );

endmodule
