#pragma  once
/* Includes */
#include <stm32l476xx.h>

class TIM2_c {

public:
    TIM2_c()
    {
        start_delay_counter();
    }
      void disable_timer();

    static uint8_t delay_us1(uint32_t us);
    static uint8_t delay_us2(uint32_t us);

private:
    void start_delay_counter(   );

};




#include <mdhal/timer2.hpp>



void TIM2_c::start_delay_counter( )
{
    /* Enable TIM2 clock */
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
    TIM2->CR1=0;
    /* Set counter direction as up-counter */
    TIM2->CR1 = ~TIM_CR1_DIR;

    /* Set timer Prescaler, bus clock = 4 MHz, fCK_PSC / (PSC[15:0] + 1)
     * CK_CNT = 4M / (3 + 1) -> 1M Hz -> time base = 1 us  */
    TIM2->PSC =   0;
    //TIM2->CR1|=TIM_CR1_CMS_1;
    /* Set timer reload value */
    TIM2->ARR = 0;

    /* Enable TIM2 counter */
    TIM2->CR1 |= TIM_CR1_CEN;
}


void TIM2_c:: disable_timer()
{
    TIM2->CR1 &= ~TIM_CR1_CEN;

}

uint8_t TIM2_c:: delay_us1(uint32_t us)
{
    /* Set counter direction as up-counter */

    static uint8_t  pcounter=0;
    static uint32_t tot_del;
    uint8_t fstatus=0;
    if(pcounter ==0)
    { fstatus=0;
        uint32_t tempus;

        tempus=TIM2->CNT;
        tot_del=tempus+us*4;
        if((uint32_t)(tot_del)>0XFFFFFFFF) // timer2 is 32 bits
        {

        }
        else
        {
            pcounter++;
        }

    }

    if (pcounter==1)
    {



        if(TIM2->CNT>tot_del)
        {
            fstatus=1;
            pcounter=0;
            tot_del=0;
            return fstatus;
        }

        else
        {
            return 0;
        }
    }

    return fstatus;
}


uint8_t TIM2_c:: delay_us2(uint32_t us)
{
    static uint8_t  pcounter=0;
    static uint32_t tot_del;
    uint8_t fstatus=0;
    if(pcounter ==0)
    { fstatus=0;
        uint32_t tempus;

        tempus=TIM2->CNT;
        tot_del=tempus+us*4;
        if((uint32_t)(tot_del)>0XFFFFFFFF) // timer2 is 32 bits
        {

        }
        else
        {
            pcounter++;
        }

    }
    if (pcounter==1)
    {



        if(TIM2->CNT>tot_del)
        {
            fstatus=1;
            pcounter=0;
            return fstatus;
        }
        else
        {
            return 0;
        }

    }

    return fstatus;
}
