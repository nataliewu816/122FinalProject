module lcd (
    input  logic pclk,
    input  logic playing,           // show image when high, red when low
    input  logic [15:0] img_pixel,
    output logic [12:0] img_address,
    output logic LCD_DEN,
    output logic [4:0] LCD_R,
    output logic [5:0] LCD_G,
    output logic [4:0] LCD_B
);

localparam width   = 480;
localparam height  = 272;
localparam xBuffer = 525;
localparam yBuffer = 285;
localparam IMG_W   = 120;

logic [9:0] x = 0;
logic [8:0] y = 0;

always_ff @(posedge pclk) begin
    if (x == xBuffer - 1) begin
        x <= 0;
        if (y == yBuffer - 1) y <= 0;
        else y <= y + 1;
    end else
        x <= x + 1;
end

// 4x scale: divide scan position by 4 to index the small image
logic [6:0] img_x = x[9:2];
logic [6:0] img_y = y[8:2];
assign img_address = img_y * IMG_W + img_x;

assign LCD_DEN = (x < width) && (y < height);

logic [15:0] out_pixel;
assign out_pixel = playing ? img_pixel : 16'hF800;  // F800 = solid red

assign LCD_R = LCD_DEN ? out_pixel[15:11] : 5'd0;
assign LCD_G = LCD_DEN ? out_pixel[10:5]  : 6'd0;
assign LCD_B = LCD_DEN ? out_pixel[4:0]   : 5'd0;

endmodule