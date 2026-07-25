`ifndef UART_RX_DRIVER_SV
`define UART_RX_DRIVER_SV

class uart_rx_driver extends uvm_driver #(uart_rx_item);

    `uvm_component_utils(uart_rx_driver)

    virtual uart_rx_if vif;
    uart_rx_item tr;
    uvm_analysis_port #(uart_rx_item) ap;

    localparam int unsigned BIT_TIME = UART_CLKS_PER_BIT;

    function new(string name = "uart_rx_driver",
                 uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uart_rx_if)::get(this,"","vif",vif))
            `uvm_fatal(get_type_name(),
                       "Failed to get virtual interface (vif) from uvm_config_db")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        vif.rx <= 1'b1;                 // קו UART במצב Idle

        forever begin
            seq_item_port.get_next_item(tr);
            send_frame(tr);
            ap.write(tr);
            seq_item_port.item_done();
        end
    endtask

    function bit calc_parity(bit [7:0] data);
        return ^data;                    // even parity
    endfunction

    task send_bit(bit value);
        vif.rx <= value;                 // גישה ישירה, בלי clocking block
        repeat (BIT_TIME) @(posedge vif.clk);
    endtask

    task send_frame(uart_rx_item tr);
        bit parity_bit;

        `uvm_info("DRV", $sformatf(
            "TX data=0x%02h inject_parity=%0b inject_frame=%0b",
            tr.data, tr.inject_parity_error, tr.inject_frame_error),
            UVM_LOW)

        // idle לפני הפריים
        repeat (tr.idle_cycles) send_bit(1'b1);

        // parity, עם השחתה אופציונלית
        parity_bit = calc_parity(tr.data);
        if (tr.inject_parity_error)
            parity_bit = ~parity_bit;

        send_bit(1'b0);                          // start

        for (int i = 0; i < 8; i++)
            send_bit(tr.data[i]);                // data LSB first

        send_bit(parity_bit);                    // parity (8E1)

        // stop bit
        if (tr.inject_frame_error)
            send_bit(1'b0);                      // framing error
        else
            send_bit(1'b1);

        send_bit(1'b1);                          // return to idle
    endtask

endclass

`endif