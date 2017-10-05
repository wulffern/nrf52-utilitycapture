/*********************************************************************
 *        Copyright (c) 2017 Carsten Wulff Software, Norway
 * *******************************************************************
 * Created       : wulff at 2017-8-26
 * *******************************************************************
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ********************************************************************/

#include <stdint.h>
#include <string.h>
#include "nordic_common.h"
#include "nrf.h"
#include "math.h"
#include "nrf_delay.h"
#include "nrf_gpio.h"
#include "nrf_drv_gpiote.h"
#include "hal_radio.h"


#ifndef LED1
#define LED1 17
#endif


#define DMA_COUNT            (0x2000)   //RAM buffer to store data
int16_t result[DMA_COUNT] __attribute__((section (".mydata1")));
int16_t ind = 0;

uint8_t adv_pdu_template[36 + 3] =
{
    0x42, 0x24, 0x00,
    0xE2, 0xA3, 0x01, 0xE7, 0x61, 0xF7,
    0x02, 0x01, 0x04, 0x1A, 0xFF,
    0x59, 0x00, 0x02, 0x15, 0x01, 0x12, 0x23,
    0x34, 0x45, 0x56, 0x67, 0x78, 0x89, 0x9A, 0xAB, 0xBC, 0xCD, 0xDE, 0xEF, 0xF0, 0x01, 0x02, 0x03, 0x04, 0xC3
};

uint8_t adv_pdu[36 + 3] =
{
    0x42, 0x24, 0x00,
    0xE2, 0xA3, 0x01, 0xE7, 0x61, 0xF7,
    0x02, 0x01, 0x04, 0x1A, 0xFF,
    0x59, 0x00, 0x02, 0x15, 0x01, 0x12, 0x23,
    0x34, 0x45, 0x56, 0x67, 0x78, 0x89, 0x9A, 0xAB, 0xBC, 0xCD, 0xDE, 0xEF, 0xF0, 0x01, 0x02, 0x03, 0x04, 0xC3
};



bool isAddressMatch(uint8_t * p_data, uint8_t * template){

    bool isMatch = true;
    for(int i=0;i<25;i++){
        if(p_data[i] != template[i]){
            isMatch = false;
        }
    }
    return isMatch;
        }


void RADIO_IRQHandler(void){

    volatile uint32_t dummy;
    if(NRF_RADIO->EVENTS_END == 1){

        NRF_RADIO->EVENTS_END =0;



        if(isAddressMatch(adv_pdu,adv_pdu_template)){


			nrf_gpio_pin_toggle(LED1);
			
            result[ind] = (adv_pdu[37] << 8) | adv_pdu[38];
            ind++;

			if(ind >= DMA_COUNT){
				ind = 0;
			}
			
        }


		NRF_RADIO->TASKS_START = 1;
		NRF_RADIO->EVENTS_DISABLED = 0;

        // Read back event register to ensure we have cleared it before exiting IRQ handler.
        dummy = NRF_RADIO->EVENTS_END;
        dummy;

    }

}


int main(void)
{
    //Enable DC/DC
//  NRF_POWER->DCDCEN = 1;
    nrf_gpio_cfg_output(LED1);

    NRF_CLOCK->LFCLKSRC = CLOCK_LFCLKSRC_SRC_Xtal << CLOCK_LFCLKSRC_SRC_Pos;
    NRF_CLOCK->TASKS_LFCLKSTART = 1;
    while((NRF_CLOCK->EVENTS_LFCLKSTARTED == 0));
    NRF_CLOCK->EVENTS_LFCLKSTARTED = 0;



    NRF_CLOCK->TASKS_HFCLKSTART = 1;
    while(NRF_CLOCK->EVENTS_HFCLKSTARTED == 0);
    NRF_CLOCK->EVENTS_HFCLKSTARTED =0;

    hal_radio_reset();

    hal_radio_channel_index_set(38);

	NRF_RADIO->INTENSET = (RADIO_INTENSET_END_Enabled << RADIO_INTENSET_END_Pos) | (RADIO_INTENSET_DISABLED_Enabled << RADIO_INTENSET_DISABLED_Pos)  ;

	NRF_RADIO->SHORTS =     (RADIO_SHORTS_READY_START_Enabled << RADIO_SHORTS_READY_START_Pos) | \
		(RADIO_SHORTS_END_START_Enabled << RADIO_SHORTS_END_START_Pos)   ;
		
	
    NRF_RADIO->PACKETPTR = (uint32_t)&(adv_pdu[0]);
    NRF_RADIO->EVENTS_DISABLED = 0;
    NRF_RADIO->TASKS_RXEN = 1;



    for (;;)
    {


    }
}


/**
 * @}
 */
