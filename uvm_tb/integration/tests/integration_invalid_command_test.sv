`ifndef INTEGRATION_INVALID_COMMAND_TEST_SV
`define INTEGRATION_INVALID_COMMAND_TEST_SV

class integration_invalid_command_test extends uvm_test;

    `uvm_component_utils(integration_invalid_command_test)

    integration_env env;
    virtual integration_if vif;

    function new(
        string name = "integration_invalid_command_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = integration_env::type_id::create(
            "env",
            this
        );

        if (!uvm_config_db#(virtual integration_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                "INT_INVALID_TEST",
                "Failed to get integration_if"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        integration_invalid_command_sequence seq;

        bit parse_error_seen;
        bit classifier_error_seen;

        phase.raise_objection(this);

        wait (
            (vif.rst_ctrl_n === 1'b1) &&
            (vif.rst_img_n  === 1'b1) &&
            (vif.rst_uart_n === 1'b1)
        );

        repeat (20)
            @(posedge vif.clk_uart);

        parse_error_seen      = 1'b0;
        classifier_error_seen = 1'b0;

        seq =
            integration_invalid_command_sequence::type_id::create(
                "seq"
            );

        fork
            begin : error_monitor
                while (!(parse_error_seen ||
                         classifier_error_seen)) begin
                    @(posedge vif.clk_uart);

                    if (vif.rx_parse_error === 1'b1)
                        parse_error_seen = 1'b1;

                    if (vif.rx_classifier_error === 1'b1)
                        classifier_error_seen = 1'b1;
                end
            end

            begin : sequence_runner
                seq.start(env.rx_agent.sequencer);
            end
        join_any

        // Allow the complete command to propagate through the pipeline.
        repeat (200)
            @(posedge vif.clk_uart);

        if (!(parse_error_seen ||
              classifier_error_seen)) begin
            `uvm_error(
                "INT_INVALID_TEST",
                "Invalid UART command was not rejected"
            )
        end
        else begin
            `uvm_info(
                "INT_INVALID_PASS",
                $sformatf(
                    {
                        "Invalid command rejected: ",
                        "parse_error_seen=%0b ",
                        "classifier_error_seen=%0b"
                    },
                    parse_error_seen,
                    classifier_error_seen
                ),
                UVM_LOW
            )
        end

        if (vif.rgf_error === 1'b1) begin
            `uvm_info(
                "INT_INVALID_STATUS",
                "Top-level rgf_error is asserted",
                UVM_LOW
            )
        end

        disable fork;

        phase.drop_objection(this);
    endtask

endclass

`endif
