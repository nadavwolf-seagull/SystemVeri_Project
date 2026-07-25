`ifndef UART_RX_DRIVER_SV
`define UART_RX_DRIVER_SV

class uart_rx_driver extends uvm_driver #(uart_rx_item);

    `uvm_component_utils(uart_rx_driver)

    virtual uart_rx_if vif;
    uart_rx_item tr;

    uvm_analysis_port #(uart_rx_item) ap;

    localparam int unsigned BIT_TIME =
        lab12_pkg::UART_CLKS_PER_BIT;

    function new(
        string name = "uart_rx_driver",
        uvm_component parent = null
    );
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_rx_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                get_type_name(),
                "Failed to get virtual interface (vif) from uvm_config_db"
            )
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        uart_rx_item expected_tr;

        super.run_phase(phase);

        // UART line is idle-high.
        vif.rx <= 1'b1;

        // Wait until reset is released.
        while (vif.rst_n !== 1'b1)
            @(posedge vif.clk);

        // Allow the DUT synchronizer to observe a stable idle line.
        repeat (4)
            @(posedge vif.clk);

        forever begin
            seq_item_port.get_next_item(tr);

            // Create an independent expected transaction.
            expected_tr = uart_rx_item::type_id::create(
                "expected_tr"
            );

            expected_tr.data =
                tr.data;

            expected_tr.inject_parity_error =
                tr.inject_parity_error;

            expected_tr.inject_frame_error =
                tr.inject_frame_error;

            expected_tr.idle_cycles =
                tr.idle_cycles;

            // Publish expected behavior before the DUT response can arrive.
            ap.write(expected_tr);

            send_frame(tr);

            seq_item_port.item_done();
        end
    endtask

    function bit calc_parity(bit [7:0] data);
        return ^data; // Even parity bit
    endfunction

    task send_bit(bit value);
        vif.rx <= value;

        repeat (BIT_TIME)
            @(posedge vif.clk);
    endtask

    task send_frame(uart_rx_item tr);
        bit parity_bit;

        `uvm_info(
            "DRV",
            $sformatf(
                "TX data=0x%02h inject_parity=%0b inject_frame=%0b",
                tr.data,
                tr.inject_parity_error,
                tr.inject_frame_error
            ),
            UVM_LOW
        )

        // Idle period before the frame.
        repeat (tr.idle_cycles)
            send_bit(1'b1);

        parity_bit = calc_parity(tr.data);

        if (tr.inject_parity_error)
            parity_bit = ~parity_bit;

        send_bit(1'b0); // Start bit

        // UART transmits data LSB first.
        for (int unsigned i = 0; i < 8; i++)
            send_bit(tr.data[i]);

        send_bit(parity_bit);

        if (tr.inject_frame_error)
            send_bit(1'b0);
        else
            send_bit(1'b1);

        // Return to UART idle.
        send_bit(1'b1);
    endtask

endclass

`endif