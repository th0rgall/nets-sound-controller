#include <CapacitiveSensor.h>

CapacitiveSensor   cs_2_3 = CapacitiveSensor(2,3); // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_5_6 = CapacitiveSensor(5,6); // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_8_9 = CapacitiveSensor(8,9); // 1M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_11_12 = CapacitiveSensor(11,12);
void setup()                    
{
   cs_2_3.set_CS_AutocaL_Millis(0xFFFFFFFF);
   cs_5_6.set_CS_AutocaL_Millis(0xFFFFFFFF);
   cs_8_9.set_CS_AutocaL_Millis(0xFFFFFFFF);// turn off autocalibrate on channel 1 - just as an example
   cs_11_12.set_CS_AutocaL_Millis(0xFFFFFFFF);
   Serial.begin(9600);
   pinMode(4,OUTPUT);
   pinMode(7,OUTPUT);
   pinMode(10,OUTPUT);
   pinMode(13,OUTPUT);
   
}

void loop()                    
{

 
 long sensor1 =  cs_2_3.capacitiveSensor(50);
   if(sensor1 >= 1000)
   {
    digitalWrite(4,HIGH);
    Serial.write("001");
   }
   else{
    digitalWrite(4,LOW);
    Serial.write("000");

   }  

long sensor2 =  cs_5_6.capacitiveSensor(50);
   if(sensor2 >= 1000)
   {
    digitalWrite(7,HIGH);
    Serial.write("011");

   }
   else{
    digitalWrite(7,LOW);
    Serial.write("010");
   }  

long sensor3 =  cs_8_9.capacitiveSensor(50);
   if(sensor3 >= 2000)
   {
    digitalWrite(10,HIGH);
    Serial.write("101");
   }
   else{
    digitalWrite(10,LOW);
    Serial.write("100");
   }  

   long sensor4 =  cs_11_12.capacitiveSensor(50);
Serial.println(sensor4);
   if(sensor4 >= 1000)
   {
    digitalWrite(13,HIGH);
    Serial.write("111");
   }
   else{
    digitalWrite(13,LOW);
    Serial.write("110");
   } 
}
