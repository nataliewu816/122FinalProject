module top (
    input  logic CLK,
    output logic LCD_CLK,
    input  logic face_detected,
    output logic LCD_DEN,
    output logic [4:0] LCD_R,
    output logic [5:0] LCD_G,
    output logic [4:0] LCD_B,
    output logic audio_trigger
);

assign LCD_CLK = CLK;
assign audio_trigger = face_detected;

lcd lcd_inst (
    .pclk(CLK),
    .face_detected(face_detected),
    .LCD_DEN(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B)
);

endmodule
