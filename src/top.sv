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

lcd lcd_inst (
    .pclk(CLK),
    .face_detected(face_detected),
    .LCD_DEN(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B)
);

// Rising-edge detect on face_detected, emit one short pulse
logic face_prev = 0;
logic [23:0] pulse_counter = 0;
logic pulse_active = 0;

always_ff @(posedge CLK) begin
    face_prev <= face_detected;

    if (face_detected && !face_prev) begin
        pulse_active  <= 1;
        pulse_counter <= 0;
    end

    if (pulse_active) begin
        if (pulse_counter < 24'd2500000) begin  // ~0.1s at 25MHz
            pulse_counter <= pulse_counter + 1;
        end else begin
            pulse_active <= 0;
        end
    end
end

assign audio_trigger = pulse_active;

endmodule