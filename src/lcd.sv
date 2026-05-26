module lcd (
    input  logic pclk,
    input  logic face_detected,
    output logic LCD_DEN,
    output logic [4:0] LCD_R,
    output logic [5:0] LCD_G,
    output logic [4:0] LCD_B
);

localparam width   = 480;
localparam height  = 272;
localparam xBuffer = 525;
localparam yBuffer = 285;

logic [9:0] x = 0;
logic [8:0] y = 0;

always_ff @(posedge pclk) begin
    if (x == xBuffer - 1) begin
        x <= 0;
        if (y == yBuffer - 1)
            y <= 0;
        else
            y <= y + 1;
    end else begin
        x <= x + 1;
    end
end

assign LCD_DEN = (x < width) && (y < height);

// Red when no face, green when face detected
always_comb begin
    if (!LCD_DEN) begin
        LCD_R = 5'd0;
        LCD_G = 6'd0;
        LCD_B = 5'd0;
    end else if (face_detected) begin
        // Green screen
        LCD_R = 5'd0;
        LCD_G = 6'd63;
        LCD_B = 5'd0;
    end else begin
        // Red screen
        LCD_R = 5'd31;
        LCD_G = 6'd0;
        LCD_B = 5'd0;
    end
end

endmodule