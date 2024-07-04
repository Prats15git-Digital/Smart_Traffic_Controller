The Smart Traffic Controller technology is devised for a smooth and accident-free traffic management system on a four-way intersection crossroad. In conventional traffic controllers, the traffic lights
controlling is based on counters where the lights glow for a fixed period of time depending on the type of road, whether it is a highway, a city-road or simple lanes. The Smart Traffic Controller, as the name goes,
controls the traffic lights based on the density of traffic at a road. There are provisions for roads given higher priority when any emergency vehicle arrives on that road, detected through sound sensors. For ensuring
traffic rules are not violated, cameras are also installed at the intersection to capture the vehicle registration number if the traffic signal is skipped. 

**Specifications** 

- The intersection is for a cross-road in which there is a main highway and connecting to it are two country roads
- The road traffic is controlled based on density of traffic; that is if there is a surge of traffic at road B and the current green signal is given to road A, the road A will be given a red and B a green. The surge
of traffic is identified by the sensors at the end of each road.
- If all roads have similar density, the priority is given to highways
- The Sound Sensors (SS) detect the presence of an emergency vehicle in its respective road, and accordingly that road is given priority for green, overriding the traffic density at any other roads
- The Cameras are for capturing traffic rule violation; whenever a red signal is skipped, the RC sensors become high and the camera module is turned on

**State Diagram**

![Screenshot 2024-07-01 174258](https://github.com/Prats15git-Digital/Smart_Traffic_Controller/assets/173728218/06554d54-c90e-4b39-82ef-d3ac18c5b027)


**Considering some Scenarios using Vivado Simulation**

**Case 1 :**

Initially there is traffic at road A (sensor a1 is 1), so the maxTraffic value is 1 due to which state s1 moves to state s2, basically traffic at road A is given green signal (state s6). <br>

After a period of 20 ns, while there is still traffic at road A (a1 is 1), there is a surge of traffic at road C denoted by the sensors (c1 and c2 both are 1). Now, the state s6 moves to s9 making the lights on road A
go yellow, a warn for red and finally s9 goes to s0 to s1 making red signal for road A. <br>

Since maxTraffic is 3 at state s1, the state goes from s1 to s4 (selecting road C) and finally to state s15 (c1 & c2 are 1). <br>

Slowly, traffic at road C starts clearing so only c1 is 1 at 40ns, allowing s15 to s14. <br>

Now at 40ns, the traffic at road B is observed by b1=1 to be high, as a result, s14 goes to s19, giving a yellow signal warn for road C and finally goes to s0. <br>

Then s0 moves again to s1 and finally to s10, making it green signal for road B.


![Screenshot 2024-07-03 234110](https://github.com/Prats15git-Digital/Smart_Traffic_Controller/assets/173728218/1fb42faf-7aa3-4e55-bf19-bb743a77449d)

