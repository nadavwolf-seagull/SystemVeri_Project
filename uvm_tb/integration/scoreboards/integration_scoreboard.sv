`ifndef INTEGRATION_SCOREBOARD_SV
`define INTEGRATION_SCOREBOARD_SV

`uvm_analysis_imp_decl(_expected)
`uvm_analysis_imp_decl(_actual)

class integration_scoreboard extends uvm_component;

    `uvm_component_utils(integration_scoreboard)

    uvm_analysis_imp_expected #(
        integration_rsp_item,
        integration_scoreboard
    ) expected_imp;

    uvm_analysis_imp_actual #(
        integration_rsp_item,
        integration_scoreboard
    ) actual_imp;

    integration_rsp_item expected_queue[$];

    int unsigned pass_count;
    int unsigned fail_count;
    int unsigned actual_count;

    function new(
        string name = "integration_scoreboard",
        uvm_component parent = null
    );
        super.new(name, parent);

        expected_imp = new("expected_imp", this);
        actual_imp   = new("actual_imp", this);

        pass_count   = 0;
        fail_count   = 0;
        actual_count = 0;
    endfunction

    function void write_expected(
        integration_rsp_item item
    );
        expected_queue.push_back(item);

        `uvm_info(
            "INT_SCB",
            $sformatf(
                "Queued expected response: %s",
                item.convert2string()
            ),
            UVM_MEDIUM
        )
    endfunction

    function void write_actual(
        integration_rsp_item actual
    );
        integration_rsp_item expected;
        bit match;

        actual_count++;

        if (expected_queue.size() == 0) begin
            fail_count++;

            `uvm_error(
                "INT_SCB",
                $sformatf(
                    "Unexpected DUT response: %s",
                    actual.convert2string()
                )
            )
            return;
        end

        expected = expected_queue.pop_front();
        match    = 1'b1;

        if (expected.kind != actual.kind)
            match = 1'b0;

        case (expected.kind)
            INT_RSP_RGF_READ: begin
                if (expected.addr[3:0] != actual.addr[3:0])
                    match = 1'b0;

                if (expected.data != actual.data)
                    match = 1'b0;
            end

            INT_RSP_PIXEL_READ: begin
                // The RTL returns the low 16 bits of the pixel-alias
                // byte offset, not decoded row/column fields.
                if (expected.pixel_offset != actual.pixel_offset)
                    match = 1'b0;

                if (expected.pixel != actual.pixel)
                    match = 1'b0;
            end

            default:
                match = 1'b0;
        endcase

        if (actual.parity_error ||
            actual.framing_error) begin
            match = 1'b0;
        end

        if (match) begin
            pass_count++;

            `uvm_info(
                "INT_SCB_PASS",
                $sformatf(
                    "PASS expected=%s actual=%s",
                    expected.convert2string(),
                    actual.convert2string()
                ),
                UVM_LOW
            )
        end
        else begin
            fail_count++;

            `uvm_error(
                "INT_SCB_FAIL",
                $sformatf(
                    "FAIL expected=%s actual=%s",
                    expected.convert2string(),
                    actual.convert2string()
                )
            )
        end
    endfunction

    function int unsigned pending_count();
        return expected_queue.size();
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "INT_SCB_SUMMARY",
            $sformatf(
                {
                    "Integration scoreboard: ",
                    "PASS=%0d FAIL=%0d ACTUAL=%0d PENDING=%0d"
                },
                pass_count,
                fail_count,
                actual_count,
                expected_queue.size()
            ),
            UVM_LOW
        )

        if (expected_queue.size() != 0) begin
            `uvm_error(
                "INT_SCB_PENDING",
                $sformatf(
                    "%0d expected responses were not observed",
                    expected_queue.size()
                )
            )
        end
    endfunction

endclass

`endif
