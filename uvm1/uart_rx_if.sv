`ifndef UART_RX_IF_SV
`define UART_RX_IF_SV

interface uart_rx_if(input logic clk);

    logic rst_n;
    logic rx;

    // DUT Outputs
    logic [7:0] rx_byte;
    logic       rx_byte_valid;
    logic       parity_err;
    logic       framing_err;
    logic       rx_busy;

    //------------------------------------------------------------
    // Driver Clocking Block
    //------------------------------------------------------------
    clocking drv_cb @(posedge clk);

        output rx;

        input  rx_busy;

    endclocking

    //------------------------------------------------------------
    // Monitor Clocking Block
    //------------------------------------------------------------
    clocking mon_cb @(posedge clk);

        input rx;
        input rx_byte;
        input rx_byte_valid;
        input parity_err;
        input framing_err;
        input rx_busy;

    endclocking

    //------------------------------------------------------------
    // Driver Modport
    //------------------------------------------------------------
    modport DRIVER
    (
        clocking drv_cb,

        output rst_n
    );

    //------------------------------------------------------------
    // Monitor Modport
    //------------------------------------------------------------
    modport MONITOR
    (
        clocking mon_cb,

        input rst_n
    );

endinterface

`endif