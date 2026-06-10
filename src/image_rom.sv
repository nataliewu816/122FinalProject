module image_rom (
    input  logic clk,
    input  logic [12:0] addr,
    output logic [15:0] data
);
    logic [15:0] mem [0:8159];   // 120 x 68 = 8160 pixels
    initial $readmemh("image.mem", mem);
    always_ff @(posedge clk)
        data <= mem[addr];
endmodule