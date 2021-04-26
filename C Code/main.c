/* ========================================
 *
 * Copyright HydroPot, 2021
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#include <project.h>

#define ledOn 0
#define ledOff 1
#define high 1
#define low 0
#define true 1
#define false 0

int post() {

    Red_LED_Write( ledOff ); // Turn Red LED off
    Green_LED_Write( ledOff ); //  Turn Green LED off
    Blue_LED_Write( ledOff ); // Turn Blue LED off
    
    int ATReceieved = true;
    char skywireCh; // Incoming character variable
    int arraySize = 500; // Array size
    char skywireCharString [arraySize]; // Array of characters
    int skywireIndex = 0; // Index of last character in array
    char com1[][100] = {
        "AT+CFUN=1\r\n",
        "AT+CEREG?\r\n",
        "AT+CESQ\r\n",
        "AT#XSOCKET=3,1,1\r\n",
        "AT#XTCPCONN=3,\"dweet.io\",80\r\n",
        "AT#XTCPSEND=3\r\n",
        "",
        "AT#XSOCKET=3,0\r\n",
    };
    int commandNumber = 0; // Index of current command in command array
        
    ADC_Start();
    ADC_StartConvert();
    Console_UART_Start(); // Start UART
    Skywire_UART_Start(); // Start UART
    
    Sky_Enable_Write( high ); // Skywire enable
    CyDelay( 5000 ); // Delay for Skywire

    while(commandNumber < 9) {

        if (ATReceieved == true) { // If our prior character was recieved
            if (commandNumber == 6) {
                ATReceieved = false; // Set ATReceived false
                // Moisture Sensor
                Moisture_Sensor_Power_Write( 1 );
                CyDelay( 100 );
                uint8 val = ADC_GetResult16(0);
                char ones = '0' + val%10;
                char tens = '0' + val/10%10;
                char hundreds = '0' + val/100%10;
                CyDelay( 100 );
                Moisture_Sensor_Power_Write( 0 );
                Skywire_UART_UartPutString("POST /dweet/for/352656103311695?moisture=");
                Skywire_UART_UartPutChar(hundreds);
                Skywire_UART_UartPutChar(tens);
                Skywire_UART_UartPutChar(ones);
                // Sunlight sensor
                CyDelay( 100 );
                val = ADC_GetResult16(1);
                ones = '0' + val%10;
                tens = '0' + val/10%10;
                hundreds = '0' + val/100%10;
                CyDelay( 100 );
                Skywire_UART_UartPutString("&light=");
                Skywire_UART_UartPutChar(hundreds);
                Skywire_UART_UartPutChar(tens);
                Skywire_UART_UartPutChar(ones);
                // Temperature Sensor
                CyDelay( 100 );
                val = ADC_GetResult16(2);
                ones = '0' + val%10;
                tens = '0' + val/10%10;
                hundreds = '0' + val/100%10;
                CyDelay( 100 );
                Skywire_UART_UartPutString("&temperature=");
                Skywire_UART_UartPutChar(hundreds);
                Skywire_UART_UartPutChar(tens);
                Skywire_UART_UartPutChar(ones);
                Skywire_UART_UartPutString("&watering=0 HTTP/1.1\x0D\x0A\x0D\x0A\x1A\x1A\r\n");
                CyDelay( 100 ); // Delay
            } else {
                CyDelay( 500 ); // Delay for Skywire
                Green_LED_Write( ledOn ); // Turn on Green LED
                ATReceieved = false; // Set ATReceived false
                CyDelay( 100 ); // Delay
                Skywire_UART_UartPutString(com1[commandNumber]); // Send the current character
                CyDelay( 100 ); // Delay
                Green_LED_Write( ledOff ); // Turn off Green LED
            }
        }
        
        skywireCh = Skywire_UART_UartGetByte(); // Get a character from the keyboard as it is typed
        Console_UART_UartPutChar(skywireCh);

        if(skywireCh != 0u) { // If there is a character
            if (skywireIndex < arraySize-1) { // The array needs an extra character to hold the trailing \0 that is appended by PSoC
                Blue_LED_Write( ledOn ); // Turn on Blue LED
                if (skywireCh == '\r') {
                    skywireIndex = 0; // Reset index for new line
                    if (skywireCharString[1]=='O' && skywireCharString[2]=='K') { // If we recieved okay
                        ATReceieved = true; // Command recieved
                        commandNumber += 1; // Increment current command
                        CyDelay( 100 ); // Delay
                    } else if (skywireCharString[1]=='E' && skywireCharString[2]=='R') { // If we recieved error
                        ATReceieved = true; // Command recieved
                        commandNumber = 7; // Increment current command
                        CyDelay( 100 ); // Delay
                    } else if (commandNumber == 1 && (skywireCharString[9] != '1' && skywireCharString[11] != '0')) { // If we recieved +CEREG: 0,1
                        ATReceieved = true; // Command recieved
                        commandNumber = 0; // Increment current command
                        CyDelay( 100 ); //Delay
                    }
                } else if (skywireCh == '>') {
                    ATReceieved = true; // Command recieved
                    commandNumber += 1; // Increment current command
                } else { // If the character is not a character return
                    skywireCharString[skywireIndex] = skywireCh; // Add it to the string array
                    skywireIndex += 1; // Increment the array index
                }
                Blue_LED_Write( ledOff ); // Turn off Blue LED
            } else {
                Red_LED_Write( ledOn ); // Turn on Red LED
            }
        }
    }
    return 0;
}

char get() {

    Red_LED_Write( ledOff ); // Turn Red LED off
    Green_LED_Write( ledOff ); //  Turn Green LED off
    Blue_LED_Write( ledOff ); // Turn Blue LED off
    
    int ATReceieved = true;
    char skywireCh; // Incoming character variable
    int arraySize = 500; // Array size
    char skywireCharString [arraySize]; // Array of characters
    int skywireIndex = 0; // Index of last character in array
    int watering = 0; // Index of last character in array
    char com1[][100] = {
        "AT+CFUN=1\r\n",
        "AT+CEREG?\r\n",
        "AT+CESQ\r\n",
        "AT#XSOCKET=3,1,1\r\n",
        "AT#XTCPCONN=3,\"dweet.io\",80\r\n",
        "AT#XTCPSEND=3\r\n",
        "GET /get/latest/dweet/for/352656103311695 HTTP/1.1\x0D\x0A\x0D\x0A\x1A\x1A\r\n",
        "AT#XTCPRECV=3,500,10\r\n",
        "AT#XSOCKET=3,0\r\n",
    };
    int commandNumber = 0; // Index of current command in command array
    int timeout = 10000;

    ADC_Start();
    ADC_StartConvert();
    Console_UART_Start(); // Start UART
    Skywire_UART_Start(); // Start UART
    
    Sky_Enable_Write( high ); // Skywire enable
    CyDelay( 5000 ); // Delay for Skywire
    
    while(timeout >= 0) {

        if (ATReceieved == true) { // If our prior character was recieved
            CyDelay( 500 ); // Delay for Skywire
            ATReceieved = false; // Set ATReceived false
            CyDelay( 100 ); // Delay
            Skywire_UART_UartPutString(com1[commandNumber]); // Send the current character
            CyDelay( 100 ); // Delay
        }

        if(Skywire_UART_SpiUartGetRxBufferSize() > 0) {
        
            int timeout = 10000; // Reset tiemout
            skywireCh = Skywire_UART_UartGetByte(); // Get a character from the keyboard as it is typed
            Console_UART_UartPutChar(skywireCh);

            if(skywireCh != 0u) { // If there is a character
                if (skywireIndex < arraySize-1) { // The array needs an extra character to hold the trailing \0 that is appended by PSoC
                    if (skywireCh == '\r') {
                        skywireIndex = 0; // Reset index for new line
                        if (commandNumber != 9 && skywireCharString[1]=='O' && skywireCharString[2]=='K') { // If we recieved okay
                            ATReceieved = true; // Command recieved
                            commandNumber += 1; // Increment current command
                            CyDelay( 100 ); // Delay
                        } else if (skywireCharString[1]=='E' && skywireCharString[2]=='R') { // If we recieved error
                            ATReceieved = true; // Command recieved
                            commandNumber = 8; // Increment current command
                            CyDelay( 100 ); // Delay
                        } else if (commandNumber == 1 && (skywireCharString[9] != '1' && skywireCharString[11] != '0')) { // If we recieved +CEREG: 0,1
                            ATReceieved = true; // Command recieved
                            commandNumber = 0; // Increment current command
                            CyDelay( 100 ); //Delay
                        } else if (commandNumber == 9 && skywireCharString[1]=='O' && skywireCharString[2]=='K') {
                            return watering;
                        }
                        // Clear skywireCharString and look for watering value
                        for(int i = 0; i < 489; i++) {
                            if(skywireCharString[i] == 'w' && skywireCharString[i+1] == 'a' && skywireCharString[i+2] == 't' && skywireCharString[i+3] == 'e' && skywireCharString[i+4] == 'r') {
                                watering = skywireCharString[i+10];
                                Console_UART_UartPutString("\n\r");
                                Console_UART_UartPutChar(skywireCharString[i+10]);
                            }
                            skywireCharString[i] = '0';
                        }
                    } else if (skywireCh == '>') {
                        ATReceieved = true; // Command recieved
                        commandNumber += 1; // Increment current command
                    } else { // If the character is not a character return
                        skywireCharString[skywireIndex] = skywireCh; // Add it to the string array
                        skywireIndex += 1; // Increment the array index
                    }
                } else {
                    Red_LED_Write( ledOn ); // Turn on Red LED
                }
            }
        } else {
            CyDelay(100);
            timeoutUs -= 10;
        }
    }

    return 0;
}

int main() {
    int incrementer = 0;
    for(;;) {
        char val = get();
        if (val == '1') {
            Pump_Power_Write( 1 );
            CyDelay( 3000 );
            Pump_Power_Write( 0 );
            CyDelay( 1000 );
            post();
        } else if (val == '2') {
            Pump_Power_Write( 1 );
            CyDelay( 6000 );
            Pump_Power_Write( 0 );
            CyDelay( 1000 );
            post();
        } else if (val == '3') {
            Pump_Power_Write( 1 );
            CyDelay( 9000 );
            Pump_Power_Write( 0 );
            CyDelay( 1000 );
            post();
        } else {
            Red_LED_Write( ledOn );
        }
        incrementer++;
        if (incrementer%30 == 0) {
            post();   
        }
    }
}