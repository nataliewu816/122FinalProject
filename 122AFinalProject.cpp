#include "pico/stdlib.h"
#include "hardware/uart.h"

void dfplayer_send(uint8_t cmd, uint8_t param1, uint8_t param2) {
    uint8_t buf[10];
    buf[0] = 0x7E;
    buf[1] = 0xFF;
    buf[2] = 0x06;
    buf[3] = cmd;
    buf[4] = 0x00;
    buf[5] = param1;
    buf[6] = param2;
    uint16_t chk = -(buf[1] + buf[2] + buf[3] + buf[4] + buf[5] + buf[6]);
    buf[7] = (chk >> 8) & 0xFF;
    buf[8] = chk & 0xFF;
    buf[9] = 0xEF;
    uart_write_blocking(uart1, buf, 10);
}

int main() {
    stdio_init_all();

    uart_init(uart1, 9600);
    gpio_set_function(4, GPIO_FUNC_UART); // GP4 TX
    gpio_set_function(5, GPIO_FUNC_UART); // GP5 RX

    // Trigger pin from FPGA
    gpio_init(15);
    gpio_set_dir(15, GPIO_IN);
    gpio_pull_down(15);

    sleep_ms(3000);
    dfplayer_send(0x06, 0x00, 0x05); // volume 5
    sleep_ms(500);
    dfplayer_send(0x0E, 0x00, 0x00); // pause at startup
    sleep_ms(500);

    bool playing = false;

    while (true) {
        bool trigger = gpio_get(15);

        if (trigger && !playing) {
            dfplayer_send(0x03, 0x00, 0x01); // play track 1
            playing = true;
        } else if (!trigger && playing) {
            dfplayer_send(0x0E, 0x00, 0x00); // pause
            playing = false;
        }
        sleep_ms(100);
    }
}