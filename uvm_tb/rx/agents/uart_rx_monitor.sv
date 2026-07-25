`ifndef UART_RX_MONITOR_SV
`define UART_RX_MONITOR_SV

class uart_rx_monitor extends uvm_monitor;

    `uvm_component_utils(uart_rx_monitor)

    virtual uart_rx_if vif;

    uvm_analysis_port #(uart_rx_item) ap;

    function new(
        string name = "uart_rx_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_rx_if)::get(
                this, "", "vif", vif
            )) begin
            `uvm_fatal(
                "RX_MON",
                "Failed to get uart_rx_if"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        uart_rx_item tr;

        bit frame_active;
        bit byte_seen;
        bit parity_seen;
        bit framing_seen;

        logic [7:0] captured_byte;

        frame_active  = 1'b0;
        byte_seen     = 1'b0;
        parity_seen   = 1'b0;
        framing_seen  = 1'b0;
        captured_byte = '0;

        forever begin
            @(posedge vif.clk);

            if (vif.rst_n !== 1'b1) begin
                frame_active  = 1'b0;
                byte_seen     = 1'b0;
                parity_seen   = 1'b0;
                framing_seen  = 1'b0;
                captured_byte = '0;
            end
            else begin

                // A frame is considered active while the DUT reports busy.
                if (vif.rx_busy === 1'b1)
                    frame_active = 1'b1;

                // Collect all result pulses belonging to the current frame.
                if (vif.rx_byte_valid === 1'b1) begin
                    byte_seen     = 1'b1;
                    captured_byte = vif.rx_byte;
                end

                if (vif.parity_err === 1'b1)
                    parity_seen = 1'b1;

                if (vif.framing_err === 1'b1)
                    framing_seen = 1'b1;

                // Publish exactly one transaction when the frame ends.
                if (frame_active &&
                    (vif.rx_busy === 1'b0)) begin

                    tr = uart_rx_item::type_id::create(
                        "observed_tr"
                    );

                    tr.data            = captured_byte;
                    tr.dut_parity_err  = parity_seen;
                    tr.dut_framing_err = framing_seen;

                    ap.write(tr);

                    `uvm_info(
                        "RX_MON",
                        $sformatf(
                            {
                                "Observed frame: data=0x%02h ",
                                "byte_valid_seen=%0b ",
                                "parity_err=%0b framing_err=%0b"
                            },
                            captured_byte,
                            byte_seen,
                            parity_seen,
                            framing_seen
                        ),
                        UVM_MEDIUM
                    )

                    frame_active  = 1'b0;
                    byte_seen     = 1'b0;
                    parity_seen   = 1'b0;
                    framing_seen  = 1'b0;
                    captured_byte = '0;
                end
            end
        end
    endtask

endclass

`endif