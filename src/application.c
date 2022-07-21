// Tower Kit documentation https://tower.hardwario.com/
// SDK API description https://sdk.hardwario.com/
// Forum https://forum.hardwario.com/

#define VDDA_VOLTAGE 3.3f

#include <application.h>

// LED instance
twr_led_t led;

// Application initialization function which is called once after boot
void application_init(void)
{
    // Initialize logging
    twr_log_init(TWR_LOG_LEVEL_DUMP, TWR_LOG_TIMESTAMP_ABS);

    // Initialize LED
    twr_led_init(&led, TWR_GPIO_LED, false, 0);
    twr_led_pulse(&led, 2000);

    twr_radio_init(TWR_RADIO_MODE_NODE_SLEEPING);
    twr_radio_pairing_request("skeleton", FW_VERSION);

    twr_scheduler_plan_relative(0, 1000);

}

void application_task()
{
    twr_led_blink(&led, 1);

    twr_log_debug(FW_VERSION);
    twr_log_debug(BUILD_DATE);
    twr_log_debug(GIT_VERSION);

    twr_scheduler_plan_current_relative(1000);
}
