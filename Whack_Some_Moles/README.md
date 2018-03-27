# Whack Some Moles
**CS M152A: Introductory Digital Design Laboratory**
*15 March 2018*

This was the final project for the course, written in verilog and uploaded to a Nexys 3 Spartan 6 FPGA. We were given the freedom to choose what we created for the final project, and essentially the only requirement was that the project would be presentable and have some componenet to display on a monitor through VGA connection to the FPGA. <br />

We built an arcade styled whack-a-mole game in which the player would be able to select one of three levels, and attempt to hit as many moles as they can in one minute. The moles appear in random locations in a four by four grid with increasing frequency as the minute timer approaces zero, and each mole hit yields the player a point. At higher levels, the speed of the moles is higher so the player has a smaller time frame in which to hit the mole. The levels are themed to reflect the severity of the mole problem and the raw power of the moles. The background starts with a nice garden in level one, progresses to a dry, very damaged garden in level two, and finally in level three the garden has been descimated and takes the form of a hellscape. <br />

A short [video](https://) of the game demonstrates the final result, and the [report](https://) contains more detailed information about the game like what buttons and switches are used and what submodules constitute the system. <br />

I worked on this project with Devan Dutta and Lewis Hong. I wrote all verilog code except for the module processing input from the digilent Pmod KYPD keypad and the LFSR module, which were respectively coded by Devan and Lewis.