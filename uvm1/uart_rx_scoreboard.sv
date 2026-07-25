`ifndef UART_RX_SCOREBOARD_SV
`define UART_RX_SCOREBOARD_SV

// מייצר שני סוגי imp עם write_drv ו-write_mon
`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_mon)

class uart_rx_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_rx_scoreboard)

    // שני ports נכנסים
    uvm_analysis_imp_drv #(uart_rx_item, uart_rx_scoreboard) ap_drv;
    uvm_analysis_imp_mon #(uart_rx_item, uart_rx_scoreboard) ap_mon;

    // תור של מה שנשלח, מחכה לתגובת ה-DUT
    uart_rx_item send_q[$];

    int unsigned matched;
    int unsigned mismatched;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap_drv = new("ap_drv", this);
        ap_mon = new("ap_mon", this);
    endfunction

    // מגיע מה-driver: בית שנשלח. שים בתור.
    function void write_drv(uart_rx_item tr);
        send_q.push_back(tr);
    endfunction

    // מגיע מה-monitor: תגובת ה-DUT. הוצא מהתור והשווה.
    function void write_mon(uart_rx_item observed);
        uart_rx_item sent;
        bit exp_parity_err;
        bit exp_framing_err;

        if (send_q.size() == 0) begin
            `uvm_error("SB", "DUT response with nothing in the send queue")
            return;
        end

        sent = send_q.pop_front();


        if (sent.inject_frame_error) begin
            exp_framing_err = 1'b1;
            exp_parity_err  = 1'b0;
        end
        else if (sent.inject_parity_error) begin
            exp_framing_err = 1'b0;
            exp_parity_err  = 1'b1;
        end
        else begin
            exp_framing_err = 1'b0;
            exp_parity_err  = 1'b0;
        end

        if (observed.dut_parity_err  == exp_parity_err &&
            observed.dut_framing_err == exp_framing_err) begin
            matched++;
            `uvm_info("SB", $sformatf(
                "PASS: data=0x%02h parity_err=%0b framing_err=%0b",
                sent.data, observed.dut_parity_err, observed.dut_framing_err),
                UVM_MEDIUM)
        end
        else begin
            mismatched++;
            `uvm_error("SB", $sformatf(
                "MISMATCH data=0x%02h | expected parity=%0b framing=%0b | got parity=%0b framing=%0b",
                sent.data,
                exp_parity_err, exp_framing_err,
                observed.dut_parity_err, observed.dut_framing_err))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SB", $sformatf(
            "matched=%0d mismatched=%0d queue_left=%0d",
            matched, mismatched, send_q.size()), UVM_LOW)
    endfunction

endclass

`endif