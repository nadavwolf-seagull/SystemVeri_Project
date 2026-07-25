class uart_tx_packet_monitor extends uvm_monitor;

    `uvm_component_utils(uart_tx_packet_monitor)

    virtual uart_tx_if vif;

    uvm_analysis_port #(uart_tx_packet_item) analysis_port;

    function new(
        string name = "uart_tx_packet_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_tx_if)::get(
                this, "", "vif", vif
            )) begin
            `uvm_fatal(
                "TX_PKT_MON",
                "Failed to get uart_tx_if"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        uart_tx_packet_item item;

        forever begin
            @(posedge vif.sys_clk);

            if ((vif.rst_n === 1'b1) &&
                (vif.packet_valid === 1'b1) &&
                (vif.packet_ready === 1'b1)) begin

                item = uart_tx_packet_item::type_id::create(
                    "expected_item"
                );

                item.packet_data = vif.packet_data;
                item.packet_len  = vif.packet_len;

                analysis_port.write(item);

                `uvm_info(
                    "TX_PKT_MON",
                    $sformatf(
                        "Observed accepted packet: %s",
                        item.convert2string()
                    ),
                    UVM_MEDIUM
                )
            end
        end
    endtask

endclass
