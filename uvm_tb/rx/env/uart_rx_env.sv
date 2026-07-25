`ifndef UART_RX_ENV_SV
`define UART_RX_ENV_SV

class uart_rx_env extends uvm_env;

    `uvm_component_utils(uart_rx_env)

    uart_rx_agent      agt;
    uart_rx_scoreboard sb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = uart_rx_agent     ::type_id::create("agt", this);
        sb  = uart_rx_scoreboard::type_id::create("sb",  this);
    endfunction

    function void connect_phase(uvm_phase phase);
        // monitor → scoreboard (מה ה-DUT הוציא)
        agt.mon.ap.connect(sb.ap_mon);
        // driver  → scoreboard (מה שלחנו)
        agt.drv.ap.connect(sb.ap_drv);
    endfunction

endclass

`endif