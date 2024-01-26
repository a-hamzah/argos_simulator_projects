-- Use Shift + Click to select a robot
-- When a robot is selected, its variables appear in this editor

-- Use Ctrl + Click (Cmd + Click on Mac) to move a selected robot to a different location



-- Put your global variables here


-- //////////////////////////////////////////////////////////////
-- //////////////////Function to Calculate WheelSpeed////////////
-- //////////////////////////////////////////////////////////////
function driveAsCar(forwardSpeed, angularSpeed)

   -- We have an equal component, and an opposed one   
   leftSpeed  = forwardSpeed - angularSpeed
   rightSpeed = forwardSpeed + angularSpeed
 
   robot.wheels.set_velocity(leftSpeed,rightSpeed)
 end
-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- //////////////////Function for Proximity////////////
-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////

--[[ This function is executed every time you press the 'execute' button ]]
function init()
   -- write your code here...
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	-- log("Robot is moving. ID = " .. robot.id)
	-- robot.wheels.set_velocity(10,20) -- Drive in circle
   -- robot.wheels.set_velocity(20,20) -- Drive straight
   -- robot.wheels.set_velocity(20,-20) -- rotate about its axis
   driveAsCar(20,0)

   log("--Proximity Sensors--")
for i = 1,24 do
    log("Angle: " .. robot.proximity[i].angle ..
        "Value: " .. robot.proximity[i].value)
   if robot.proximity[i].value ~= 0.0 then
      driveAsCar(0,3)
      else
         driveAsCar(20,0)
   end
end



   -- TODO: Try to draw different shapes > triangles, circles, complex shapes
   
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
   -- put your code hereA
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end
