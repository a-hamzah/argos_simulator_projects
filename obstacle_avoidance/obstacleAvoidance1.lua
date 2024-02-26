
-- GLOBAL VARIABLES

WHEEL_SPEED = 10

-- FUNCTIONS

function table.copy(t)
    local t2 = {}
    for k, v in pairs(t) do
       t2[k] = v
    end
    return t2
 end

 function Processobject() -- ! OBJECT SENSE WORKING FINE
    -- IS_OBJECT_SENSED = false
    sort_blob = table.copy(robot.colored_blob_omnidirectional_camera)
    log(#robot.colored_blob_omnidirectional_camera)
    if (#robot.colored_blob_omnidirectional_camera > 0) then
       table.sort(sort_blob, function(a, b) return a.distance < b.distance end)
       for i = 1, #robot.colored_blob_omnidirectional_camera do
         if sort_blob[i].color.green == 0 and sort_blob[i].color.blue == 0 and sort_blob[i].color.red == 255 then

          
            --  IS_OBJECT_SENSED = true
            --  log("object sensed")
             -- log (sort_blob[i].distance)
             -- log("angle: " .. sort_blob[i].angle)
             angl = sort_blob[i].angle
             dis1 = sort_blob[i].distance
             
          end
         break
       end
    end
    return angl, dis1
 end

function ComputeSpeedFromAngle(angle) --[[this finction returen the speed wheel given to the robot speed[1],speed[2]]
   --
if angle == nil then
log(" error angle = nil ")
end
--else
dotProduct = 0.0;
KProp = 20;
wheelsDistance = 0.14;
-- if the target angle is behind the robot, we just rotate, no forward motion
if angle > math.pi / 2 or angle < -math.pi / 2 then
dotProduct = 0.0;
else
-- else, we compute the projection of the forward motion vector with the desired angle
forwardVector = { math.cos(0), math.sin(0) }
targetVector = { math.cos(angle), math.sin(angle) }
dotProduct = forwardVector[1] * targetVector[1] + forwardVector[2] * targetVector[2]
end
-- the angular velocity component is the desired angle scaled linearly
angularVelocity = KProp * angle;
-- the final wheel speeds are compute combining the forward and angular velocities, with different signs for the left and right wheel.
speeds = { dotProduct * WHEEL_SPEED - angularVelocity * wheelsDistance,
dotProduct * WHEEL_SPEED + angularVelocity * wheelsDistance }
--[[the function returns an array where speeds[1] contains the velocity for the left wheel, and speeds[2] contains the velocity for the right wheel]]
                                      --
-- log("Speed Left: " .. speeds[1])
-- log("Speed Right: " .. speeds[2])
-- robot.wheels.set_velocity(speeds[1],speeds[2])
return speeds
--end
end

function driveAsCar(forwardSpeed, angularSpeed)
    -- Equal and opposed components for left and right wheels
    leftSpeed  = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed
    robot.wheels.set_velocity(leftSpeed, rightSpeed)
 end
 
 -- Define states
 local states = {
    WALKING = "WALKING",
    AVOIDING_OBSTACLE = "AVOIDING_OBSTACLE",
    LIGHT_DETECTED = "LIGHT_DETECTED",

 }
 
 -- Initial state
 
 
 function init()
   robot.colored_blob_omnidirectional_camera.enable()
    currentState = states.WALKING
    -- Initialization code here
 end
 
 function step()
    if currentState == states.WALKING then

       -- 1. Behavior
       driveAsCar(robot.random.uniform(5, 15), robot.random.uniform(-5, 5))  -- Walk forward
       robot.leds.set_all_colors("blue")
 
       -- 2a. Taking readings (Using proximity sensors)
       local obstacleDetected = false
       for i = 1, 5 do
          if robot.proximity[i].value ~= 0.0 then
             obstacleDetected = true
             break
          end
       end

       for i = 20, 24 do
        if robot.proximity[i].value ~= 0.0 then
           obstacleDetected = true
           break
        end
       end

       -- 2b. Detecting Food (Using Camera for red color)

       local foodDetected = false
       sort_blob1 = table.copy(robot.colored_blob_omnidirectional_camera)
       for i = 1, #robot.colored_blob_omnidirectional_camera do
        if sort_blob1[i].color.green == 0 and sort_blob1[i].color.blue == 0 and sort_blob1[i].color.red == 255 then
           foodDetected = true
           break
        end
    end
 
       -- 3a. Transition to obstacle avoidance state if an obstacle is detected
       if obstacleDetected then
          currentState = states.AVOIDING_OBSTACLE
       end

       -- 3b. Transition to MOVE TOWARDS FOOD state

       if foodDetected then
        currentState = states.LIGHT_DETECTED
       end
 
    elseif currentState == states.AVOIDING_OBSTACLE then
       driveAsCar(0, 3)  -- Avoid obstacle (adjust angular speed as needed)
 
       -- Check if obstacle is cleared
       local obstacleCleared = true
       for i = 1, 5 do
          if robot.proximity[i].value ~= 0.0 then
             obstacleCleared = false
             break
          end
       end
       for i = 20, 24 do
        if robot.proximity[i].value ~= 0.0 then
           obstacleCleared = false
           break
        end
     end
 
       -- Transition back to walking state if obstacle is cleared
       if obstacleCleared then
          currentState = states.WALKING
       end
      
    elseif currentState == states.LIGHT_DETECTED then
      
      -- Using external function to get computed data
      angle2, dis2 = Processobject()
      speedss = ComputeSpeedFromAngle(angle2)

       -- 1. Behavior
       robot.wheels.set_velocity(speedss[1], speedss[2])
       robot.leds.set_all_colors("green")

       -- 2. Taking readings (Using proximity sensors)
   --     local obstacleDetected = false
   --     for i = 1, 5 do
   --        if robot.proximity[i].value ~= 0.0 then
   --           obstacleDetected = true
   --           break
   --        end
   --     end

   --     for i = 20, 24 do
   --      if robot.proximity[i].value ~= 0.0 then
   --         obstacleDetected = true
   --         break
   --      end
   --   end
 
       -- 3. Transition to obstacle avoidance state if an obstacle is detected
      --  if obstacleDetected then
      --     currentState = states.AVOIDING_OBSTACLE
      --  end
 
         
      --    driveAsCar(0, 3)  -- Avoid obstacle (adjust angular speed as needed)
   
      --    -- Check if obstacle is cleared
      --    local obstacleCleared = true
      --    for i = 1, 5 do
      --       if robot.proximity[i].value ~= 0.0 then
      --          obstacleCleared = false
      --          break
      --       end
      --    end
      --    for i = 20, 24 do
      --     if robot.proximity[i].value ~= 0.0 then
      --        obstacleCleared = false
      --        break
      --     end
      --  end

       
    end

    
 end
 
 function reset()
    -- Reset code here
 end
 
 function destroy()
    -- Destruction code here
 end
 