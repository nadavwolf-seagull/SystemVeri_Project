`ifndef INTEGRATION_PIXEL_TEST_SV
`define INTEGRATION_PIXEL_TEST_SV

class integration_pixel_test extends uvm_test;

    `uvm_component_utils(integration_pixel_test)

    integration_env env;
    virtual integration_if vif;

    function new(
        string name = "integration_pixel_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env =
            integration_env::type_id::create(
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
                "INT_PIXEL_TEST",
                "Failed to get integration_if"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        integration_pixel_sequence seq;
        int unsigned timeout_cycles;

        phase.raise_objection(this);

        wait (
            (vif.rst_ctrl_n === 1'b1) &&
            (vif.rst_img_n  === 1'b1) &&
            (vif.rst_uart_n === 1'b1)
        );

        repeat (20)
            @(posedge vif.clk_uart);

        seq =
            integration_pixel_sequence::type_id::create(
                "seq"
            );

        seq.start(env.rx_agent.sequencer);

        timeout_cycles = 0;

        while (
            ((env.scoreboard.pass_count < 3) ||
             (env.scoreboard.pending_count() != 0)) &&
            (timeout_cycles < 300000)
        ) begin
            @(posedge vif.clk_uart);
            timeout_cycles++;
        end

        if (timeout_cycles >= 300000) begin
            `uvm_error(
                "INT_PIXEL_TIMEOUT",
                $sformatf(
                    {
                        "Timeout: PASS=%0d FAIL=%0d ",
                        "ACTUAL=%0d PENDING=%0d"
                    },
                    env.scoreboard.pass_count,
                    env.scoreboard.fail_count,
                    env.scoreboard.actual_count,
                    env.scoreboard.pending_count()
                )
            )
        end

        if ((env.scoreboard.pass_count == 3) &&
            (env.scoreboard.fail_count == 0) &&
            (env.scoreboard.pending_count() == 0)) begin

            `uvm_info(
                "INT_PIXEL_PASS",
                "Pixel write/read end-to-end test passed",
                UVM_LOW
            )
        end
        else begin
            `uvm_error(
                "INT_PIXEL_TEST",
                $sformatf(
                    {
                        "Unexpected result: PASS=%0d FAIL=%0d ",
                        "ACTUAL=%0d PENDING=%0d"
                    },
                    env.scoreboard.pass_count,
                    env.scoreboard.fail_count,
                    env.scoreboard.actual_count,
                    env.scoreboard.pending_count()
                )
            )
        end

        repeat (50)
            @(posedge vif.clk_uart);

        phase.drop_objection(this);
    endtask

endclass

`endif
