`timescale 1ns / 1ps

// Asynchronous assert, synchronous deassert reset synchronizer.
// Use one instance per clock domain.
module reset_sync #(
    parameter int unsigned STAGES = 2
) (
    input  logic clk,
    input  logic arst_n,
    output logic rst_n
);

    logic [STAGES-1:0] sync_ff;

    always_ff @(posedge clk or negedge arst_n) begin
        if (!arst_n)
            sync_ff <= '0;
        else
            sync_ff <= {sync_ff[STAGES-2:0], 1'b1};
    end

    assign rst_n = sync_ff[STAGES-1];

endmodule