module top (
    input  logic CLK,
    output logic LCD_CLK,
    input  logic face_detected,
    input  logic busy, 
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

logic face_prev = 0;
logic [23:0] pulse_counter = 0;
logic pulse_active = 0;

logic [33:0] cooldown_counter = 0;
logic cooldown_active = 0;
localparam logic [33:0] COOLDOWN_CYCLES = 34'd5250000000;

always_ff @(posedge CLK) begin
    face_prev <= face_detected;

    if (face_detected && !face_prev && !cooldown_active) begin
        pulse_active  <= 1;
        pulse_counter <= 0;
        cooldown_active  <= 1;
        cooldown_counter <= 0;
    end

    if (pulse_active) begin
        if (pulse_counter < 24'd2500000) begin
            pulse_counter <= pulse_counter + 1;
        end else begin
            pulse_active <= 0;
        end
    end

    if (cooldown_active) begin
        if (cooldown_counter < COOLDOWN_CYCLES)
            cooldown_counter <= cooldown_counter + 1;
        else
            cooldown_active <= 0;
    end

end

assign audio_trigger = pulse_active;

endmodule